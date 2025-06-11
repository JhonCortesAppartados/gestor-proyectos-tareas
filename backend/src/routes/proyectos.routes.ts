import { Router } from "express";
import { crearProyecto, eliminarProyecto, getProyectos } from "../controllers/proyecto.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { VerificarRol } from "../middlewares/role.middleware";


const router = Router();

router.get('/', verificarToken, getProyectos);
router.post('/', verificarToken, VerificarRol(1), crearProyecto);
router.delete('/:id', verificarToken, VerificarRol(1), eliminarProyecto);

export default router;