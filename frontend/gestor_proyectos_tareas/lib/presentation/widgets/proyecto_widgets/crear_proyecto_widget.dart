import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

class CrearProyectoWidget extends StatefulWidget {
  const CrearProyectoWidget({super.key});

  @override
  State<CrearProyectoWidget> createState() => _CrearProyectoWidgetState();
}

class _CrearProyectoWidgetState extends State<CrearProyectoWidget> {
  final _formKey = GlobalKey<FormState>();
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  DateTime? fechaInicio;
  DateTime? fechaFin;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear Nuevo Proyecto'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Título requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Descripción requerida' : null,
              ),
              const SizedBox(height: 16),
              _buildFechaSelector(
                label: 'Fecha de inicio',
                fecha: fechaInicio,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => fechaInicio = picked);
                },
              ),
              const SizedBox(height: 8),
              _buildFechaSelector(
                label: 'Fecha de fin (opcional)',
                fecha: fechaFin,
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: fechaInicio ?? DateTime.now(),
                    firstDate: fechaInicio ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => fechaFin = picked);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, {
                'titulo': tituloController.text,
                'descripcion': descripcionController.text,
                'fechaInicio': fechaInicio,
                'fechaFin': fechaFin,
              });
            }
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }

  Widget _buildFechaSelector({
    required String label,
    required DateTime? fecha,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              fecha != null
                  ? '${fecha.toLocal()}'.split(' ')[0]
                  : label,
              style: TextStyle(
                color: fecha != null ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
