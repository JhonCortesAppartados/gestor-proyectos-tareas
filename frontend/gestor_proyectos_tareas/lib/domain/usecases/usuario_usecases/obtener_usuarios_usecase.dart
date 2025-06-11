import '../../entities/entities.dart';
import '../../repositories/usuario_repository.dart';

class GetUsuariosUseCase {
  final UsuarioRepository repository;
  GetUsuariosUseCase(this.repository);

  Future<List<Usuario>> call() {
    return repository.getUsuarios();
  }
}
