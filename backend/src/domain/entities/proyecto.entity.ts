export interface Proyecto {
    id: number;
    titulo: string;
    descripcion: string;
    fecha_inicio: Date;
    fecha_fin: Date | null;
    creado_por: number; // ID del usuario que creó el proyecto
}