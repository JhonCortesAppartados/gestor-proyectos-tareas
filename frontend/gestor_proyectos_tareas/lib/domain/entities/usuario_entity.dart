class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final String? password;
  final bool estaBloqueado;
  final int rol;
  final DateTime? creadoEn;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    this.password,
    required this.estaBloqueado,
    required this.rol,
    this.creadoEn,
  });
}
