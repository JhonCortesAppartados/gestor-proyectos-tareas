import '../../entities/entities.dart';
import '../../repositories/tarea_repository.dart';

class CrearTareaUseCase {
  final TareaRepository repository;
  CrearTareaUseCase(this.repository);

  Future<Tarea> call(Tarea tarea) {
    return repository.crearTarea(tarea);
  }
}
