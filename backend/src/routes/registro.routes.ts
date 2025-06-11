import { Router } from "express";
import { registrarUsuario} from "../controllers/usuario.controller";
import { loginUsuario } from "../controllers/auth.controller";

const router = Router();

router.post('/register', registrarUsuario);
router.post('/login', loginUsuario);


export default router;