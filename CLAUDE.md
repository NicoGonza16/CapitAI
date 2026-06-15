# CLAUDE.md

Contexto para agentes que trabajen en este proyecto. Léelo antes de hacer cambios.

## Qué es

App financiera **CapitAI** (Flutter), construida sobre una plantilla empresarial reutilizable. Nombre del paquete: `capitai`. Marca: morado `#7C3AED`.

## Toolchain (importante)

- **Flutter NO está en el PATH.** Usa los binarios completos:
  - `& "C:\tools\flutter\bin\flutter.bat" ...`
  - `& "C:\tools\flutter\bin\dart.bat" ...`
- Flutter 3.44.2 / Dart 3.12.2. Floor en pubspec: SDK `>=3.6.0`, Flutter `>=3.27.0` (se usa `Color.withValues`).
- Plataformas activas: **web, android, ios**. La carpeta `windows/` se eliminó a propósito (sus plugins exigían Modo Desarrollador).
- Para previsualizar: `flutter run -d chrome --web-port=5599`. **No esperes al "served"** salvo que necesites verificar; lanza en background y continúa.

## Localización (l10n) — gotchas críticos

- Las fuentes `.arb` viven en **`lib/i18n/`** (NO en `lib/l10n/`). La clase generada `AppLocalizations` se genera en **`lib/l10n/`** (`output-dir` en `l10n.yaml`).
  - Motivo: el plugin de IDE **Flutter Intl** escribe `intl_*.arb` en `lib/l10n` y colisiona con los nuestros. Mantenerlos separados lo evita.
- Tras editar un `.arb`: `flutter gen-l10n`. Es **JSON**: nada de `\$` ni escapes inválidos (usa `$` literal).
- `synthetic-package` está deprecado: no lo uses.
- Accede a strings con `context.l10n.<clave>`.

## Arquitectura — MVVM + Clean Architecture

Capas por feature: `presentation → domain ← data`. El dominio no conoce Flutter, Dio ni proveedores externos.

```
lib/
├── app/            # composición: config (Environment/flavors), routes, themes, constants
├── core/           # transversal: network (Dio), services, storage, exceptions, extensions,
│                   #   utilities (Result, Validators, PasswordStrength), widgets, preview
├── features/<f>/
│   ├── data/       # services (costuras externas), datasource, models (DTO), repositories (impl + provider)
│   ├── domain/     # entities, repositories (abstract), usecases
│   └── presentation/  # views, viewmodels, widgets
├── shared/         # modelos/widgets compartidos (Paginated, ErrorView)
├── i18n/           # .arb fuente
├── l10n/           # AppLocalizations generado
├── bootstrap.dart  # arranque compartido (binding, env, Firebase, ProviderScope)
├── main.dart + main_dev/qa/prod.dart  # entrypoints por flavor
└── firebase_options.dart  # PLACEHOLDER hasta `flutterfire configure`
```

Features actuales: `authentication`, `onboarding`, `home`, `products`.

### Reglas no negociables

- **Gestión de estado e inyección: Riverpod** (requisito del usuario). NO `setState` para lógica, NI `provider`/`get_it`/GetX. Se usan `Provider`, `NotifierProvider`, `StateNotifierProvider`, `AsyncNotifierProvider`.
- **Views "delgadas"**: solo UI y delegación. Toda la lógica va en ViewModels / UseCases / Repositories.
- **Manejo de errores con patrón `Result`** (`core/utilities/result.dart`): sealed `Success`/`Failure`. Las capas devuelven `Result<T>`; el repositorio convierte excepciones a la jerarquía sellada `AppException` (`core/exceptions`). Evita `try/catch` dispersos.
- **Navegación: go_router** (`app/routes/app_router.dart`) con rutas centralizadas (`route_names.dart`) y guard de sesión que reacciona al `AuthController`. `publicPaths` lista las rutas accesibles sin sesión.
- **Tema Material 3** (`app/themes`): `ColorScheme.fromSeed(#7C3AED)` + colores de marca anclados; colores semánticos (success/warning/info) vía `ThemeExtension` `AppSemanticColors`. Acceso: `context.colors`, `context.semantic`, `context.textStyles`.

### Patrones del flujo de autenticación (referencia)

- **`AuthService`** (`features/authentication/data/services/auth_service.dart`) es la ÚNICA costura con el proveedor de identidad. Implementaciones: `FakeAuthService` (dev) y `FirebaseAuthService` (real). Se elige vía `authServiceProvider` (override en `bootstrap`).
- `AuthController` (`AsyncNotifier<User?>`) mantiene la sesión global; el router lo observa.
- Flujo de alta: Registro (paso 1, no autentica) → Verificar OTP (paso 2) → Éxito (paso 3, autentica) → Home. El usuario pendiente se pasa con `pendingRegistrationProvider`.
- Validación de contraseña centralizada en `core/utilities/password_strength.dart` (8+, mayúscula, número, especial); UI compartida en `widgets/password_requirements.dart`.
- Botón de regreso: SIEMPRE fijo arriba-izquierda con `Stack`+`Positioned` (no dentro del scroll).

## Skills de Flutter (LECTURA OBLIGATORIA)

El repo vendorizado `flutter-skills/skills/` contiene guías oficiales. **Antes de cualquier tarea Flutter, lee el `SKILL.md` correspondiente.** Las ya consultadas y que rigen este proyecto:

- `flutter-apply-architecture-best-practices` — capas UI/Domain/Data, MVVM, repository pattern.
- `flutter-setup-declarative-routing` — go_router, rutas anidadas, guards, deep linking.
- `flutter-setup-localization` — `.arb` + l10n.
- `flutter-build-responsive-layout` — `LayoutBuilder`/`MediaQuery.sizeOf`/`ConstrainedBox`; no bloquear orientación.
- `flutter-implement-json-serialization` — `fromJson`/`toJson` con casteo de tipos.

Divergencia deliberada: la skill de arquitectura sugiere `ChangeNotifier` + `provider`/`get_it`; este proyecto usa **Riverpod** por requisito del usuario — mantén Riverpod.

## Flujo de trabajo al hacer cambios

1. Edita código (respeta capas y Riverpod).
2. Si tocas strings: `flutter gen-l10n`.
3. `flutter analyze lib test` → debe quedar **No issues found!**
4. `dart fix --apply` para comas finales/lints automáticos (analysis_options es estricto).
5. `flutter test` → todo en verde (hay tests de usecases, viewmodels, repos, widgets).
6. Antes de empezar, relee las skills relevantes (ver sección "Skills de Flutter"). `flutter-skills/` está excluido del análisis.

## Calidad

`analysis_options.yaml` estricto (strict-casts/inference, require_trailing_commas, etc.). Aplica SOLID/DRY/KISS. Documenta en español con DartDoc.
