import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../data/models/models.dart';
import '../providers/usuario_provider.dart';

class RegistrarScreen extends StatefulWidget {
  const RegistrarScreen({super.key});

  @override
  State<RegistrarScreen> createState() => _RegistrarScreenState();
}

class _RegistrarScreenState extends State<RegistrarScreen> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final passwordController = TextEditingController();
  int rolSeleccionado = 2; // 1 = Admin, 2 = Usuario
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Usuario')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: correoController,
              decoration: const InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: rolSeleccionado,
              decoration: const InputDecoration(labelText: 'Rol'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Administrador')),
                DropdownMenuItem(value: 2, child: Text('Usuario')),
              ],
              onChanged: (value) => setState(() => rolSeleccionado = value ?? 2),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);

                      final nombre = nombreController.text.trim();
                      final correo = correoController.text.trim();
                      final password = passwordController.text.trim();

                      if (nombre.isEmpty || correo.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Todos los campos son obligatorios'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        setState(() => _loading = false);
                        return;
                      }

                      try {
                        final nuevoUsuario = UsuarioModel(
                          id: 0,
                          nombre: nombre,
                          correo: correo,
                          password: password,
                          rol: rolSeleccionado,
                          estaBloqueado: false,
                        );

                        await usuarioProvider.registrarUsuario(nuevoUsuario);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario registrado exitosamente'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al registrar el usuario: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        if (mounted) setState(() => _loading = false);
                      }
                    },
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Registrar', style: TextStyle(color: AppColors.card)),
            ),
          ],
        ),
      ),
    );
  }
}
