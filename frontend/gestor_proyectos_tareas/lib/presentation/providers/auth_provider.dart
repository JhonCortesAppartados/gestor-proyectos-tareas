import 'package:gestor_proyectos_tareas/config/dependencias.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usuario_usecases/login_usuario_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUsuarioUseCase loginUsuarioUseCase;
  Usuario? usuario;
  String? _jwtToken;

  AuthProvider(this.loginUsuarioUseCase);

  String? get jwtToken => _jwtToken;

  Future<bool> login(String correo, String password) async {
    final result = await loginUsuarioUseCase(correo, password);
    if(result != null){
      usuario = result.usuario;
      setJwtToken(result.token);
      notifyListeners();
      return true;
    } 
    return false;
  }

  void setJwtToken(String? token) {
    _jwtToken = token;
    notifyListeners();
  }

  void clearJwtToken() {
    _jwtToken = null;
    usuario = null;
    notifyListeners();
  }
}
