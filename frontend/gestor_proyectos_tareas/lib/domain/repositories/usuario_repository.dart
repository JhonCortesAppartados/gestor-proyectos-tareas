
import '../entities/entities.dart';
import '../usecases/usuario_usecases/login_result.dart';

abstract class UsuarioRepository {
  Future<List<Usuario>> getUsuarios();
  Future<Usuario?> getUsuarioPorId(int usuarioId);
  Future<Usuario> crearUsuario(Usuario usuario);
  Future<void> bloquearUsuario(int usuarioId, bool bloquear);
  Future<LoginResult?> login(String correo, String password);
}
