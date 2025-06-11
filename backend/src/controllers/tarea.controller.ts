import { Request, Response } from "express";
import { TareaRepositoryImpl } from "../data/repositories/tarea.repository.impl";
import { TareaService } from "../services/tarea_service";


const tareaRepo = new TareaService(new TareaRepositoryImpl());

export const getTareas = async (req: Request, res: Response) => {
    try {
        const tareas = await tareaRepo.getTareas();
        res.status(200).json(tareas);
        return;
    } catch (error) {
        res.status(500).json({ message: 'Error al obtener Tareas' });
        return;
    }
};

export const crearTarea = async (req: Request, res: Response) => {
    try {
        const { titulo, descripcion, fecha_inicio, fecha_fin, estado, prioridad, proyecto_id, asignado_a, creado_por } = req.body;
        const tarea = await tareaRepo.crearTarea({ titulo, descripcion, fecha_inicio, fecha_fin, estado, prioridad, proyecto_id, asignado_a, creado_por });
        res.status(200).json(tarea);
        return;
    } catch (error) {
        res.status(500).json({ message: 'Error al crear la tarea' });
        return;
    }
};

export const asignarUsuarioATarea = async (req: Request, res: Response) => {
    try {
        const { tarea_id, usuario_id } = req.body;
        const result = await tareaRepo.asignarUsuarioATarea(tarea_id, usuario_id);
        res.status(200).json(result);
        return;
    } catch (error) {
        res.status(500).json({ message: 'Error al asignar usuario a la tarea' });
        return;
    }
};

export const editarTarea = async (req: Request, res: Response) => {
    const { id } = req.params;
    const datos = req.body;

    if (!id) {
        res.status(400).json({ message: 'ID de tarea es requerido' });
        return;
    }

    try {
        const result = await tareaRepo.editarTarea(Number(id), datos);
        const tareaActualizada = await tareaRepo.findById(Number(id));
        res.status(200).json(tareaActualizada);
        return;
    } catch (error) {
        res.status(500).json({ message: 'Error al actualizar la tarea' });
        return;
    }
};

export const eliminarTarea = async (req: Request, res: Response) => {
    const {id} = req.params;

    if(!id){
        res.status(400).json({ message: 'ID de tarea es requerido' });
        return;
    }

    try {
        const result = await tareaRepo.eliminarTarea(Number(id));
        res.status(200).json(result);
        return;
    } catch (error) {
        res.status(500).json({ message: 'Error al eliminar la tarea'});
        return;
    }
};