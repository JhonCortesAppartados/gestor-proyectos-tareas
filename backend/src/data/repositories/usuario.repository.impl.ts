import { connection_db } from '../datasources/db/connection_db';
import { Usuario } from '../../domain/entities/usuario.entity';
import { UsuarioRepository } from '../../domain/repositories/usuario.repository';
import { hash } from '../../shared/libs/bcrypt';

export class UsuarioRepositoryImpl implements UsuarioRepository {

  async getAll(): Promise<Usuario[]> {
    const [rows] = await connection_db.query('SELECT * FROM usuarios');
    return rows as Usuario[];
  }

  async findById(id: number): Promise<Usuario | null> {
    const [rows]: any = await connection_db.query(
      'SELECT * FROM usuarios WHERE id = ?',
      [id]
    );
    return rows.length > 0 ? (rows[0] as Usuario) : null;
  }

  async findByCorreo(correo: string): Promise<Usuario | null> {
    const [rows]: any = await connection_db.query(
      'SELECT * FROM usuarios WHERE correo = ?',
      [correo]
    );
    return rows.length > 0 ? (rows[0] as Usuario) : null;
  }

  async create(data: Omit<Usuario, 'id' | 'creado_en' | 'esta_bloqueado'>): Promise<Usuario> {
    const { nombre, correo, password, rol_id } = data;
    const hashedPassword = await hash(password, 10);
    const [result]: any = await connection_db.query(
      'INSERT INTO usuarios (nombre, correo, password, rol_id) VALUES (?, ?, ?, ?)',
      [nombre, correo, hashedPassword, rol_id]
    );
    return {
      id: result.insertId,
      nombre,
      correo,
      password: hashedPassword,
      rol_id,
      creado_en: new Date(),
      esta_bloqueado: false
    }
  }

  async setBloqueo(id: number, estado: boolean): Promise<void> {
    await connection_db.query(
      'UPDATE usuarios SET esta_bloqueado = ? WHERE id = ?',
      [estado, id]
    );
  }

};

