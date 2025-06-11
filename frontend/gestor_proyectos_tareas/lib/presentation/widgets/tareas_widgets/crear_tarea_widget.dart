import 'package:flutter/material.dart';

class CrearTareaWidget extends StatefulWidget {
  final List<dynamic> usuarios; // Lista de usuarios para asignar

  const CrearTareaWidget({super.key, required this.usuarios});

  @override
  State<CrearTareaWidget> createState() => _CrearTareaWidgetState();
}

class _CrearTareaWidgetState extends State<CrearTareaWidget> {
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  DateTime? fechaInicio;
  DateTime? fechaFin;
  int? usuarioAsignado;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Tarea'),
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
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: usuarioAsignado,
              decoration: const InputDecoration(labelText: 'Asignar a'),
              items: widget.usuarios
                  .map((usuario) => DropdownMenuItem<int>(
                        value: usuario.id,
                        child: Text(usuario.nombre),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => usuarioAsignado = value),
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
              'asignadoA': usuarioAsignado,
            });
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }
}