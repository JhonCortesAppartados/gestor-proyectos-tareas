import 'dart:convert';

import 'package:gestor_proyectos_tareas/config/api_config.dart';
import 'package:gestor_proyectos_tareas/presentation/providers/auth_provider.dart';

import '../../config/dependencias.dart' as http;
import '../../domain/entities/entities.dart';
import '../../domain/repositories/tarea_repository.dart';
import '../models/models.dart';

class TareaRepositoryImpl implements TareaRepository {
  final String baseUrl = ApiConfig.baseUrl;
  AuthProvider? authProvider;

  TareaRepositoryImpl([this.authProvider]);

  @override
  Future<Tarea> actualizarTarea(Tarea tarea) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tareas/${tarea.id}'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
      body: jsonEncode(TareaModel.fromEntity(tarea).toJson()),
    );

    if (response.statusCode == 200) {
      return TareaModel.fromJson(jsonDecode(response.body));
    }
throw Exception('Error al actualizar tarea');
  }

  @override
  Future<Tarea> crearTarea(Tarea tarea) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tareas'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
      body: jsonEncode(TareaModel.fromEntity(tarea).toJson()),
    );
    if (response.statusCode == 200) {
      return TareaModel.fromJson(jsonDecode(response.body));
    }
  throw Exception('Error al crear tarea');
  }

  @override
  Future<void> eliminarTarea(int tareaId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tareas/$tareaId'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar tarea');
    }
  }

  @override
  Future<Tarea?> getTareaPorId(int tareaId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tareas'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      try {
        return data
            .map((e) => TareaModel.fromJson(e))
            .firstWhere((tarea) => tarea.id == tareaId);
      } catch (_) {
        return null; // Si no se encuentra la tarea, retornamos null
      }
    }
    throw Exception('Error al obtener tarea');
  }

  @override
  Future<List<Tarea>> getTareasPorProyecto(int proyectoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tareas'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((e) => TareaModel.fromJson(e))
          .where((tarea) => tarea.proyectoId == proyectoId)
          .toList();
    }
    throw Exception('Error al obtener tareas por proyecto');
  }

  @override
  Future<List<Tarea>> getTareas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tareas'),
      headers: {
        'Content-Type': 'application/json',
        if (authProvider?.jwtToken != null)
          'Authorization': 'Bearer ${authProvider!.jwtToken}',
      },
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TareaModel.fromJson(e)).toList();
    }
    throw Exception('Error al obtener tareas');
  }
}
