import { Router } from "express";
import { asignarUsuarioAProyecto } from "../controllers/usuarios_proyecto.controller";
import { verificarToken } from "../middlewares/auth.middleware";
import { VerificarRol } from "../middlewares/role.middleware";


const router = Router();

router.post('/asignar', verificarToken, VerificarRol(1), asignarUsuarioAProyecto);

export default router;