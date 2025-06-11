import { Router } from "express";
import { asignarUsuarioATarea, crearTarea, editarTarea, eliminarTarea, getTareas } from "../controllers/tarea.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { VerificarRol } from "../middlewares/role.middleware";


const router = Router();

router.get('/', verificarToken, getTareas);
router.post('/', verificarToken, VerificarRol(1), crearTarea);
router.patch('/asignar', verificarToken, VerificarRol(1), asignarUsuarioATarea);
router.put('/:id', verificarToken, editarTarea);
router.delete('/:id', verificarToken, VerificarRol(1), eliminarTarea);


export default router;