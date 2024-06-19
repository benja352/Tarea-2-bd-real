import { Elysia } from 'elysia';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const app = new Elysia();

// Verificar si el servidor se abrió correctamente
app.get('/', async () => {
    return { message: "El servidor está corriendo correctamente" };
});

// Endpoint para registrar usuario
app.post('/api/registrar', async ({ body }) => {
    const { nombre, correo, clave, descripcion } = body;
    try {
        const nuevoUsuario = await prisma.usuario.create({
            data: { nombre, correo, clave, descripcion },
        });
        console.log('Usuario creado:', nuevoUsuario);  
        return nuevoUsuario;
    } catch (error) {
        console.error(error);
        return { error: "Error al registrar usuario", details: error.message };
    }
});

// Endpoint para bloquear un usuario
app.post('/api/bloquear', async ({ body }) => {
    const { correo, clave, correo_bloquear } = body;
    try {
        const usuario = await prisma.usuario.update({
            where: { correo: correo_bloquear },
            data: { bloqueado: true },
        });
        return { mensaje: "Usuario bloqueado correctamente" };
    } catch (error) {
        return { error: "Error al bloquear usuario" };
    }
});

// Endpoint para obtener información de un usuario
app.get('/api/informacion/:correo', async ({ params }) => {
    const { correo } = params;
    try {
        const usuario = await prisma.usuario.findUnique({
            where: { correo: correo },
        });
        if (usuario) {
            return usuario;
        } else {
            return { error: "Usuario no encontrado" };
        }
    } catch (error) {
        return { error: "Error al obtener información del usuario" };
    }
});

// Iniciar el servidor en el puerto 3000
app.listen(3000);
console.log("Servidor escuchando en el puerto 3000");