export interface Tarea {
    id: number,
    titulo: string,
    descripcion: string,
    fecha_inicio: Date,
    fecha_fin: Date | null,
    estado: string,
    prioridad: number,
    proyecto_id: number,
    asignado_a: number;
    creado_por: number;
}