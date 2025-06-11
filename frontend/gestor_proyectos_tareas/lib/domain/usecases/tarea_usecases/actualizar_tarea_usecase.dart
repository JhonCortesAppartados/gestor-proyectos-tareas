import '../../entities/entities.dart';
import '../../repositories/tarea_repository.dart';

class ActualizarTareaUseCase {
  final TareaRepository repository;
  ActualizarTareaUseCase(this.repository);

  Future<Tarea> call(Tarea tarea) {
    return repository.actualizarTarea(tarea);
  }
}