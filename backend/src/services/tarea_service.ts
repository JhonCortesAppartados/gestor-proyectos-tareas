import { TareaRepository } from '../domain/repositories/tarea.repository';
import { Tarea } from '../domain/entities/tarea.entity';

export class TareaService {
  constructor(private tareaRepo: TareaRepository) { }

  async crearTarea(data: Omit<Tarea, 'id'>) {
    if (data.prioridad && (data.prioridad < 1 || data.prioridad > 5)) {
      throw new Error('La prioridad debe estar entre 1 y 5');
    }
    return this.tareaRepo.create(data);
  }

  async editarTarea(id: number, data: Partial<Tarea>) {
    const tarea = await this.tareaRepo.findById(id);
    if (!tarea) throw new Error('Tarea no encontrada');
    await this.tareaRepo.update(id, data);
    return { message: 'Tarea actualizada correctamente' };
  }

  async eliminarTarea(id: number) {
    const tarea = await this.tareaRepo.findById(id);
    if (!tarea) throw new Error('Tarea no encontrada');
    await this.tareaRepo.delete(id);
    return { message: 'Tarea eliminada correctamente' };
  }

  async getTareas() {
    return this.tareaRepo.getAll();
  }

  async findById(id: number) {
    return this.tareaRepo.findById(id);
  }

  async asignarUsuarioATarea(tarea_id: number, usuario_id: number) {
    await this.tareaRepo.asignarUsuario(tarea_id, usuario_id);
    return { message: 'Usuario asignado a la tarea correctamente' };
  }
}