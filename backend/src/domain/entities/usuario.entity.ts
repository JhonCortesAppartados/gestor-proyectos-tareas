export interface Usuario {
    id: number,
    nombre: string,
    correo: string,
    password: string,
    esta_bloqueado: boolean,
    rol_id: number,
    creado_en: Date,
}