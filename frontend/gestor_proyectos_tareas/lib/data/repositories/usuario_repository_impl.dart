import 'dart:convert';
import 'package:gestor_proyectos_tareas/config/api_config.dart';
import 'package:gestor_proyectos_tareas/data/models/models.dart';
import 'package:gestor_proyectos_tareas/presentation/providers/auth_provider.dart';
import '../../config/dependencias.dart' as http;
import '../../domain/entities/entities.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../../domain/usecases/usuario_usecases/login_result.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {

  final String baseUrl = ApiConfig.baseUrl;
  AuthProvider? authProvider;

  UsuarioRepositoryImpl([this.authProvider]);


  @override
  Future<void> bloquearUsuario(int usuarioId, bool bloquear) async{
    final response = await http.patch(
      Uri.parse('$baseUrl/usuarios/$usuarioId/bloqueo'),
      headers: {
        'Content-Type': 'application/json',
        if(authProvider?.jwtToken != null) 'Authorization' : 'Bearer ${authProvider!.jwtToken}',
      },
      body: jsonEncode({'estado': bloquear}),
    );

    if(response.statusCode != 200) {
      throw Exception('Error al bloquear el usuario');
    }
  }

  @override
  Future<Usuario> crearUsuario(Usuario usuario) async{
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode((usuario as UsuarioModel).toJson()),
    );
    if(response.statusCode == 201){
      final data = jsonDecode(response.body);
      return UsuarioModel.fromJson(data['usuario']);
    }
    throw Exception('Error al crear el usuario');
  }

  @override
  Future<List<Usuario>> getUsuarios() async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios'),
      headers: {
        'Content-Type': 'application/json',
        if(authProvider?.jwtToken != null) 'Authorization' : 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if(response.statusCode == 200){
      final List data = jsonDecode(response.body);
      return data.map((e) => UsuarioModel.fromJson(e)).toList(); 
    }
    throw Exception('Error al obtener los usuarios');
  }

  @override
  Future<Usuario?> getUsuarioPorId(int usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$usuarioId'),
      headers: {
        'Content-Type': 'application/json',
        if(authProvider?.jwtToken != null) 'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if(response.statusCode == 200){
      return UsuarioModel.fromJson(jsonDecode(response.body));
    }
    if(response.statusCode == 404){
      return null; // Usuario no encontrado
    }
    throw Exception('Error al obtener el usuario');
  }

  @override
  Future<LoginResult?> login(String correo, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'password': password}),
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final usuario = UsuarioModel.fromJson(data['usuario']);
      final token = data['token'];
      return LoginResult(usuario: usuario, token: token);
    }
    if(response.statusCode == 404){
      throw Exception('Datos incorrectos');
    }
    throw Exception('Error al iniciar sesión');
  }
}
