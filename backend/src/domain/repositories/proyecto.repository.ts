import { Proyecto } from '../entities/proyecto.entity';

export interface ProyectoRepository {
    getAll(): Promise<Proyecto[]>;
    findById(id: number): Promise<Proyecto | null>;
    create(data: Omit<Proyecto, 'id'>): Promise<Proyecto>;
    delete(id: number): Promise<void>;
};