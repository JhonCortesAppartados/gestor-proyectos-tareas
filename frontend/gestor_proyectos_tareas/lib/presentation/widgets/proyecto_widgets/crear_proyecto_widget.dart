import 'package:flutter/material.dart';

class CrearProyectoWidget extends StatefulWidget {
  const CrearProyectoWidget({super.key});

  @override
  State<CrearProyectoWidget> createState() => _CrearProyectoWidgetState();
}

class _CrearProyectoWidgetState extends State<CrearProyectoWidget> {
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  DateTime? fechaInicio;
  DateTime? fechaFin;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Proyecto'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: Text(fechaInicio == null
                  ? 'Seleccionar fecha de inicio'
                  : 'Inicio: ${fechaInicio!.toLocal().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
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
            ListTile(
              title: Text(fechaFin == null
                  ? 'Seleccionar fecha de fin (opcional)'
                  : 'Fin: ${fechaFin!.toLocal().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'titulo': tituloController.text,
              'descripcion': descripcionController.text,
              'fechaInicio': fechaInicio,
              'fechaFin': fechaFin,
            });
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }
}