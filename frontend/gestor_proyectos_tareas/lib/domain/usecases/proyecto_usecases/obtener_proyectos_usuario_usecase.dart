import '../../entities/entities.dart';
import '../../repositories/proyecto_repository.dart';

class GetProyectoPorUsuarioUseCase {
  final ProyectoRepository repository;
  GetProyectoPorUsuarioUseCase(this.repository);

  Future<List<Proyecto>> call(int usuarioId) {
    return repository.getProyectosPorUsuario(usuarioId);
  }
}
