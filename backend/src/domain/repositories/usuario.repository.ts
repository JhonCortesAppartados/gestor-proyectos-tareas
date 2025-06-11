import { Usuario } from '../entities/usuario.entity';

export interface UsuarioRepository {
    getAll(): Promise<Usuario[]>;
    findById(id: number): Promise<Usuario | null>;
    findByCorreo(correo: string): Promise<Usuario | null>;
    create(data: Omit<Usuario, 'id' | 'creado_en' | 'esta_bloqueado'>): Promise<Usuario>;
    setBloqueo(id: number, estado: boolean): Promise<void>;
};