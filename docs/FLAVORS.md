# Flavors nativos (Android & iOS)

Esta guía configura **3 flavors** (`dev`, `qa`, `prod`) a nivel de plataforma para que cada uno tenga su propio `applicationId` / `bundleId`, nombre de app e icono, y puedan **coexistir instalados** en el mismo dispositivo.

El lado Dart ya está resuelto: cada flavor tiene su entrypoint (`lib/main_dev.dart`, `lib/main_qa.dart`, `lib/main_prod.dart`) que llama a `bootstrap(Flavor.x)` y carga el `.env` correspondiente.

> Aplica estos cambios **después** de ejecutar `flutter create .` (que genera `android/` e `ios/`).

---

## 1. Android

### `android/app/build.gradle.kts`

Dentro de `android { ... }` añade un `flavorDimension` y los `productFlavors`:

```kotlin
android {
    // ...
    flavorDimensions += "env"

    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "App Dev")
            versionNameSuffix = "-dev"
        }
        create("qa") {
            dimension = "env"
            applicationIdSuffix = ".qa"
            resValue("string", "app_name", "App QA")
            versionNameSuffix = "-qa"
        }
        create("prod") {
            dimension = "env"
            // sin sufijo: applicationId base
            resValue("string", "app_name", "Enterprise App")
        }
    }
}
```

### `android/app/src/main/AndroidManifest.xml`

Usa el recurso generado para el nombre de la app:

```xml
<application
    android:label="@string/app_name"
    ... >
```

### Iconos por flavor (opcional)

Coloca recursos específicos en carpetas por flavor; Gradle los fusiona con `src/main`:

```
android/app/src/dev/res/mipmap-*/ic_launcher.png
android/app/src/qa/res/mipmap-*/ic_launcher.png
```

---

## 2. iOS

iOS usa **Build Configurations + Schemes** (no "flavors" como Android). Pasos en Xcode (`open ios/Runner.xcworkspace`):

### a) Build Configurations

Duplica las configuraciones `Debug`/`Release`/`Profile` para cada flavor:
`Debug-dev`, `Release-dev`, `Profile-dev`, `Debug-qa`, ... `Release-prod`, etc.

### b) Xcconfig por flavor

Crea `ios/Flutter/Dev.xcconfig`, `Qa.xcconfig`, `Prod.xcconfig`:

```
// ios/Flutter/Dev.xcconfig
#include "Generated.xcconfig"
APP_DISPLAY_NAME = App Dev
PRODUCT_BUNDLE_IDENTIFIER = com.tuempresa.app.dev
```

```
// ios/Flutter/Prod.xcconfig
#include "Generated.xcconfig"
APP_DISPLAY_NAME = Enterprise App
PRODUCT_BUNDLE_IDENTIFIER = com.tuempresa.app
```

Asocia cada `.xcconfig` a su Build Configuration en el target *Runner*.

### c) Info.plist

```xml
<key>CFBundleDisplayName</key>
<string>$(APP_DISPLAY_NAME)</string>
```

### d) Schemes

Crea un Scheme por flavor (`dev`, `qa`, `prod`) y, en *Edit Scheme → Run/Archive*, selecciona la Build Configuration correspondiente. Marca **Shared** para versionarlos en `ios/Runner.xcodeproj/xcshareddata/xcschemes/`.

---

## 3. Ejecutar y compilar por flavor

```bash
# Desarrollo
flutter run   --flavor dev  -t lib/main_dev.dart

# QA
flutter run   --flavor qa   -t lib/main_qa.dart

# Producción (release)
flutter build apk       --flavor prod -t lib/main_prod.dart --release
flutter build appbundle --flavor prod -t lib/main_prod.dart --release
flutter build ipa       --flavor prod -t lib/main_prod.dart --release
```

> El `--flavor` selecciona la configuración **nativa**; el `-t` selecciona el **entrypoint Dart** que fija el `Flavor` y el `.env`. Ambos deben coincidir.

---

## 4. CI

Para construir un flavor concreto en GitHub Actions, ajusta el paso de build:

```yaml
- run: flutter build appbundle --flavor prod -t lib/main_prod.dart --release
```
