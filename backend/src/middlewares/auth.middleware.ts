import { NextFunction, Request, Response } from "express";
import {verify} from "../shared/libs/jwt";

export const verificarToken = (req: Request, res: Response, next: NextFunction) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if(!token){
        res.status(401).json({message: 'Token requerido'});
        return;
    }
     try {
        const decoded = verify(token, process.env.JWT_SECRET || 'secreto');
        (req as any).usuario = decoded;
        next();
     } catch (error) {
        res.status(401).json({message: 'Token inválido'});
        return;
     }
};