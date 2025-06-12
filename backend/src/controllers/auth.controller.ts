import { Request, Response } from "express";
import { UsuarioRepositoryImpl } from "../data/repositories/usuario.repository.impl";
import { compare } from "bcrypt";
import {sign} from "../shared/libs/jwt";

//Se utiliza express como framework, para poder construir las peticiones HTTP.

const usuarioRepo = new UsuarioRepositoryImpl();

// Se crea el metodo del controlador del login para veirifcar la información que se recibe.
export const loginUsuario = async (req: Request, res: Response) => {
    const { correo, password } = req.body;
    
    //Si no recibe el correo o la contraseña da el aviso de que los datos son requeridos.
    if (!correo || !password) {
        res.status(400).json({ message: "Correo y contraseña son requeridos" });
        return;
    }
    
    //Validaciones que se hacen con la información que se recibe.
    try {
        const usuario = await usuarioRepo.findByCorreo(correo);
        if(!usuario) {
            res.status(401).json({ message: "Credenciales inválidas" });
            return;
        }

        if(usuario.esta_bloqueado) {
            res.status(403).json({ message: "Usuario bloqueado" });
            return;
        }

        const passwordValido = await compare(password, usuario.password);
        if(!passwordValido){
            res.status(401).json({ message: "Credenciales inválidas" });
            return;
        }

        const token = sign(
            {id: usuario.id, nombre: usuario.correo, rol_id: usuario.rol_id},
            process.env.JWT_SECRET || "secreto",
            { expiresIn: "2h" }
        );

        res.json({
            message: 'Login exitoso',
            token,
            usuario: {
                id: usuario.id,
                nombre: usuario.nombre,
                correo: usuario.correo,
                rol_id: usuario.rol_id,
            }
        });
    } catch (error: any) {
        res.status(500).json({ message: 'Error en el login', error: error.message });
        return;
    }
};