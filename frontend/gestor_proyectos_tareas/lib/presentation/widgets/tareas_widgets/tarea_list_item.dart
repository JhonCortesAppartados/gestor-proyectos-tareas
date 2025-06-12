import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Color getPrioridadColor(int prioridad) {
    switch (prioridad) {
      case 5:
      case 4:
        return Colors.redAccent;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaInicio = DateFormat('dd/MM/yyyy').format(tarea.fechaInicio);
    final fechaFin = tarea.fechaFin != null
        ? DateFormat('dd/MM/yyyy').format(tarea.fechaFin)
        : 'Sin definir';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Título + prioridad
            Row(
              children: [
                Icon(Icons.flag, size: 20, color: getPrioridadColor(tarea.prioridad)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tarea.titulo,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
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
              ],
            ),

            const SizedBox(height: 4),
            Text(
              tarea.descripcion,
              style: const TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Inicio: $fechaInicio', style: const TextStyle(fontSize: 13)),
                Text('Fin: $fechaFin', style: const TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
