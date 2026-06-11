import 'package:enterprise_flutter_template/features/authentication/domain/entities/user.dart';

/// DTO (Data Transfer Object) del usuario tal como lo devuelve la API.
///
/// Conoce el formato JSON y se encarga de mapear hacia la entidad de dominio
/// [User]. Separar DTO y entidad evita que cambios en el contrato del backend
/// se filtren al dominio.
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  /// Construye el DTO desde un mapa JSON.
  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'].toString(),
        name: json['name'] as String,
        email: json['email'] as String,
      );

  /// Serializa el DTO a JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

  /// Convierte el DTO en una entidad de dominio.
  User toEntity() => User(id: id, name: name, email: email);
}
