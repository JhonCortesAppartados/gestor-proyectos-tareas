class Proyecto {
  final int id;
  final String titulo;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final int creadoPor;
  final List<int>? usuariosAsignados;

  Proyecto({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaInicio,
    this.fechaFin,
    required this.creadoPor,
    this.usuariosAsignados,
  });


}