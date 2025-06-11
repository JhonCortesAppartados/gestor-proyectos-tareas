import '../entities/entities.dart';

abstract class TareaRepository {
  Future<List<Tarea>> getTareas();
  Future<List<Tarea>> getTareasPorProyecto(int proyectoId);
  Future<Tarea> crearTarea(Tarea tarea);
  Future<Tarea> actualizarTarea(Tarea tarea);
  Future<void> eliminarTarea(int tareaId);
  Future<Tarea?> getTareaPorId(int tareaId);
}
