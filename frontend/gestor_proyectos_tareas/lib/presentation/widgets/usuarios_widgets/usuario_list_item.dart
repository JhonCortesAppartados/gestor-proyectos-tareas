import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../domain/entities/entities.dart';

class UsuarioListItem extends StatelessWidget {
  final bool esAdmin;
  final Usuario usuario;
  final VoidCallback? onToggleBloqueo;

  const UsuarioListItem({
    super.key,
    required this.esAdmin,
    required this.usuario,
    this.onToggleBloqueo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: usuario.estaBloqueado
              ? AppColors.desabilitar
              : Theme.of(context).primaryColor,
          child: Text(
            usuario.nombre.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          usuario.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          usuario.correo,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: esAdmin
            ? TextButton.icon(
                onPressed: onToggleBloqueo,
                icon: Icon(
                  usuario.estaBloqueado ? Icons.lock_open : Icons.lock,
                  color: usuario.estaBloqueado
                      ? AppColors.habilitar
                      : AppColors.desabilitar,
                ),
                label: Text(
                  usuario.estaBloqueado ? 'Desbloquear' : 'Bloquear',
                  style: TextStyle(
                    color: usuario.estaBloqueado
                        ? AppColors.habilitar
                        : AppColors.desabilitar,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
