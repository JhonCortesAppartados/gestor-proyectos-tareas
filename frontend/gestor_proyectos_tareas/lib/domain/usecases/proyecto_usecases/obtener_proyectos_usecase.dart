import '../../entities/entities.dart';
import '../../repositories/proyecto_repository.dart';

class GetProyectoUseCase {
  final ProyectoRepository repository;
  GetProyectoUseCase(this.repository);

  Future<List<Proyecto>> call() {
    return repository.getProyectos();
  }
}
