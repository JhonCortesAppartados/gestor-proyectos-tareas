export interface UsuarioProyectoRepository {
    asignar(usuario_id: number, proyecto_id: number): Promise<void>;
};