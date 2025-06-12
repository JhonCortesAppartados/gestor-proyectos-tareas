import '../../config/dependencias.dart';
import '../providers/providers.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UsuarioProvider>(context, listen: false).cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<AuthProvider>(context).usuario;
    final esAdmin = usuario?.rol == 1;

    if (!esAdmin) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No tienes permisos para ver esta sección',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final usuarios = usuarioProvider.usuarios;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        centerTitle: true,
        elevation: 4,
      ),
      body: usuarios.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => await usuarioProvider.cargarUsuarios(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final u = usuarios[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: u.estaBloqueado
                              ? Colors.redAccent
                              : Theme.of(context).colorScheme.primary,
                          child: Text(
                            u.nombre.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          u.nombre,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          u.correo,
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: TextButton.icon(
                          onPressed: () async {
                            final bloquear = !u.estaBloqueado;
                            try {
                              await usuarioProvider.bloquearUsuario(u.id, bloquear);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al ${bloquear ? 'bloquear' : 'desbloquear'} el usuario'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            u.estaBloqueado ? Icons.lock_open : Icons.lock,
                            color: u.estaBloqueado ? Colors.green : Colors.redAccent,
                          ),
                          label: Text(
                            u.estaBloqueado ? 'Desbloquear' : 'Bloquear',
                            style: TextStyle(
                              color: u.estaBloqueado ? Colors.green : Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
