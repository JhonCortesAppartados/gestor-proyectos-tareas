import { UsuarioProyectoRepository } from '../../domain/repositories/usuario_proyecto.repository';
import { connection_db } from '../datasources/db/connection_db';

export class UsuarioProyectoRepositoryImpl implements UsuarioProyectoRepository{
    async asignar(usuario_id: number, proyecto_id: number): Promise<void> {
        await connection_db.query(
            'INSERT INTO usuarios_proyectos (usuario_id, proyecto_id) VALUES (?, ?)',
            [usuario_id, proyecto_id]
        );
    }
}