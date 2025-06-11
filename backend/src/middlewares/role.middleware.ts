import {Request, Response, NextFunction} from 'express';


export const VerificarRol = (rol_id_permitido: number) => {
    return (req: Request, res: Response, next: NextFunction) => {
        const usuario = (req as any).usuario; // Asumiendo que el usuario está en req.usuario
        if (!usuario || usuario.rol_id !== rol_id_permitido) {
            res.status(403).json({message: 'No tienes permisos suficientes'});
            return;
        }
        next();
    };
}