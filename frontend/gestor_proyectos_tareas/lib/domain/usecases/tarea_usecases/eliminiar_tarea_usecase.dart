import '../../repositories/tarea_repository.dart';

class EliminarTareaUseCase {
  final TareaRepository repository;
  EliminarTareaUseCase(this.repository);

  Future<void> call(int tareaId) {
    return repository.eliminarTarea(tareaId);
  }
}