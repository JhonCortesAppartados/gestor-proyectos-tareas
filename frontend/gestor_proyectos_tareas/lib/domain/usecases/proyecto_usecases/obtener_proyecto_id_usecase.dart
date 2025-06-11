import '../../entities/entities.dart';
import '../../repositories/proyecto_repository.dart';

class GetProyectoPorIdUseCase {
  final ProyectoRepository repository;
  GetProyectoPorIdUseCase(this.repository);

  Future<Proyecto?> call(int proyectoId) {
    return repository.getProyectoPorId(proyectoId);
  }
}
