import '../../../config/dependencias.dart';
import '../../providers/providers.dart';

class EditarTareaWidget extends StatefulWidget {
  final dynamic tarea;
  final List<dynamic> usuarios; // Para admin: reasignar usuario

  const EditarTareaWidget({
    super.key,
    required this.tarea,
    required this.usuarios,
  });

  @override
  State<EditarTareaWidget> createState() => _EditarTareaWidgetState();
}

class _EditarTareaWidgetState extends State<EditarTareaWidget> {
  late TextEditingController tituloController;
  late TextEditingController descripcionController;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  int? usuarioAsignado;
  String? estado;

  @override
  void initState() {
    super.initState();
    tituloController = TextEditingController(text: widget.tarea.titulo);
    descripcionController = TextEditingController(text: widget.tarea.descripcion);
    fechaInicio = widget.tarea.fechaInicio;
    fechaFin = widget.tarea.fechaFin;
    usuarioAsignado = widget.tarea.asignadoA;
    estado = widget.tarea.estado;
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<AuthProvider>(context, listen: false).usuario;
    final esAdmin = usuario?.rol == 1;

    return AlertDialog(
      title: const Text('Editar Tarea'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (esAdmin) ...[
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
                    initialDate: fechaInicio ?? DateTime.now(),
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
                    initialDate: fechaFin ?? fechaInicio ?? DateTime.now(),
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
            // Estado editable por todos
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: estado,
              decoration: const InputDecoration(labelText: 'Estado'),
              items: const [
                DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                DropdownMenuItem(value: 'en_progreso', child: Text('En progreso')),
                DropdownMenuItem(value: 'completada', child: Text('Completada')),
              ],
              onChanged: (value) => setState(() => estado = value),
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
              'estado': estado,
            });
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}