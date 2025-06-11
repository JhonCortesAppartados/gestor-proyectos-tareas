import '../../entities/entities.dart';
import '../../repositories/usuario_repository.dart';

class RegistrarUsuarioUseCase {
  final UsuarioRepository repository;
  RegistrarUsuarioUseCase(this.repository);

  Future<Usuario> call(Usuario usuario) {
    return repository.crearUsuario(usuario);
  }
}
