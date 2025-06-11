import { UsuarioRepository } from '../domain/repositories/usuario.repository';
import { Usuario } from '../domain/entities/usuario.entity';

export class UsuarioService {
  constructor(private usuarioRepo: UsuarioRepository) {}

  async registrarUsuario(data: Omit<Usuario, 'id' | 'creado_en' | 'esta_bloqueado'>) {
    const existe = await this.usuarioRepo.findByCorreo(data.correo);
    if (existe) throw new Error('El correo ya está en uso');
    return this.usuarioRepo.create(data);
  }

  async bloquearUsuario(id: number, estado: boolean) {
    const usuario = await this.usuarioRepo.findById(id);
    if (!usuario) throw new Error('Usuario no encontrado');
    await this.usuarioRepo.setBloqueo(id, estado);
    return { message: `Usuario ${estado ? 'bloqueado' : 'desbloqueado'} exitosamente` };
  }

  async getUsuarios() {
    return this.usuarioRepo.getAll();
  }
}