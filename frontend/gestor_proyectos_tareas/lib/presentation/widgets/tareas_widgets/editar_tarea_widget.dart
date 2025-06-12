import '../../../config/dependencias.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';

class EditarTareaWidget extends StatefulWidget {
  final Tarea tarea;
  final List<Usuario> usuarios;
  final List<Proyecto> proyectos;

  const EditarTareaWidget({
    super.key,
    required this.tarea,
    required this.usuarios,
    required this.proyectos,
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
  int? proyectoId;
  String? estado;
  int? prioridadSeleccionada;

  @override
  void initState() {
    super.initState();

    tituloController = TextEditingController(text: widget.tarea.titulo);
    descripcionController = TextEditingController(text: widget.tarea.descripcion);
    fechaInicio = widget.tarea.fechaInicio;
    fechaFin = widget.tarea.fechaFin;

    usuarioAsignado = widget.usuarios.any((u) => u.id == widget.tarea.asignadoA)
        ? widget.tarea.asignadoA
        : null;
    proyectoId = widget.proyectos.any((p) => p.id == widget.tarea.proyectoId)
        ? widget.tarea.proyectoId
        : null;

    estado = widget.tarea.estado;
    prioridadSeleccionada = (widget.tarea.prioridad >= 1 && widget.tarea.prioridad <= 5)
        ? widget.tarea.prioridad
        : null;
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Future<void> _selectDate({
    required DateTime? initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onDateSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<AuthProvider>(context, listen: false).usuario;
    final esAdmin = usuario?.rol == 1;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Editar Tarea'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (esAdmin) ...[
              TextField(
                controller: tituloController,
                decoration: _inputDecoration('Título'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descripcionController,
                maxLines: 2,
                decoration: _inputDecoration('Descripción'),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _selectDate(
                  initialDate: fechaInicio,
                  onDateSelected: (picked) => setState(() => fechaInicio = picked),
                ),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: _inputDecoration('Fecha de inicio'),
                    controller: TextEditingController(
                      text: fechaInicio != null
                          ? '${fechaInicio!.year}-${fechaInicio!.month.toString().padLeft(2, '0')}-${fechaInicio!.day.toString().padLeft(2, '0')}'
                          : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _selectDate(
                  initialDate: fechaFin ?? fechaInicio ?? DateTime.now(),
                  onDateSelected: (picked) => setState(() => fechaFin = picked),
                ),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: _inputDecoration('Fecha de fin (opcional)'),
                    controller: TextEditingController(
                      text: fechaFin != null
                          ? '${fechaFin!.year}-${fechaFin!.month.toString().padLeft(2, '0')}-${fechaFin!.day.toString().padLeft(2, '0')}'
                          : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: usuarioAsignado,
                decoration: _inputDecoration('Asignar a'),
                items: widget.usuarios.map((usuario) {
                  return DropdownMenuItem(
                    value: usuario.id,
                    child: Text(usuario.nombre),
                  );
                }).toList(),
                onChanged: (value) => setState(() => usuarioAsignado = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: proyectoId,
                decoration: _inputDecoration('Proyecto'),
                items: widget.proyectos.map((proyecto) {
                  return DropdownMenuItem(
                    value: proyecto.id,
                    child: Text(proyecto.titulo),
                  );
                }).toList(),
                onChanged: (value) => setState(() => proyectoId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: prioridadSeleccionada,
                decoration: _inputDecoration('Prioridad (1-5)'),
                items: List.generate(5, (i) {
                  final p = i + 1;
                  return DropdownMenuItem(value: p, child: Text('Prioridad $p'));
                }),
                onChanged: (value) => setState(() => prioridadSeleccionada = value),
              ),
            ],
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: estado,
              decoration: _inputDecoration('Estado'),
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
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      actions: [
        OutlinedButton(
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
              'proyectoId': proyectoId,
              'estado': estado,
              'prioridad': prioridadSeleccionada,
            });
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
