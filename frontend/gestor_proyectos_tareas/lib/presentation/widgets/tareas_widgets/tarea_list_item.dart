import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class TareaListItem extends StatelessWidget {
  final dynamic tarea;
  final bool esAdmin;
  final bool esPropia;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TareaListItem({
    super.key,
    required this.tarea,
    required this.esAdmin,
    required this.esPropia,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(tarea.titulo),
      subtitle: Text(tarea.descripcion),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (esPropia || esAdmin)
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.edit),
              onPressed: onEdit,
              tooltip: 'Editar tarea',
            ),
          if (esAdmin)
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.borrar),
              onPressed: onDelete,
              tooltip: 'Eliminar tarea',
            ),
        ],
      ),
    );
  }
}