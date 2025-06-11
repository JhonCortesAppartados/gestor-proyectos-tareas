import '../../repositories/usuario_repository.dart';

class BloquearUsuarioUseCase {
  final UsuarioRepository repository;
  BloquearUsuarioUseCase(this.repository);

  Future<void> call(int usuarioId) {
    return repository.bloquearUsuario(usuarioId);
  }
}
