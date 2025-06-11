import 'package:gestor_proyectos_tareas/presentation/widgets/proyecto_widgets/crear_proyecto_widget.dart';

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
      final usuarioId =
          Provider.of<AuthProvider>(context, listen: false).usuario?.id;
      if (usuarioId != null) {
        Provider.of<ProyectoProvider>(
          context,
          listen: false,
        ).getProyectosPorUsuario(usuarioId);
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
      body: Builder(
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
            return const Center(child: Text('No tienes proyectos asignados.'));
          }
          return ListView.separated(
            itemCount: proyectos.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final proyecto = proyectos[index];
              return ProyectoListItem(
                proyecto: proyecto,
                esAdmin: esAdmin,
                onDelete:
                    esAdmin
                        ? () async {
                          final usuarioId =
                              Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              ).usuario?.id;
                          final proyectoProvider =
                              Provider.of<ProyectoProvider>(
                                context,
                                listen: false,
                              );
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Confirmar'),
                                  content: const Text(
                                    '¿Deseas borrar este proyecto?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Borrar'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true && usuarioId != null) {
                            await proyectoProvider.eliminarProyecto(
                              proyecto.id,
                            );
                            await proyectoProvider.getProyectosPorUsuario(
                              usuarioId,
                            );
                          }
                        }
                        : null,
              );
            },
          );
        },
      ),
      floatingActionButton:
          esAdmin
              ? FloatingActionButton(
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add),
                onPressed: () async {

                  final resultado = await showDialog(
                    context: context,
                    builder:
                        (context) => CrearProyectoWidget(),
                  );

                  if (resultado != null) {
                    final usuario =
                        Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).usuario;
                    final nuevoProyecto = Proyecto(
                      id: 0,
                      titulo: resultado['titulo'],
                      descripcion: resultado['descripcion'],
                      fechaInicio: resultado['fechaIncio'] ?? DateTime.now(),
                      fechaFin: resultado['fechaFin'],
                      creadoPor: usuario?.id ?? 0,
                      usuariosAsignados: resultado['usuariosAsignados'],
                    );
                    await Provider.of<ProyectoProvider>(
                      context,
                      listen: false,
                    ).crearProyecto(nuevoProyecto);
                    // Recarga la lista
                    final usuarioId = usuario?.id;
                    if (usuarioId != null) {
                      await Provider.of<ProyectoProvider>(
                        context,
                        listen: false,
                      ).getProyectosPorUsuario(usuarioId);
                    }
                  }
                },
              )
              : null,
    );
  }
}
