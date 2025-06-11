import '../../entities/entities.dart';
import '../../repositories/tarea_repository.dart';

class GetTareaPorIdUseCase {
  final TareaRepository repository;
  GetTareaPorIdUseCase(this.repository);

  Future<Tarea?> call(int tareaId) {
    return repository.getTareaPorId(tareaId);
  }
}