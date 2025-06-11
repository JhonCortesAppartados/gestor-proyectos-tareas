import '../../entities/entities.dart';

class LoginResult {
  final Usuario usuario;
  final String? token;

  LoginResult({required this.usuario, required this.token});
}