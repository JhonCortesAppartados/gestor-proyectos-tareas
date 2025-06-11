import { Request, Response } from "express";
import { UsuarioProyectoRepositoryImpl } from "../data/repositories/usuario_proyecto.repository.impl";


const usuarioProyectoRepo = new UsuarioProyectoRepositoryImpl();

export const asignarUsuarioAProyecto = async (req: Request, res: Response) => {
    try {
        const { usuario_id, proyecto_id } = req.body;
        await usuarioProyectoRepo.asignar(usuario_id, proyecto_id);
        res.status(201).json({ message: "Usuario asignado al proyecto correctamente" });
        return;
    } catch (error) {
        res.status(500).json({ message: "Error al asignar usuario al proyecto" });
        return;
    }
}