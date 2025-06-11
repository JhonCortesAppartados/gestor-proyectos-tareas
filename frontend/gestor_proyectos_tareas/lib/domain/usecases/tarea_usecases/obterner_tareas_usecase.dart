import '../../entities/entities.dart';
import '../../repositories/tarea_repository.dart';

class GetTareasUseCase {
  final TareaRepository repository;
  GetTareasUseCase(this.repository);

  Future<List<Tarea>> call() {
    return repository.getTareas();
  }
}
