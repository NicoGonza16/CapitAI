# CapitAI

App financiera Flutter, lista para producción. Implementa **MVVM + Clean Architecture** con Riverpod, go_router y Dio, pensada como base escalable, modular, testeable y mantenible para Android e iOS.

---

## Tabla de contenido

- [Arquitectura](#arquitectura)
- [Estructura de carpetas](#estructura-de-carpetas)
- [Stack tecnológico](#stack-tecnológico)
- [Instalación](#instalación)
- [Configuración de ambientes](#configuración-de-ambientes)
- [Ejecución](#ejecución)
- [Pruebas y cobertura](#pruebas-y-cobertura)
- [Pipeline CI/CD](#pipeline-cicd)
- [Decisiones arquitectónicas](#decisiones-arquitectónicas)

---

## Arquitectura

El proyecto sigue **MVVM** sobre una base de **Clean Architecture** con tres capas por feature:

```
View  ──observa──►  ViewModel  ──usa──►  UseCase  ──►  Repository (abstracción)
 (UI)              (estado/lógica         (regla de        │
                    de presentación)       negocio)         ▼
                                                       RepositoryImpl
                                                        │        │
                                                   DataSource   Storage
                                                    (Dio API)   (Secure/Prefs)
```

Reglas estrictas:

- **Las Views no contienen lógica de negocio.** Solo observan estado y delegan acciones.
- **Toda la lógica** vive en ViewModels, UseCases y Repositories.
- **Inversión de dependencias:** las capas superiores dependen de interfaces (`AuthRepository`), no de implementaciones.
- **Dirección de dependencias:** `presentation → domain ← data`. El dominio no conoce Flutter, Dio ni JSON.

### Flujo de datos del ejemplo (Login)

`LoginView` → `LoginViewModel` (StateNotifier) → `LoginUseCase` → `AuthRepository` → `AuthRepositoryImpl` → `AuthRemoteDataSource` (Dio) + `TokenStorage` (Secure Storage). El resultado se modela con el **patrón Result** (`Success` / `Failure`), evitando `try/catch` dispersos.

---

## Estructura de carpetas

```
lib/
├── app/                      # Composición de la app (no lógica de negocio)
│   ├── config/               # Environment / flavors
│   ├── constants/            # Constantes globales
│   ├── routes/               # go_router + nombres de ruta + guards
│   └── themes/               # Light/Dark theme + ThemeProvider
│
├── core/                     # Infraestructura transversal y reutilizable
│   ├── network/              # ApiClient (Dio), interceptors, NetworkResponse
│   ├── services/             # Logging centralizado
│   ├── storage/              # Abstracciones KeyValue / Secure / Token
│   ├── exceptions/           # Jerarquía AppException
│   ├── extensions/           # Extensiones de BuildContext
│   ├── utilities/            # Result pattern, validators
│   └── widgets/              # Widgets reutilizables (PrimaryButton)
│
├── features/                 # Una carpeta por feature, autocontenida
│   ├── authentication/
│   │   ├── data/             # datasource, models (DTO), repositories (impl)
│   │   ├── domain/           # entities, repositories (abstract), usecases
│   │   └── presentation/     # views, viewmodels, widgets
│   ├── products/             # Catálogo paginado (ejemplo de AsyncNotifier)
│   │   ├── data/ · domain/ · presentation/
│   └── home/
│
├── shared/                   # Modelos/widgets compartidos (Paginated, ErrorView)
├── l10n/                     # Archivos .arb (es / en)
├── bootstrap.dart            # Arranque compartido por todos los flavors
├── main.dart                 # Entry point por defecto (--dart-define=ENV)
├── main_dev.dart             # Entrypoint flavor dev
├── main_qa.dart              # Entrypoint flavor qa
└── main_prod.dart            # Entrypoint flavor prod
```

---

## Stack tecnológico

| Área | Librería | Motivo |
|------|----------|--------|
| Estado + DI | `flutter_riverpod` | Inyección por providers, sin Service Locator global |
| Navegación | `go_router` | Rutas centralizadas, deep linking y guards |
| Networking | `dio` | Interceptores, timeouts, retry |
| Persistencia | `shared_preferences` + `flutter_secure_storage` | KV no sensible y almacenamiento seguro de tokens |
| Ambientes | `flutter_dotenv` | Variables por ambiente fuera del código |
| i18n | `flutter_localizations` + `intl` | Español e inglés |
| Testing | `flutter_test` + `mocktail` | Unit + widget tests con mocks |
| Calidad | `flutter_lints` + `riverpod_lint` | Reglas estrictas |

---

## Instalación

Requisitos: **Flutter ≥ 3.22**, **Dart 3+**.

```bash
flutter pub get

# Genera las localizaciones (AppLocalizations)
flutter gen-l10n

# Genera código de Riverpod (si usas riverpod_generator)
dart run build_runner build --delete-conflicting-outputs
```

> `lib/l10n/app_localizations.dart` es **generado**; no se versiona y debe crearse con `flutter gen-l10n` antes de compilar.

---

## Configuración de ambientes

Tres ambientes con su archivo `.env`:

| Ambiente | Archivo | `ENV` |
|----------|---------|-------|
| Desarrollo | `.env.dev` | `dev` |
| QA | `.env.qa` | `qa` |
| Producción | `.env.prod` | `prod` |

Variables disponibles: `API_BASE_URL`, `API_CONNECT_TIMEOUT_MS`, `API_RECEIVE_TIMEOUT_MS`, `ENABLE_LOGGING`.

> En proyectos reales, **no versiones** los `.env` con secretos: versiona solo un `.env.example` y descomenta las líneas correspondientes en `.gitignore`.

---

## Ejecución

Hay dos modos, según necesites separación nativa o no:

**a) Sin flavors nativos** — el ambiente se selecciona con `--dart-define=ENV=...`:

```bash
flutter run --dart-define=ENV=dev
flutter run --dart-define=ENV=qa
flutter run --dart-define=ENV=prod
```

**b) Con flavors nativos** (apps coexistentes, distinto `applicationId`/`bundleId`) — usa el entrypoint y el `--flavor` correspondientes (ver [docs/FLAVORS.md](docs/FLAVORS.md)):

```bash
flutter run   --flavor dev  -t lib/main_dev.dart
flutter run   --flavor qa   -t lib/main_qa.dart
flutter build appbundle --flavor prod -t lib/main_prod.dart --release
flutter build ipa       --flavor prod -t lib/main_prod.dart --release
```

En VS Code, las configuraciones `dev` / `qa` / `prod` ya están en `.vscode/launch.json`.

---

## Pruebas y cobertura

```bash
# Ejecutar todas las pruebas
flutter test

# Con reporte de cobertura
flutter test --coverage

# Visualizar cobertura (requiere lcov)
genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
```

Pruebas incluidas como ejemplo funcional:

- **Unit** — `LoginUseCase`, `AuthRepositoryImpl`, `LoginViewModel`, `ProductsViewModel` (paginación), `ProductRepositoryImpl`, `Result`, `Validators`.
- **Widget** — `LoginView` (render, validación y disparo del caso de uso).

Objetivo mínimo de cobertura: **80%** (verificado en CI).

---

## Pipeline CI/CD

`.github/workflows/ci.yaml` automatiza en cada push/PR:

1. `dart format --set-exit-if-changed`
2. `flutter analyze --fatal-infos`
3. `flutter test --coverage` + umbral del 80%
4. En `main`: `build apk` y `build appbundle` (artefactos descargables)

---

## Decisiones arquitectónicas

- **Riverpod para estado + DI:** elimina el Service Locator global; las dependencias se componen explícitamente por providers, lo que mejora la testeabilidad (overrides) y evita estado global mutable. Se usan `Provider`, `NotifierProvider`, `StateNotifierProvider` y `AsyncNotifierProvider` según el caso.
- **Patrón Result + jerarquía `AppException`:** los errores se modelan como datos, no como excepciones propagadas. Esto erradica los `try/catch` repetidos y obliga a tratar el fallo de forma exhaustiva.
- **Abstracciones de storage y red:** `KeyValueStorage`, `SecureStorage` y `ApiClient` ocultan las librerías concretas, permitiendo sustituirlas o mockearlas sin tocar el dominio.
- **DTO ≠ Entity:** los cambios del contrato del backend quedan contenidos en la capa de datos.
- **go_router con guards reactivos:** el router observa el `AuthController` y reevalúa los redirects al cambiar la sesión, habilitando deep linking seguro.
- **Seguridad:** tokens en `flutter_secure_storage`, refresh automático vía `AuthInterceptor`, secretos fuera del código vía `.env`.
- **Paginación con `AsyncNotifier` (feature Products):** `build` carga la primera página y `loadMore` anexa las siguientes conservando el estado, exponiendo `AsyncValue<List<Product>>` para una UI declarativa (loading/error/data) con scroll infinito y pull-to-refresh.
- **Flavors por entrypoint + bootstrap compartido:** `main_dev/qa/prod.dart` solo difieren en el `Flavor` inyectado; toda la inicialización vive en `bootstrap.dart`, evitando duplicación. La separación nativa (Android `productFlavors`, iOS schemes) está documentada en `docs/FLAVORS.md`.
- **Principios:** SOLID (sobre todo DIP), DRY, KISS y Clean Code, reforzados por `analysis_options.yaml` estricto.
```
