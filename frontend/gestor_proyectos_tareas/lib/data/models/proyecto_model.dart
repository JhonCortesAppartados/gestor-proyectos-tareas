import '../../domain/entities/entities.dart';

class ProyectoModel extends Proyecto {
  ProyectoModel({
    required int id,
    required String titulo,
    required String descripcion,
    required DateTime fechaInicio,
    DateTime? fechaFin,
    required int creadoPor,
    List<int>? usuariosAsignados,
  }) : super(
         id: id,
         titulo: titulo,
         descripcion: descripcion,
         fechaInicio: fechaInicio,
         fechaFin: fechaFin,
         creadoPor: creadoPor,
         usuariosAsignados: usuariosAsignados,
       );

  factory ProyectoModel.fromJson(Map<String, dynamic> json) => ProyectoModel(
    id: json['id'],
    titulo: json['titulo'],
    descripcion: json['descripcion'] ?? '',
    fechaInicio: DateTime.parse(json['fecha_inicio']),
    fechaFin:
        json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin']) : null,
    creadoPor: json['creado_por'],
    usuariosAsignados:
        json['usuarios_asignados'] != null
            ? List<int>.from(json['usuarios_asignados'])
            : null,
  );

  Map<String, dynamic> toCreateJson() => {
    'titulo': titulo,
    'descripcion': descripcion,
    'fecha_inicio': fechaInicio.toIso8601String(),
    'fecha_fin': fechaFin?.toIso8601String(),
    'creado_por': creadoPor,
  };
}
