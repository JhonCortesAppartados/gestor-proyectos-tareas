import '../../domain/entities/entities.dart';

class UsuarioModel extends Usuario {
  UsuarioModel({
    required int id,
    required String nombre,
    required String correo,
    required bool estaBloqueado,
    required int rol,
    DateTime? creadoEn,
  }) : super(
         id: id,
         nombre: nombre,
         correo: correo,
         estaBloqueado: estaBloqueado,
         rol: rol,
         creadoEn: creadoEn,
       );

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
    id: json['id'],
    nombre: json['nombre'],
    correo: json['correo'],
    estaBloqueado: (json['esta_bloqueado'] ?? 0) == 1,
    rol: json['rol_id'],
    creadoEn: json['creado_en'] != null
        ? DateTime.tryParse(json['creado_en'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
    'esta_bloqueado': estaBloqueado,
    'rol_id': rol,
    if(creadoEn != null)
      'creado_en': creadoEn!.toIso8601String(),
  };
}
