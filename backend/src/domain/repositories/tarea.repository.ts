import { Tarea } from '../entities/tarea.entity';

export interface TareaRepository {
    getAll(): Promise<Tarea[]>;
    findById(id: number): Promise<Tarea | null>;
    create(data: Omit<Tarea, 'id'>): Promise<Tarea>;
    update(id: number, data: Partial<Tarea>): Promise<void>;
    delete(id: number): Promise<void>;
    asignarUsuario(tarea_id: number, usuario_id: number): Promise<void>;
};