class Tarea {
  final int id;
  final String titulo;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String estado;
  final int prioridad;
  final int proyectoId;
  final int? asignadoA;
  final int creadoPor;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaInicio,
    this.fechaFin,
    required this.estado,
    required this.prioridad,
    required this.proyectoId,
    this.asignadoA,
    required this.creadoPor,
  });

  Tarea copyWith({
    int? id,
    String? titulo,
    String? descripcion,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? estado,
    int? prioridad,
    int? proyectoId,
    int? asignadoA,
    int? creadoPor,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      estado: estado ?? this.estado,
      prioridad: prioridad ?? this.prioridad,
      proyectoId: proyectoId ?? this.proyectoId,
      asignadoA: asignadoA ?? this.asignadoA,
      creadoPor: creadoPor ?? this.creadoPor,
    );
  }
}
