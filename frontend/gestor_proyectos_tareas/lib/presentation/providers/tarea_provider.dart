import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';


class TareaProvider extends ChangeNotifier {
  final GetTareasUseCase getTareasUseCase;
  final GetTareasPorProyectoUseCase getTareasPorProyectoUseCase;
  final CrearTareaUseCase crearTareaUseCase;
  final ActualizarTareaUseCase actualizarTareaUseCase;
  final EliminarTareaUseCase eliminarTareaUseCase;
  final GetTareaPorIdUseCase getTareaPorIdUseCase;

  List<Tarea> tareas = [];
  Tarea? tareaSeleccionada;

  TareaProvider({
    required this.getTareasUseCase,
    required this.getTareasPorProyectoUseCase,
    required this.crearTareaUseCase,
    required this.actualizarTareaUseCase,
    required this.eliminarTareaUseCase,
    required this.getTareaPorIdUseCase,
  });

  Future<void> cargarTareas() async {
    tareas = await getTareasUseCase();
    notifyListeners();
  }

  Future<void> cargarTareasPorProyecto(int proyectoId) async {
    tareas = await getTareasPorProyectoUseCase(proyectoId);
    notifyListeners();
  }

  Future<void> crearTarea(Tarea tarea) async {
    await crearTareaUseCase(tarea);
    await cargarTareas();
  }

  Future<void> actualizarTarea(Tarea tarea) async {
    await actualizarTareaUseCase(tarea);
    await cargarTareas();
  }

  Future<void> eliminarTarea(int tareaId) async {
    await eliminarTareaUseCase(tareaId);
    await cargarTareas();
  }

  Future<void> cargarTareaPorId(int tareaId) async {
    tareaSeleccionada = await getTareaPorIdUseCase(tareaId);
    notifyListeners();
  }
}