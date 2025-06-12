import { Request, Response } from "express";
import { TareaRepositoryImpl } from "../data/repositories/tarea.repository.impl";
import { TareaService } from "../services/tarea_service";
import moment from "moment";


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

        let date = moment(tarea.fecha_inicio).format('YYYY-MM-DD');
        tarea.fecha_inicio = date;
        if (tarea.fecha_fin != "null" && tarea.fecha_fin != null) {
            let dateEnd = moment(tarea.fecha_fin).format('YYYY-MM-DD');
            tarea.fecha_fin = dateEnd;
        }

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
        let date = moment(datos.fecha_inicio).format('YYYY-MM-DD');
        datos.fecha_inicio = date;
        if (datos.fecha_fin != "null" && datos.fecha_fin != null) {
            let dateEnd = moment(datos.fecha_fin).format('YYYY-MM-DD');
            datos.fecha_fin = dateEnd;
        }
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
    const { id } = req.params;

    if (!id) {
        res.status(400).json({ message: 'ID de tarea es requerido' });
        return;
    }

    try {
        const result = await tareaRepo.eliminarTarea(Number(id));
        res.status(200).json(result);
        return;
    } catch (error) {
        res.status(500).json({ message: 'Error al eliminar la tarea' });
        return;
    }
};