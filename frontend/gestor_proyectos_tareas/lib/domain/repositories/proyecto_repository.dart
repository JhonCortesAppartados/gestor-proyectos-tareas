import '../entities/entities.dart';

abstract class ProyectoRepository {
  Future<List<Proyecto>> getProyectos();
  Future<List<Proyecto>> getProyectosPorUsuario(int usuarioId);
  Future<Proyecto> crearProyecto(Proyecto proyecto);
  Future<void> eliminarProyecto(int proyectoId);
  Future<Proyecto?> getProyectoPorId(int proyectoId);
}
