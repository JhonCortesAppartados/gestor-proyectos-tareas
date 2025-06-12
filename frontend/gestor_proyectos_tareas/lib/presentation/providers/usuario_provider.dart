import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';


class UsuarioProvider extends ChangeNotifier{

  final GetUsuariosUseCase getUsuariosUseCase;
  final RegistrarUsuarioUseCase registrarUsuarioUseCase;
  final BloquearUsuarioUseCase bloquearUsuarioUseCase;

  List<Usuario> usuarios = [];

  UsuarioProvider({
    required this.getUsuariosUseCase,
    required this.registrarUsuarioUseCase,
    required this.bloquearUsuarioUseCase,
  });

  Future<void> cargarUsuarios() async {
    usuarios = await getUsuariosUseCase();
    notifyListeners();
  }

  Future<void> registrarUsuario(Usuario usuario) async {
    await registrarUsuarioUseCase(usuario);
    try {
      await cargarUsuarios();
    } catch (e) {
      debugPrint('Error al recargar usuarios después del registro: $e');
      // Se omite el throw para evitar romper la pantalla si falla la recarga
    }
  }

  Future<void> bloquearUsuario(int usuarioId, bool bloquear) async {
    await bloquearUsuarioUseCase(usuarioId, bloquear);
    await cargarUsuarios();
  }

}