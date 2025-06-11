import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class ProyectoListItem extends StatelessWidget {
  final dynamic proyecto;
  final bool esAdmin;
  final VoidCallback? onDelete;

  const ProyectoListItem({
    super.key,
    required this.proyecto,
    required this.esAdmin,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(proyecto.titulo),
      subtitle: Text(proyecto.descripcion),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.borrar),
              onPressed: onDelete,
              tooltip: 'Eliminar proyecto',
            ),
        ],
      ),
      onTap: () {
        // Aquí puedes navegar al detalle del proyecto si lo deseas
      },
    );
  }
}