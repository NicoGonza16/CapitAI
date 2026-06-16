# CapitAI

App financiera con inteligencia artificial (Flutter), lista para producción. Implementa **MVVM + Clean Architecture** con Riverpod, go_router, Dio y **Firebase Authentication**, pensada como base escalable, modular, testeable y mantenible para **web, Android e iOS**.

Marca: morado `#7C3AED`.

---

## Tabla de contenido

- [Arquitectura](#arquitectura)
- [Estructura de carpetas](#estructura-de-carpetas)
- [Flujo de la app](#flujo-de-la-app)
- [Autenticación (Firebase)](#autenticación-firebase)
- [Stack tecnológico](#stack-tecnológico)
- [Instalación](#instalación)
- [Configuración de ambientes](#configuración-de-ambientes)
- [Ejecución](#ejecución)
- [Pruebas](#pruebas)
- [Pipeline CI/CD](#pipeline-cicd)
- [Decisiones arquitectónicas](#decisiones-arquitectónicas)

---

## Arquitectura

**MVVM** sobre **Clean Architecture**, con tres capas por feature:

```
View  ──observa──►  ViewModel  ──usa──►  UseCase  ──►  Repository (abstracción)
 (UI)              (estado/lógica         (regla de        │
                    de presentación)       negocio)         ▼
                                                       RepositoryImpl
                                                        │        │
                                                     Service    Storage
                                                  (Firebase)   (Secure/Prefs)
```

Reglas estrictas:

- **Las Views no contienen lógica de negocio.** Solo observan estado y delegan acciones.
- **Toda la lógica** vive en ViewModels, UseCases y Repositories.
- **Inversión de dependencias:** las capas superiores dependen de interfaces (`AuthRepository`, `AuthService`), no de implementaciones.
- **Dirección de dependencias:** `presentation → domain ← data`. El dominio no conoce Flutter, Firebase ni JSON.
- **Patrón Result:** las operaciones devuelven `Result<T>` (`Success`/`Failure`); el repositorio traduce excepciones a la jerarquía sellada `AppException`. Sin `try/catch` dispersos.

### Flujo de datos (Login)

`LoginView` → `LoginViewModel` (StateNotifier) → `LoginUseCase` → `AuthRepository` → `AuthRepositoryImpl` → **`AuthService`** (`FirebaseAuthService` / `FakeAuthService`) + `TokenStorage`. El `AuthService` es la **única costura** con el proveedor de identidad.

---

## Estructura de carpetas

```
lib/
├── app/                      # Composición de la app (sin lógica de negocio)
│   ├── config/               # Environment / flavors
│   ├── constants/            # Constantes globales
│   ├── routes/               # go_router + nombres de ruta + guard de sesión
│   ├── startup/              # app_initializer (init de servicios clave en el splash)
│   └── themes/               # Light/Dark (Material 3) + AppColors + AppSemanticColors
│
├── core/                     # Infraestructura transversal y reutilizable
│   ├── network/              # ApiClient (Dio), interceptors (auth/retry/logging)
│   ├── services/             # Logging centralizado
│   ├── storage/              # Abstracciones KeyValue / Secure / Token
│   ├── exceptions/           # Jerarquía AppException
│   ├── extensions/           # context.l10n / colors / semantic / textStyles
│   ├── utilities/            # Result, Validators, PasswordStrength
│   ├── preview/              # previewApp para Flutter Widget Previews
│   └── widgets/              # PrimaryButton, GradientButton
│
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── services/     # AuthService (interfaz) + Fake + Firebase
│   │   │   └── repositories/ # AuthRepositoryImpl + provider
│   │   ├── domain/           # User, AuthRepository, usecases (login/register/reset)
│   │   └── presentation/     # views, viewmodels, widgets
│   ├── onboarding/           # SplashView + WelcomeView (+ ilustraciones)
│   ├── products/             # Catálogo paginado (ejemplo de AsyncNotifier)
│   └── home/
│
├── shared/                   # Paginated, ErrorView
├── i18n/                     # .arb FUENTE (es / en)   ← editar aquí
├── l10n/                     # AppLocalizations GENERADO (no editar)
├── bootstrap.dart            # arranque compartido (binding, env, Firebase, ProviderScope)
├── firebase_options.dart     # config real de Firebase (gitignored)
├── main.dart                 # entry por defecto (--dart-define=ENV)
└── main_dev/qa/prod.dart     # entrypoints por flavor
```

> **l10n:** las fuentes `.arb` viven en `lib/i18n/` y la clase `AppLocalizations` se genera en `lib/l10n/` (`output-dir` en `l10n.yaml`). Se separan para no chocar con el plugin de IDE *Flutter Intl*.

---

## Flujo de la app

```
Splash (init servicios)
   └─► ¿sesión? ── sí ──► Home
            └─ no ──► Bienvenida
                        ├─► Comenzar ───► Registro (3 pasos)
                        └─► Ya tengo cuenta ─► Login
```

**Pantallas implementadas** (todas responsivas, botón de regreso fijo arriba-izquierda):

- **Splash** — marca + inicialización de servicios clave, luego enruta.
- **Bienvenida (onboarding)** — hero con tarjeta de balance + CTAs.
- **Login** — email/contraseña (ojo de ver), recordarme, ¿olvidaste tu contraseña?, Google/Apple.
- **Registro (paso 1/3)** — nombre, correo, contraseña + **requisitos de seguridad en vivo** (se despliegan al enfocar), confirmar, aceptar términos.
- **Verificar correo (paso 2/3)** — enlace de verificación de Firebase (reenviar + "ya verifiqué").
- **Cuenta verificada (paso 3/3)** — éxito → Home.
- **Recuperar contraseña** — 4 pantallas: solicitar enlace → enviado → nueva contraseña (requisitos en vivo) → éxito.
- **Home / Products** — ejemplo de catálogo paginado con `AsyncNotifier`.

---

## Autenticación (Firebase)

Firebase Auth está **activado** (proyecto `capitai-e7b63`). La única costura es [`AuthService`](lib/features/authentication/data/services/auth_service.dart); `bootstrap.dart` inicializa Firebase e inyecta `FirebaseAuthService` (con fallback a `FakeAuthService` para desarrollo).

| Capacidad | Implementación |
|-----------|----------------|
| Email + contraseña | `signInWithEmailAndPassword` / `createUserWithEmailAndPassword` |
| Google | web → `signInWithPopup`; móvil → `google_sign_in` |
| Apple | web → `signInWithPopup`; iOS/macOS → `sign_in_with_apple` |
| Verificación de correo | enlace de Firebase (`sendEmailVerification` + `emailVerified`) — **no** OTP |
| Reset de contraseña | `sendPasswordResetEmail` / `confirmPasswordReset` |

> Detalle de configuración por plataforma (SHA-1 Android, `GoogleService-Info.plist`, client ID web, orígenes JS) y el código completo: [docs/FIREBASE_AUTH.md](docs/FIREBASE_AUTH.md).

Los archivos de config (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`) están **gitignored**. Las service-account keys NUNCA se versionan.

---

## Stack tecnológico

| Área | Librería | Motivo |
|------|----------|--------|
| Estado + DI | `flutter_riverpod` | Inyección por providers, sin Service Locator global |
| Navegación | `go_router` | Rutas centralizadas, deep linking y guards |
| Autenticación | `firebase_core` + `firebase_auth` + `google_sign_in` + `sign_in_with_apple` | Identidad y proveedores sociales |
| Networking | `dio` | Interceptores, timeouts, retry (para la API propia) |
| Persistencia | `shared_preferences` + `flutter_secure_storage` | KV no sensible y tokens seguros |
| Ambientes | `flutter_dotenv` | Variables por ambiente fuera del código |
| i18n | `flutter_localizations` + `intl` | Español e inglés |
| Testing | `flutter_test` + `mocktail` | Unit + widget tests con mocks |
| Calidad | `flutter_lints` + `riverpod_lint` | Reglas estrictas |

---

## Instalación

Requisitos: **Flutter ≥ 3.27**, **Dart ≥ 3.6** (se usa `Color.withValues`).

```bash
flutter pub get
flutter gen-l10n        # genera lib/l10n/AppLocalizations (no se versiona)
```

**Firebase:** este repo ya incluye la integración. Para conectarlo a TU proyecto:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=<tu-proyecto>
```

Esto regenera `lib/firebase_options.dart` y los archivos nativos. Habilita los proveedores en *Authentication → Sign-in method*. Ver [docs/FIREBASE_AUTH.md](docs/FIREBASE_AUTH.md).

> Plataformas activas: **web, Android, iOS**. `windows/` se elimina a propósito (sus plugins nativos exigen Modo Desarrollador en Windows).

---

## Configuración de ambientes

| Ambiente | Archivo | `ENV` |
|----------|---------|-------|
| Desarrollo | `.env.dev` | `dev` |
| QA | `.env.qa` | `qa` |
| Producción | `.env.prod` | `prod` |

Variables: `API_BASE_URL`, `API_CONNECT_TIMEOUT_MS`, `API_RECEIVE_TIMEOUT_MS`, `ENABLE_LOGGING`.

---

## Ejecución

```bash
# Web (entorno de pruebas recomendado, puerto fijo para OAuth)
flutter run -d chrome --web-port=5599

# Por ambiente (sin flavors nativos)
flutter run --dart-define=ENV=qa

# Con flavors nativos (apps coexistentes) — ver docs/FLAVORS.md
flutter run --flavor dev -t lib/main_dev.dart
flutter build appbundle --flavor prod -t lib/main_prod.dart --release
```

En VS Code, las configuraciones `dev` / `qa` / `prod` están en `.vscode/launch.json`.

---

## Pruebas

```bash
flutter test
flutter test --coverage
```

Cobertura incluida (unit + widget): `LoginUseCase`, `RegisterUseCase`, `AuthRepositoryImpl`, `LoginViewModel`, `RegisterViewModel`, ViewModels de reset de contraseña, `ProductsViewModel` (paginación), `ProductRepositoryImpl`, `Result`, `Validators`, `PasswordStrength`, y widget test de `LoginView`. Objetivo de cobertura: **80%** (verificado en CI).

---

## Pipeline CI/CD

`.github/workflows/ci.yaml` en cada push/PR:

1. `dart format --set-exit-if-changed`
2. `flutter analyze --fatal-infos`
3. `flutter test --coverage` + umbral del 80%
4. En `main`: `build apk` / `build appbundle` (flavor prod, artefactos descargables)

---

## Decisiones arquitectónicas

- **Riverpod (estado + DI):** sin Service Locator global; dependencias compuestas por providers (testeables vía overrides). Se usan `Provider`, `NotifierProvider`, `StateNotifierProvider` y `AsyncNotifierProvider`.
- **`AuthService` como única costura:** todo Firebase/Google/Apple vive detrás de una interfaz; activar/cambiar proveedor = un override en `bootstrap`. Login social **adaptativo** (web `signInWithPopup`, móvil plugins nativos).
- **Patrón Result + `AppException`:** errores como datos, exhaustivos, sin `try/catch` dispersos.
- **Splash + `app_initializer`:** punto único para inicializar servicios clave antes de la UI; el guard de go_router lo deja decidir la ruta inicial.
- **Verificación por enlace (no OTP):** Firebase no emite OTP por correo; se usa el enlace de verificación. El `VerificationService` por OTP quedaría detrás de un backend propio si se requiriera.
- **Material 3 de marca:** `ColorScheme.fromSeed(#7C3AED)` + colores anclados + `AppSemanticColors` (`ThemeExtension`). CTAs con `GradientButton`.
- **Responsivo:** `ConstrainedBox(maxWidth)` + `MediaQuery.sizeOf` + `FittedBox`; sin bloquear orientación. Botón de regreso fijo con `Stack`+`Positioned`.
- **Flavors por entrypoint + bootstrap compartido:** `main_dev/qa/prod.dart` solo difieren en el `Flavor`.
- **Seguridad:** tokens en `flutter_secure_storage`, refresh vía `AuthInterceptor`, secretos y config de Firebase fuera del repo (`.gitignore`).
- **Principios:** SOLID (sobre todo DIP), DRY, KISS y Clean Code, reforzados por `analysis_options.yaml` estricto.
```
