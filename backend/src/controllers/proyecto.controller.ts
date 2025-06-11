import { Request, Response } from "express";
import { ProyectoRepositoryImpl } from "../data/repositories/proyecto.repository.impl";
import { ProyectoService } from "../services/proyecto_service";

const proyectoRepo = new ProyectoService(new ProyectoRepositoryImpl());

export const getProyectos = async (req: Request, res: Response) => {
    try {
        const proyectos = await proyectoRepo.getProyectos();
        res.status(200).json(proyectos);
        return;
    } catch (error) {
        res.status(500).json({ message: "Error al obtener Proyectos" });
        return;
    }
};

export const crearProyecto = async (req: Request, res: Response) => {
    try {
        const {titulo, descripcion, fecha_inicio, fecha_fin, creado_por} = req.body;
        const proyecto = await proyectoRepo.crearProyecto({titulo, descripcion, fecha_inicio, fecha_fin, creado_por});
        res.status(201).json(proyecto);
        return;
    } catch (error) {
        res.status(500).json({ message: "Error al crear Proyecto" });
        return;
    }
};

export const eliminarProyecto = async (req: Request, res: Response) => {
    const {id} = req.params;

    if(!id) {
        res.status(400).json({ message: 'ID de proyecto es requerido' });
        return;
    }

    try {
        const result = await proyectoRepo.eliminarProyecto(Number(id));
        res.json(result);
        return;
    } catch (error) {
        res.status(500).json({ message: 'Error al eliminar el proyecto' });
        return;
    }
};