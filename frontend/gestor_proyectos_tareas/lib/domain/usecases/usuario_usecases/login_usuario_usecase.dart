import '../../repositories/usuario_repository.dart';
import 'login_result.dart';

class LoginUsuarioUseCase {
  final UsuarioRepository repository;
  LoginUsuarioUseCase(this.repository);

  Future<LoginResult?> call(String correo, String password) {
    return repository.login(correo, password);
  }
}
