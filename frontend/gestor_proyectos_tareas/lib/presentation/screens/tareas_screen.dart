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
    Future.microtask(() {
      Provider.of<TareaProvider>(context, listen: false).cargarTareas();
    });
  }

  Color getPrioridadColor(int prioridad) {
    switch (prioridad) {
      case 5:
        return Colors.red.shade700;
      case 4:
        return Colors.red.shade300;
      case 3:
        return Colors.orangeAccent;
      case 2:
        return Colors.yellow.shade700;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tareaProvider = Provider.of<TareaProvider>(context);
    final usuario = Provider.of<AuthProvider>(context).usuario;
    final esAdmin = usuario?.rol == 1;
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);

    final tareas = esAdmin
        ? tareaProvider.tareas
        : tareaProvider.tareas.where((t) => t.asignadoA == usuario?.id).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Gestión de Tareas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: tareas.isEmpty
          ? const Center(
              child: Text(
                'No hay tareas registradas',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                final tarea = tareas[index];
                final esPropia = tarea.asignadoA == usuario?.id;
                final fechaInicio = DateFormat('dd/MM/yyyy').format(tarea.fechaInicio);
                final fechaFin = tarea.fechaFin != null
                    ? DateFormat('dd/MM/yyyy').format(tarea.fechaFin!)
                    : 'Sin definir';

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.task_alt, color: getPrioridadColor(tarea.prioridad)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tarea.titulo,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (esAdmin || esPropia)
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.indigo),
                                onPressed: () async {
                                  await usuarioProvider.cargarUsuarios();
                                  final proyectoProvider = Provider.of<ProyectoProvider>(context, listen: false);
                                  await proyectoProvider.cargarProyectos();
                                  final resultado = await showDialog(
                                    context: context,
                                    builder: (context) => EditarTareaWidget(
                                      tarea: tarea,
                                      usuarios: usuarioProvider.usuarios,
                                      proyectos: proyectoProvider.proyectos,
                                    ),
                                  );
                                  if (resultado != null) {
                                    final tareaEditada = tarea.copyWith(
                                      titulo: esAdmin ? resultado['titulo'] : tarea.titulo,
                                      descripcion: esAdmin ? resultado['descripcion'] : tarea.descripcion,
                                      fechaInicio: esAdmin ? resultado['fechaInicio'] : tarea.fechaInicio,
                                      fechaFin: esAdmin ? resultado['fechaFin'] : tarea.fechaFin,
                                      asignadoA: esAdmin ? resultado['asignadoA'] : tarea.asignadoA,
                                      proyectoId: esAdmin ? resultado['proyectoId'] : tarea.proyectoId,
                                      estado: resultado['estado'],
                                      prioridad: esAdmin ? resultado['prioridad'] : tarea.prioridad,
                                    );
                                    await tareaProvider.actualizarTarea(tareaEditada);
                                  }
                                },
                              ),
                            if (esAdmin)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () async {
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
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(tarea.descripcion),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Inicio: $fechaInicio'),
                            Text('Fin: $fechaFin'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Prioridad:'),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.flag,
                              size: 20,
                              color: getPrioridadColor(tarea.prioridad),
                            ),
                            const SizedBox(width: 4),
                            Text('${tarea.prioridad}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: esAdmin
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Nueva tarea'),
              backgroundColor: Colors.indigo,
              onPressed: () async {
                await usuarioProvider.cargarUsuarios();
                final proyectoProvider = Provider.of<ProyectoProvider>(context, listen: false);
                await proyectoProvider.cargarProyectos();
                final resultado = await showDialog(
                  context: context,
                  builder: (context) => CrearTareaWidget(
                    usuarios: usuarioProvider.usuarios,
                    proyectos: proyectoProvider.proyectos,
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
                    prioridad: resultado['prioridad'],
                    proyectoId: resultado['proyectoId'],
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
