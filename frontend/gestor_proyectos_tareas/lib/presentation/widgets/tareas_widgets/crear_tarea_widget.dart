import '../../../config/app_colors.dart';
import '../../../config/dependencias.dart';

class CrearTareaWidget extends StatefulWidget {
  final List<dynamic> usuarios;
  final List<dynamic> proyectos;

  const CrearTareaWidget({
    super.key,
    required this.usuarios,
    required this.proyectos,
  });

  @override
  State<CrearTareaWidget> createState() => _CrearTareaWidgetState();
}

class _CrearTareaWidgetState extends State<CrearTareaWidget> {
  final tituloController = TextEditingController();
  final descripcionController = TextEditingController();
  DateTime? fechaInicio;
  DateTime? fechaFin;
  int? usuarioAsignado;
  int? proyectoID;
  int? prioridadSeleccionada = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Tarea', style: TextStyle(fontWeight: FontWeight.bold)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(tituloController, 'Título', Icons.title),
            const SizedBox(height: 12),
            _buildTextField(descripcionController, 'Descripción', Icons.description, maxLines: 3),
            const SizedBox(height: 16),
            _buildDatePicker(
              label: 'Seleccionar fecha de inicio',
              date: fechaInicio,
              icon: Icons.calendar_today,
              onPicked: (picked) => setState(() => fechaInicio = picked),
            ),
            const SizedBox(height: 12),
            _buildDatePicker(
              label: 'Seleccionar fecha de fin (opcional)',
              date: fechaFin,
              icon: Icons.event,
              onPicked: (picked) => setState(() => fechaFin = picked),
              firstDate: fechaInicio ?? DateTime.now(),
            ),
            const SizedBox(height: 16),
            _buildDropdown<int>(
              value: usuarioAsignado,
              label: 'Asignar a',
              items: widget.usuarios
                  .map((u) => DropdownMenuItem<int>(
                        value: u.id,
                        child: Text(u.nombre),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => usuarioAsignado = val),
            ),
            const SizedBox(height: 12),
            _buildDropdown<int>(
              value: proyectoID,
              label: 'Proyecto',
              items: widget.proyectos
                  .map((p) => DropdownMenuItem<int>(
                        value: p.id,
                        child: Text(p.titulo),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => proyectoID = val),
            ),
            const SizedBox(height: 12),
            _buildDropdown<int>(
              value: prioridadSeleccionada,
              label: 'Prioridad (1-5)',
              items: List.generate(
                5,
                (index) => DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('Prioridad ${index + 1}'),
                ),
              ),
              onChanged: (val) => setState(() => prioridadSeleccionada = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.pop(context, {
              'titulo': tituloController.text,
              'descripcion': descripcionController.text,
              'fechaInicio': fechaInicio,
              'fechaFin': fechaFin,
              'asignadoA': usuarioAsignado,
              'proyectoId': proyectoID,
              'prioridad': prioridadSeleccionada,
            });
          },
          icon: const Icon(Icons.check, color: AppColors.background),
          label: const Text('Crear', style: TextStyle(color: AppColors.background),),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required IconData icon,
    required void Function(DateTime picked) onPicked,
    DateTime? firstDate,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        date == null ? label : '${label.split(' ')[0]}: ${date.toLocal().toString().split(' ')[0]}',
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) onPicked(picked);
      },
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String label,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
