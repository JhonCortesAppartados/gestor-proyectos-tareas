import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class ProyectoProvider extends ChangeNotifier{
  final GetProyectoUseCase getProyectosUseCase;
  final GetProyectoPorUsuarioUseCase getProyectosPorUsuarioUseCase;
  final CrearProyectoUseCase crearProyectoUseCase;
  final EliminarProyectosUseCase eliminarProyectosUseCase;
  final GetProyectoPorIdUseCase getProyectoPorIdUseCase;

  List<Proyecto> proyectos = [];
  List<Proyecto> proyectosUsuario = [];
  Proyecto? proyectoSeleccionado;
  bool loading = false;
  String? error;

  ProyectoProvider({
    required this.getProyectosUseCase,
    required this.getProyectosPorUsuarioUseCase,
    required this.crearProyectoUseCase,
    required this.eliminarProyectosUseCase,
    required this.getProyectoPorIdUseCase,
  });

  Future<void> cargarProyectos() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      proyectos = await getProyectosUseCase();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> getProyectosPorUsuario([int? usuarioId]) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      if (usuarioId != null) {
        proyectosUsuario = await getProyectosPorUsuarioUseCase(usuarioId);
      } else {
        throw Exception('usuarioId no puede ser null');
      }
    } catch (e) {
      error = e.toString();
      proyectosUsuario = [];
    }
    loading = false;
    notifyListeners();
  }

  Future<void> crearProyecto(Proyecto proyecto) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await crearProyectoUseCase(proyecto);
      await cargarProyectos();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> eliminarProyecto(int proyectoId) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await eliminarProyectosUseCase(proyectoId);
      await cargarProyectos();
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> cargarProyectoPorId(int proyectoId) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      proyectoSeleccionado = await getProyectoPorIdUseCase(proyectoId);
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }
}