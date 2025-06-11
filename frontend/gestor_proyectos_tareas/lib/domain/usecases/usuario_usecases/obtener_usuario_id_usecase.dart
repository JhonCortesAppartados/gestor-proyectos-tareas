import '../../entities/entities.dart';
import '../../repositories/usuario_repository.dart';

class GetUsuarioPorIdUseCase {
  final UsuarioRepository repository;
  GetUsuarioPorIdUseCase(this.repository);

  Future<Usuario?> call(int usuarioId) {
    return repository.getUsuarioPorId(usuarioId);
  }
}
