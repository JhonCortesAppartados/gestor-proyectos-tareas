import '../../entities/entities.dart';
import '../../repositories/proyecto_repository.dart';

class CrearProyectoUseCase {
  final ProyectoRepository repository;
  CrearProyectoUseCase(this.repository);

  Future<Proyecto> call(Proyecto proyecto) {
    return repository.crearProyecto(proyecto);
  }
}
