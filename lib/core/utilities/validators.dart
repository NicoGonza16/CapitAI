import 'package:enterprise_flutter_template/app/constants/app_constants.dart';

/// Validadores puros y reutilizables para formularios.
///
/// Al ser funciones puras (sin estado ni dependencias) son trivialmente
/// testeables y reutilizables entre ViewModels y widgets.
abstract final class Validators {
  static final _emailRegex = RegExp(r'^[\w.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');

  /// Devuelve `true` si [value] es un correo con formato válido.
  static bool isValidEmail(String value) => _emailRegex.hasMatch(value);

  /// Devuelve `true` si [value] cumple la longitud mínima de contraseña.
  static bool isValidPassword(String value) =>
      value.length >= AppConstants.minPasswordLength;
}
