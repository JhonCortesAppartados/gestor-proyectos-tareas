import 'dart:convert';

import 'package:gestor_proyectos_tareas/data/models/models.dart';

import '../../config/api_config.dart';
import '../../config/dependencias.dart' as http;
import '../../domain/entities/entities.dart';
import '../../domain/repositories/proyecto_repository.dart';
import '../../presentation/providers/auth_provider.dart';

class ProyectoRepositoryImpl implements ProyectoRepository {
  final String baseUrl = ApiConfig.baseUrl;
  AuthProvider? authProvider;

  ProyectoRepositoryImpl([this.authProvider]);

  @override
  Future<List<Proyecto>> getProyectos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/proyectos'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => ProyectoModel.fromJson(json)).toList();
    }
    throw Exception('Error al obtener los proyectos');
  }

  @override
  Future<Proyecto> crearProyecto(Proyecto proyecto) async {

    final proyectoModel = ProyectoModel(
    id: 0, // El backend lo asigna
    titulo: proyecto.titulo,
    descripcion: proyecto.descripcion,
    fechaInicio: proyecto.fechaInicio,
    fechaFin: proyecto.fechaFin,
    creadoPor: proyecto.creadoPor,
    usuariosAsignados: proyecto.usuariosAsignados,
  );

    final response = await http.post(
      Uri.parse('$baseUrl/proyectos'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
      body: jsonEncode(proyectoModel.toCreateJson()),
    );
    if (response.statusCode == 200) {
      return ProyectoModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Error al crear el proyecto');
  }

  @override
  Future<void> eliminarProyecto(int proyectoId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/proyectos/$proyectoId'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if(response.statusCode != 200) {
      throw Exception('Error al eliminar el proyecto');
    }
  }

  @override
  Future<Proyecto?> getProyectoPorId(int proyectoId) async {
    final response =  await http.get(
      Uri.parse('$baseUrl/proyectos'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)  
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if(response.statusCode == 200){
      final List data = jsonDecode(response.body);
      try {
        return data
            .map((e) => ProyectoModel.fromJson(e))
            .firstWhere((element) => element.id == proyectoId);
      } catch (_) {
        return null; // Si no se encuentra el proyecto, retornar null
      }
    }
    throw Exception('Error al obtener el proyecto');
  }

  @override
  Future<List<Proyecto>> getProyectosPorUsuario(int usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/proyectos'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if(response.statusCode == 200){
      final List data = jsonDecode(response.body);
      return data
          .map((json) => ProyectoModel.fromJson(json))
          .where((proyecto) => proyecto.creadoPor == usuarioId)
          .toList();
    }
    throw Exception('Error al obtener los proyectos del usuario');
  }
}
