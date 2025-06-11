import { Proyecto } from "../../domain/entities/proyecto.entity";
import { ProyectoRepository } from "../../domain/repositories/proyecto.repository";
import { connection_db } from "../datasources/db/connection_db";



export class ProyectoRepositoryImpl implements ProyectoRepository{

    async getAll(): Promise<Proyecto[]> {
        const [rows] = await connection_db.query('SELECT * FROM proyectos');
        return rows as Proyecto[];
    }

    async create(data: Omit<Proyecto, 'id'>): Promise<Proyecto> {
        const { titulo, descripcion, fecha_inicio, fecha_fin, creado_por } = data;
        const [result]: any = await connection_db.query(
            'INSERT INTO proyectos (titulo, descripcion, fecha_inicio, fecha_fin, creado_por) VALUES (?, ?, ?, ?, ?)',
            [titulo, descripcion, fecha_inicio, fecha_fin, creado_por]
        );
        // Si result es un array, toma el primer elemento
        const insertId = Array.isArray(result) ? result[0]?.insertId : result?.insertId;
        return { id: insertId, ...data };
    }

    async findById(id: number): Promise<Proyecto | null> {
        const [rows]: any = await connection_db.query(
            'SELECT * FROM proyectos WHERE id = ?',
            [id]
        );
        return rows.length > 0 ? (rows[0] as Proyecto) : null;
    }

    async delete(id: number): Promise<void> {
        await connection_db.query(
            'DELETE FROM proyectos WHERE id = ?',
            [id]
        );
    }
}