import 'package:equatable/equatable.dart';

/// Entidad de dominio que representa a un usuario autenticado.
///
/// Es independiente de la capa de datos: no conoce JSON ni APIs. Las capas
/// externas (DTOs) se encargan de mapear hacia/desde esta entidad pura.
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}
