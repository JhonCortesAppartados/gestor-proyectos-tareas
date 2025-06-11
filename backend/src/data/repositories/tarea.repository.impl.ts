import { Tarea } from "../../domain/entities/tarea.entity";
import { TareaRepository } from "../../domain/repositories/tarea.repository";
import { connection_db } from "../datasources/db/connection_db";


export class TareaRepositoryImpl implements TareaRepository{
    async getAll(): Promise<Tarea[]>{
        const [rows] = await connection_db.query('SELECT * FROM tareas');
        return rows as Tarea[];
    }

    async create(data: Omit<Tarea, 'id'>): Promise<Tarea> {
        const { titulo, descripcion, fecha_inicio, fecha_fin, estado, prioridad, proyecto_id, asignado_a, creado_por } = data;
        const [result]: any = await connection_db.query(
            'INSERT INTO tareas (titulo, descripcion, fecha_inicio, fecha_fin, estado, prioridad, proyecto_id, asignado_a, creado_por) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [titulo, descripcion, fecha_inicio, fecha_fin, estado, prioridad, proyecto_id, asignado_a, creado_por]
        );
        // Si result es un array, toma el primer elemento
        const insertId = Array.isArray(result) ? result[0]?.insertId : result?.insertId;
        return { id: insertId, ...data };
    }

    async asignarUsuario(tarea_id: number, usuario_id: number): Promise<void> {
        await connection_db.query(
            'UPDATE tareas SET asignado_a = ? WHERE id = ?',
            [usuario_id, tarea_id]
        );
    }

    async update(id: number, data: Partial<Tarea>): Promise<void>{
        const campos = [];
        const valores = [];

        for (const key in data){
            campos.push(`${key} = ?`);
            valores.push((data as any)[key]);
        }
        valores.push(id);

        const sql = `UPDATE tareas SET ${campos.join(', ')} WHERE id = ?`;
        await connection_db.query(sql, valores);
    }

    async findById(id: number): Promise<Tarea | null> {
        const [rows]: any = await connection_db.query(
            'SELECT * FROM tareas WHERE id = ?',
            [id]
        );
        return rows.length > 0 ? (rows[0] as Tarea) : null;
    }

    async delete(id: number): Promise<void> {
        await connection_db.query(
            'DELETE FROM tareas WHERE id = ?',
            [id]
        );
    }
    
};
