import 'config/dependencias.dart';
import 'data/repositories/proyecto_repository_impl.dart';
import 'data/repositories/tarea_repository_impl.dart';
import 'data/repositories/usuario_repository_impl.dart';
import 'domain/usecases/usecases.dart';
import 'presentation/providers/providers.dart';

Widget buildAppProviders(Widget child) {
  final usuarioRepository = UsuarioRepositoryImpl();
  final proyectoRepository = ProyectoRepositoryImpl();
  final tareaRepository = TareaRepositoryImpl();

  final loginUsuarioUseCase = LoginUsuarioUseCase(usuarioRepository);
  final getUsuariosUseCase = GetUsuariosUseCase(usuarioRepository);
  final registrarUsuarioUseCase = RegistrarUsuarioUseCase(usuarioRepository);
  final bloquearUsuarioUseCase = BloquearUsuarioUseCase(usuarioRepository);

  final getProyectosUseCase = GetProyectoUseCase(proyectoRepository);
  final getProyectosPorUsuarioUseCase = GetProyectoPorUsuarioUseCase(
    proyectoRepository,
  );
  final crearProyectoUseCase = CrearProyectoUseCase(proyectoRepository);
  final eliminarProyectosUseCase = EliminarProyectosUseCase(proyectoRepository);
  final getProyectoPorIdUseCase = GetProyectoPorIdUseCase(proyectoRepository);

  final getTareasUseCase = GetTareasUseCase(tareaRepository);
  final getTareasPorProyectoUseCase = GetTareasPorProyectoUseCase(
    tareaRepository,
  );
  final crearTareaUseCase = CrearTareaUseCase(tareaRepository);
  final actualizarTareaUseCase = ActualizarTareaUseCase(tareaRepository);
  final eliminarTareaUseCase = EliminarTareaUseCase(tareaRepository);
  final getTareaPorIdUseCase = GetTareaPorIdUseCase(tareaRepository);

  final authProvider = AuthProvider(loginUsuarioUseCase);

  usuarioRepository.authProvider = authProvider;
  proyectoRepository.authProvider = authProvider;
  tareaRepository.authProvider = authProvider;

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => authProvider),
      ChangeNotifierProvider(
        create:
            (_) => UsuarioProvider(
              getUsuariosUseCase: getUsuariosUseCase,
              registrarUsuarioUseCase: registrarUsuarioUseCase,
              bloquearUsuarioUseCase: bloquearUsuarioUseCase,
            ),
      ),
      ChangeNotifierProvider(
        create:
            (_) => ProyectoProvider(
              getProyectosUseCase: getProyectosUseCase,
              getProyectosPorUsuarioUseCase: getProyectosPorUsuarioUseCase,
              crearProyectoUseCase: crearProyectoUseCase,
              eliminarProyectosUseCase: eliminarProyectosUseCase,
              getProyectoPorIdUseCase: getProyectoPorIdUseCase,
            ),
      ),
      ChangeNotifierProvider(
        create:
            (_) => TareaProvider(
              getTareasUseCase: getTareasUseCase,
              getTareasPorProyectoUseCase: getTareasPorProyectoUseCase,
              crearTareaUseCase: crearTareaUseCase,
              actualizarTareaUseCase: actualizarTareaUseCase,
              eliminarTareaUseCase: eliminarTareaUseCase,
              getTareaPorIdUseCase: getTareaPorIdUseCase,
            ),
      ),
    ],
    child: child,
  );
}
