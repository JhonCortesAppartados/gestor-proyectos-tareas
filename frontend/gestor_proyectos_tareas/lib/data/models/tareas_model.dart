import '../../domain/entities/entities.dart';

class TareaModel extends Tarea {
  TareaModel({
    required int id,
    required String titulo,
    required String descripcion,
    required DateTime fechaInicio,
    DateTime? fechaFin,
    required String estado,
    required int prioridad,
    required int proyectoId,
    int? asignadoA,
    required int creadoPor,
  }) : super(
         id: id,
         titulo: titulo,
         descripcion: descripcion,
         fechaInicio: fechaInicio,
         fechaFin: fechaFin,
         estado: estado,
         prioridad: prioridad,
         proyectoId: proyectoId,
         asignadoA: asignadoA,
         creadoPor: creadoPor,
       );

  factory TareaModel.fromJson(Map<String, dynamic> json) => TareaModel(
    id: json['id'],
    titulo: json['titulo'],
    descripcion: json['descripcion'] ?? '',
    fechaInicio: DateTime.parse(json['fecha_inicio']),
    fechaFin:
        json['fecha_fin'] != null ? DateTime.parse(json['fecha_fin']) : null,
    estado: json['estado'],
    prioridad: json['prioridad'],
    proyectoId: json['proyecto_id'],
    asignadoA: json['asignado_a'],
    creadoPor: json['creado_por'],
  );

  factory TareaModel.fromEntity(Tarea tarea) => TareaModel(
    id: tarea.id,
    titulo: tarea.titulo,
    descripcion: tarea.descripcion,
    fechaInicio: tarea.fechaInicio,
    fechaFin: tarea.fechaFin,
    estado: tarea.estado,
    prioridad: tarea.prioridad,
    proyectoId: tarea.proyectoId,
    asignadoA: tarea.asignadoA,
    creadoPor: tarea.creadoPor,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'fecha_inicio': fechaInicio.toIso8601String(),
    'fecha_fin': fechaFin?.toIso8601String(),
    'estado': estado,
    'prioridad': prioridad,
    'proyecto_id': proyectoId,
    'asignado_a': asignadoA,
    'creado_por': creadoPor,
  };
}
