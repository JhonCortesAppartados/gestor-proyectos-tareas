import express from 'express';
import usuarioRoutes from './routes/usuario.routes';
import proyectosRoutes from './routes/proyectos.routes';
import tareaRoutes from './routes/tarea.routes';
import usuarioProyectoRoutes from './routes/usuario_proyecto.routes';
import registroRoutes from './routes/registro.routes';

const app = express();
app.use(express.json());

app.use('/api/usuarios', usuarioRoutes);
app.use('/api/proyectos', proyectosRoutes);
app.use('/api/tareas', tareaRoutes);
app.use('/api/usuarios-proyectos', usuarioProyectoRoutes);
app.use('/api/auth', registroRoutes);

app.listen(3000, () => {
  console.log('Servidor corriendo en puerto 3000');
});