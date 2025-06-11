import '../../entities/entities.dart';
import '../../repositories/tarea_repository.dart';

class GetTareasPorProyectoUseCase {
  final TareaRepository repository;
  GetTareasPorProyectoUseCase(this.repository);

  Future<List<Tarea>> call(int proyectoId) {
    return repository.getTareasPorProyecto(proyectoId);
  }
}