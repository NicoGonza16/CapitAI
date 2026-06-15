import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Límite de verificación de cuenta (código OTP por correo).
///
/// La verificación por código de 6 dígitos suele resolverse con tu propio
/// backend (o Firebase Phone/Email). Se aísla tras esta interfaz para que la
/// presentación no dependa de la implementación concreta.
abstract interface class VerificationService {
  /// Envía (o reenvía) el código de verificación al [email].
  Future<void> sendCode(String email);

  /// Verifica el [code] de 6 dígitos para el [email]. Devuelve `true` si es
  /// válido.
  Future<bool> verifyCode({required String email, required String code});
}

/// Implementación simulada: acepta cualquier código de 6 dígitos.
///
/// Reemplázala por la real (backend/Firebase) sobreescribiendo
/// [verificationServiceProvider].
class FakeVerificationService implements VerificationService {
  static const _latency = Duration(milliseconds: 700);

  @override
  Future<void> sendCode(String email) async =>
      Future<void>.delayed(_latency);

  @override
  Future<bool> verifyCode({
    required String email,
    required String code,
  }) async {
    await Future<void>.delayed(_latency);
    return code.length == 6 && int.tryParse(code) != null;
  }
}

/// Provider del servicio de verificación.
final verificationServiceProvider = Provider<VerificationService>(
  (ref) => FakeVerificationService(),
);
