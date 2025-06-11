import '../../repositories/proyecto_repository.dart';

class EliminarProyectosUseCase {
  final ProyectoRepository repository;
  EliminarProyectosUseCase(this.repository);

  Future<void> call(int proyectoId) {
    return repository.eliminarProyecto(proyectoId);
  }
}