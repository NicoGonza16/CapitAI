import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Usuario recién registrado pendiente de verificar.
///
/// Lo establece el registro (paso 1) y lo consumen las pantallas de verificación
/// (paso 2) y de éxito (paso 3). Evita pasar argumentos por las rutas y mantiene
/// el estado del flujo en un único lugar.
final pendingRegistrationProvider = StateProvider<User?>((ref) => null);
