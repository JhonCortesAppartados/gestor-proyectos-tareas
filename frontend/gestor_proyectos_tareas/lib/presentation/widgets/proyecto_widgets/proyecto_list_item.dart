import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../config/app_colors.dart';
import '../../../domain/entities/entities.dart';

class ProyectoListItem extends StatelessWidget {
  final Proyecto proyecto;
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

    final dateFormat = DateFormat('dd/MM/yyyy');

    String? fechaInicio = proyecto.fechaInicio == (null)
        ? 'Inicio: ${dateFormat.format(proyecto.fechaInicio)}'
        : null;
    String? fechaFin = proyecto.fechaFin != null
        ? 'Fin: ${dateFormat.format(proyecto.fechaFin!)}' 
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              proyecto.titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 6),

            // Descripción
            Text(
              proyecto.descripcion,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),

            // Fechas
            if (fechaInicio != null || fechaFin != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    if (fechaInicio != null)
                      Text(
                        fechaInicio,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    if (fechaInicio != null && fechaFin != null)
                      const SizedBox(width: 16),
                    if (fechaFin != null)
                      Text(
                        fechaFin,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                  ],
                ),
              ),

            // Botón de eliminar (si es admin)
            if (esAdmin)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.borrar),
                  onPressed: onDelete,
                  tooltip: 'Eliminar proyecto',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
