import { Router } from 'express';
import { cambiarEstadoBloqueo, getUsuarios } from '../controllers/usuario.controller';
import { verificarToken } from '../middlewares/auth.middleware';
import { VerificarRol } from '../middlewares/role.middleware';

const router = Router();

router.get('/', verificarToken, getUsuarios);
router.patch('/:id/bloqueo', verificarToken, VerificarRol(1), cambiarEstadoBloqueo);

export default router;