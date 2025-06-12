import '../../config/dependencias.dart';
import '../../domain/entities/entities.dart';
import '../providers/providers.dart';
import '../../config/app_colors.dart';
import '../widgets/widgets.dart';

class ProyectosScreen extends StatefulWidget {
  const ProyectosScreen({super.key});

  @override
  State<ProyectosScreen> createState() => _ProyectosScreenState();
}

class _ProyectosScreenState extends State<ProyectosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final usuarioId = Provider.of<AuthProvider>(context, listen: false).usuario?.id;
      if (usuarioId != null) {
        Provider.of<ProyectoProvider>(context, listen: false).getProyectosPorUsuario(usuarioId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final proyectoProvider = Provider.of<ProyectoProvider>(context);
    final usuario = Provider.of<AuthProvider>(context).usuario;
    final esAdmin = usuario?.rol == 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Proyectos'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (context) {
            if (proyectoProvider.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (proyectoProvider.error != null) {
              return Center(
                child: Text(
                  'Error: ${proyectoProvider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final proyectos = proyectoProvider.proyectosUsuario;
            if (proyectos.isEmpty) {
              return const Center(
                child: Text(
                  'No tienes proyectos asignados.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.separated(
              itemCount: proyectos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final proyecto = proyectos[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.folder, color: AppColors.primary, size: 32),
                    title: Text(
                      proyecto.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proyecto.descripcion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              'Inicio: ${DateFormat('dd/MM/yyyy').format(proyecto.fechaInicio)}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                              const SizedBox(width: 12),
                            if (proyecto.fechaFin != null)
                              Text(
                                'Fin: ${DateFormat('dd/MM/yyyy').format(proyecto.fechaFin!)}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                          ],
                        )
                      ],
                    ),
                    trailing: esAdmin
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Eliminar proyecto',
                            onPressed: () => _confirmarEliminacion(context, proyecto),
                          )
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: esAdmin
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add),
              label: const Text("Nuevo Proyecto"),
              onPressed: () => _crearNuevoProyecto(context),
            )
          : null,
    );
  }

  Future<void> _crearNuevoProyecto(BuildContext context) async {
    final resultado = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const CrearProyectoWidget(),
    );

    if (resultado != null) {
      final usuario = Provider.of<AuthProvider>(context, listen: false).usuario;
      final nuevoProyecto = Proyecto(
        id: 0,
        titulo: resultado['titulo'],
        descripcion: resultado['descripcion'],
        fechaInicio: resultado['fechaInicio'] ?? DateTime.now(),
        fechaFin: resultado['fechaFin'],
        creadoPor: usuario?.id ?? 0,
      );

      final proyectoProvider = Provider.of<ProyectoProvider>(context, listen: false);
      await proyectoProvider.crearProyecto(nuevoProyecto);

      final usuarioId = usuario?.id;
      if (usuarioId != null) {
        await proyectoProvider.getProyectosPorUsuario(usuarioId);
      }
    }
  }

  Future<void> _confirmarEliminacion(BuildContext context, Proyecto proyecto) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Deseas eliminar el proyecto "${proyecto.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final usuarioId = Provider.of<AuthProvider>(context, listen: false).usuario?.id;
      final proyectoProvider = Provider.of<ProyectoProvider>(context, listen: false);
      await proyectoProvider.eliminarProyecto(proyecto.id);

      if (usuarioId != null) {
        await proyectoProvider.getProyectosPorUsuario(usuarioId);
      }
    }
  }
}
