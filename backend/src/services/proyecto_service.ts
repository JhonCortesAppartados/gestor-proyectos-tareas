import { ProyectoRepository } from '../domain/repositories/proyecto.repository';
import { Proyecto } from '../domain/entities/proyecto.entity';

export class ProyectoService {
  constructor(private proyectoRepo: ProyectoRepository) {}

  async crearProyecto(data: Omit<Proyecto, 'id'>) {
    if (data.fecha_fin && data.fecha_inicio > data.fecha_fin) {
      throw new Error('La fecha de inicio no puede ser mayor que la fecha de fin');
    }
    return this.proyectoRepo.create(data);
  }

  async eliminarProyecto(id: number) {
    const proyecto = await this.proyectoRepo.findById(id);
    if (!proyecto) throw new Error('Proyecto no encontrado');
    await this.proyectoRepo.delete(id);
    return { message: 'Proyecto eliminado correctamente' };
  }

  async getProyectos() {
    return this.proyectoRepo.getAll();
  }
}