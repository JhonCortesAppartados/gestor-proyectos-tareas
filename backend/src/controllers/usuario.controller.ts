import { Request, Response } from 'express';
import { UsuarioRepositoryImpl } from '../data/repositories/usuario.repository.impl';
import { UsuarioService } from '../services/usuario_service';

const usuarioRepo = new UsuarioService(new UsuarioRepositoryImpl());

export const getUsuarios = async (req: Request, res: Response) => {
  try {
    const usuarios = await usuarioRepo.getUsuarios();
    res.json(usuarios);
    return;
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener usuarios' });
    return;
  }
};

export const registrarUsuario = async (req: Request, res: Response) => {
  const {nombre, correo, password, rol_id} = req.body;

  if(!nombre || !correo || !password || !rol_id) {
    res.status(400).json({ message: 'Faltan datos requeridos' });
    return;
  }

  try {       
    const usuario = await usuarioRepo.registrarUsuario({ nombre, correo, password, rol_id });
    res.status(201).json({message: 'Usuario registrado exitosamente', usuario});
    return;
  } catch (error: any) {
    res.status(500).json({ message: 'Error al registrar usuario', error: error.message });
    return;
  }
};

export const cambiarEstadoBloqueo = async (req: Request, res: Response) => {
  const {id} = req.params;
  const {estado} = req.body;

  if(typeof estado !== 'boolean') {
    res.status(400).json({ message: 'El estado debe ser un booleano (true o false)' });
    return;
  }
  try {
    
    const result = await usuarioRepo.bloquearUsuario(Number(id), estado);
    res.json(result);
    return;
  } catch (error: any) {
    res.status(500).json({ message: 'Error al cambiar estado de bloqueo', error: error.message });
    return;
  }
};