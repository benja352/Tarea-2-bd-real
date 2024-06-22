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
        return {
            estado: 200,
            mensaje: "Se realizó la petición correctamente",
            usuario: nuevoUsuario
        };
    } catch (error) {
        console.error(error);
        return {
            estado: 400,
            mensaje: "Ha existido un error al realizar la petición",
            detalles: error.message
        };
    }
});

// Endpoint para verificar usuario
app.post('/api/verificar', async ({ body }) => {
    const { correo, clave } = body;
    try {
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
        });

        if (!usuario || usuario.clave !== clave) {
            return {
                estado: 400,
                mensaje: "Usuario no encontrado o contraseña incorrecta"
            };
        }

        return {
            estado: 200,
            mensaje: "Usuario verificado",
            usuario: {
                id: usuario.id,
                nombre: usuario.nombre,
                correo: usuario.correo,
                descripcion: usuario.descripcion,
                fechaCreacion: usuario.fechaCreacion
            }
        };
    } catch (error) {
        console.error(error);
        return {
            estado: 400,
            mensaje: "Error al verificar el usuario",
            detalles: error.message
        };
    }
});

// Endpoint para bloquear un usuario
app.post('/api/bloquear', async ({ body }) => {
    const { correo, clave, correo_bloquear } = body;
    try {
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
        });

        if (!usuario || usuario.clave !== clave) {
            return { 
                estado: 400,
                mensaje: "Autenticación fallida" 
            };
        }

        await prisma.direccionBloqueada.create({
            data: {
                usuarioId: usuario.id,
                direccionBloqueada: correo_bloquear,
            },
        });

        return {
            estado: 200,
            mensaje: "Usuario bloqueado correctamente"
        };
    } catch (error) {
        console.error(error);
        return {
            estado: 400,
            mensaje: "Ha existido un error al realizar la petición",
            detalles: error.message
        };
    }
});

// Endpoint para obtener información de un usuario
app.get('/api/informacion/:correo', async ({ params }) => {
    const { correo } = params;
    try {
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
            select: {
                nombre: true,
                correo: true,
                descripcion: true,
            },
        });
        if (usuario) {
            return {
                estado: 200,
                ...usuario
            };
        } else {
            return {
                estado: 400,
                mensaje: "Usuario no encontrado"
            };
        }
    } catch (error) {
        console.error(error);
        return {
            estado: 400,
            mensaje: "Error al obtener información del usuario",
            detalles: error.message
        };
    }
});

// Endpoint para marcar un correo como favorito
app.post('/api/marcarcorreo', async ({ body }) => {
    const { correo, clave, id_correo_favorito } = body;
    try {
        // Verificar la autenticación del usuario
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
        });

        if (!usuario || usuario.clave !== clave) {
            return { 
                estado: 400,
                mensaje: "Autenticación fallida" 
            };
        }

        // Marcar el correo como favorito
        await prisma.correo.update({
            where: { id: id_correo_favorito },
            data: { esFavorito: true },
        });

        return {
            estado: 200,
            mensaje: "Correo marcado como favorito"
        };
    } catch (error) {
        console.error(error);
        return {
            estado: 400,
            mensaje: "Ha existido un error al realizar la petición",
            detalles: error.message
        };
    }
});

// Endpoint para desmarcar un correo como favorito
app.delete('/api/desmarcarcorreo', async ({ body }) => {
    const { correo, clave, id_correo_favorito } = body;
    try {
        // Verificar la autenticación del usuario
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
        });

        if (!usuario || usuario.clave !== clave) {
            return { 
                estado: 400,
                mensaje: "Autenticación fallida" 
            };
        }

        // Desmarcar el correo como favorito
        await prisma.correo.update({
            where: { id: id_correo_favorito },
            data: { esFavorito: false },
        });

        return {
            estado: 200,
            mensaje: "Correo desmarcado como favorito"
        };
    } catch (error) {
        console.error(error);
        return {
            estado: 400,
            mensaje: "Ha existido un error al realizar la petición",
            detalles: error.message
        };
    }
});

// Iniciar el servidor en el puerto 3000
app.listen(3000);
console.log("Servidor escuchando en el puerto 3000");