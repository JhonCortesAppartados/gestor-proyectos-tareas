import '../../domain/entities/entities.dart';


class RolModel extends Rol {
  RolModel({
    required int id,
    required String nombre,
  }) : super(id: id, nombre: nombre);

  factory RolModel.fromJson(Map<String, dynamic> json) => RolModel(
        id: json['id'],
        nombre: json['nombre'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
      };
}