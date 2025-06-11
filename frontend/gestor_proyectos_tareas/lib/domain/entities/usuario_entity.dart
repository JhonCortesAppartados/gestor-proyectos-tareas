class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final bool estaBloqueado;
  final int rol;
  final DateTime? creadoEn;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.estaBloqueado,
    required this.rol,
    this.creadoEn,
  });
}
