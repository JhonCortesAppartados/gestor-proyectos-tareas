
import '../../config/dependencias.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {

  @override
  void initState() {
    super.initState();
    // Cargar tareas al entrar a la pantalla
    Future.microtask(() {
      Provider.of<TareaProvider>(context, listen: false).cargarTareas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);
    final usuario = Provider.of<AuthProvider>(context).usuario;
    final esAdmin = usuario?.rol == 1;

    final tareas = esAdmin
      ? tareaProvider.tareas
      : tareaProvider.tareas.where((t) => t.asignadoA == usuario?.id).toList();

    // Cargar usuarios para asignar tareas (solo si eres admin)
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Tareas')),
      body: tareas.isEmpty
          ? const Center(child: Text('No hay tareas'))
          : ListView.separated(
              itemCount: tareas.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final tarea = tareas[index];
                final esPropia = tarea.asignadoA == usuario?.id;
                return TareaListItem(
                  tarea: tarea,
                  esAdmin: esAdmin,
                  esPropia: esPropia,
                  onEdit: (esPropia || esAdmin)
                      ? () async {
                          await usuarioProvider.cargarUsuarios();
                          final resultado = await showDialog(
                            context: context,
                            builder: (context) => EditarTareaWidget(
                              tarea: tarea,
                              usuarios: usuarioProvider.usuarios,
                            ),
                          );
                          if (resultado != null) {
                            final tareaEditada = tarea.copyWith(
                              titulo: esAdmin ? resultado['titulo'] : tarea.titulo,
                              descripcion: esAdmin ? resultado['descripcion'] : tarea.descripcion,
                              fechaInicio: esAdmin ? resultado['fechaInicio'] : tarea.fechaInicio,
                              fechaFin: esAdmin ? resultado['fechaFin'] : tarea.fechaFin,
                              asignadoA: esAdmin ? resultado['asignadoA'] : tarea.asignadoA,
                              estado: resultado['estado'],
                            );
                            await tareaProvider.actualizarTarea(tareaEditada);
                          }
                        }
                      : null,
                  onDelete: esAdmin
                      ? () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar'),
                              content: const Text('¿Deseas borrar esta tarea?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Borrar'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await tareaProvider.eliminarTarea(tarea.id);
                          }
                        }
                      : null,
                );
              },
            ),
      floatingActionButton: esAdmin
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                await usuarioProvider.cargarUsuarios();
                final resultado = await showDialog(
                  context: context,
                  builder: (context) => CrearTareaWidget(
                    usuarios: usuarioProvider.usuarios,
                  ),
                );
                if (resultado != null) {
                  final usuario = Provider.of<AuthProvider>(context, listen: false).usuario;
                  final nuevaTarea = Tarea(
                    id: 0,
                    titulo: resultado['titulo'],
                    descripcion: resultado['descripcion'],
                    fechaInicio: resultado['fechaInicio'] ?? DateTime.now(),
                    fechaFin: resultado['fechaFin'],
                    estado: 'pendiente',
                    prioridad: 1,
                    proyectoId: 0, // Asigna el proyecto correspondiente
                    asignadoA: resultado['asignadoA'],
                    creadoPor: usuario?.id ?? 0,
                  );
                  await tareaProvider.crearTarea(nuevaTarea);
                }
              },
            )
          : null,
    );
  }
}