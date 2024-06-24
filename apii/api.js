import { Elysia } from 'elysia';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const app = new Elysia();

// Verificar si el servidor se abrió correctamente (Endpoint )
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
            mensaje: "Se realizó la petición correctamente"
            
        };
    } catch (error) {
        console.error(error);
        return {
            estado: 400,
            mensaje: "Ha existido un error al registrar el usuario",
        };
    }
});

app.post('/api/verificar', async ({ body }) => {
    console.log('Solicitud de verificación recibida:', body); 
    const { correo, clave } = body;
    try {
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
        });

        if (!usuario || usuario.clave !== clave) {
            console.log("Estado: 400")
            console.log("Mensaje: Usuario no encontrado o contraseña incorrecta"); 
            return {
                estado: 400,
                mensaje: "Usuario no encontrado o contraseña incorrecta"
            };
        }

        console.log('Usuario verificado:', usuario); 
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
        console.error('Error al verificar el usuario:', error); 
        return {
            estado: 400,
            mensaje: "Error al verificar el usuario",
            detalles: error.message
        };
    }
});

// Endpoint para enviar un correo
app.post('/api/enviarcorreo', async ({ body }) => {
    console.log('Solicitud para enviar correo recibida:', body);  
    const { remitente, destinatario, asunto, cuerpo } = body;
    console.log('Remitente:', remitente);  
    console.log('Destinatario:', destinatario);  

    if (!remitente || !destinatario || !asunto || !cuerpo) {
        return {
            estado: 400,
            mensaje: "Faltan datos necesarios para enviar el correo"
        };
    }

    try {
        // Verificar si el remitente existe
        const usuarioRemitente = await prisma.usuario.findUnique({
            where: { correo: remitente },
        });

        if (!usuarioRemitente) {
            return {
                estado: 400,
                mensaje: "Remitente no encontrado"
            };
        }

        // Verificar si el destinatario existe
        const usuarioDestinatario = await prisma.usuario.findUnique({
            where: { correo: destinatario },
        });

        if (!usuarioDestinatario) {
            return {
                estado: 400,
                mensaje: "Destinatario no encontrado"
            };
        }

        // Crear el nuevo correo
        const nuevoCorreo = await prisma.correo.create({
            data: {
                remitenteId: usuarioRemitente.id,
                destinatarioId: usuarioDestinatario.id,
                asunto: asunto,
                cuerpo: cuerpo,
                fechaEnvio: new Date()
            }
        });

        console.log('Correo enviado:', nuevoCorreo);
        return {
            estado: 200,
            mensaje: "Correo enviado correctamente",
            correo: nuevoCorreo
        };
    } catch (error) {
        console.error('Error al enviar el correo:', error);
        return {
            estado: 400,
            mensaje: "Ha existido un error al enviar el correo",
            detalles: error.message
        };
    }
});

// Endpoint para bloquear un usuario
app.post('/api/bloquear', async ({ body }) => {
    const { correo, clave, correo_bloquear } = body;
    console.log('Solicitud para bloquear usuario recibida:', body);
    try {
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
        });

        if (!usuario || usuario.clave !== clave) {
            return { 
                estado: 400,
                mensaje: "Ha existido un error al realizar la petición" 
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
            mensaje: "Se realizó la petición correctamente"
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
                mensaje: "Se realizo la peticion correctamente",
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
    console.log('Solicitud para marcar correo como favorito recibida:', body); 

    // Verificar si id_correo_favorito es un número
    if (!id_correo_favorito || isNaN(id_correo_favorito)) {
        return {
            estado: 400,
            mensaje: "ID de correo no válido. Debe ser un número."
        };
    }
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

        // Verificar si el correo existe y pertenece al usuario
        const correoExistente = await prisma.correo.findUnique({
            where: { id: parseInt(id_correo_favorito) },
        });

        if (!correoExistente) {
            return {
                estado: 400,
                mensaje: "Correo no encontrado"
            };
        }

        // Marcar el correo como favorito
        await prisma.correo.update({
            where: { id: parseInt(id_correo_favorito) },
            data: { esFavorito: true },
        });

        return {
            estado: 200,
            mensaje: "Correo marcado como favorito"
        };
    } catch (error) {
        console.error('Error al marcar correo como favorito:', error);
        return {
            estado: 400,
            mensaje: "Ha existido un error al realizar la petición",
            detalles: error.message
        };
    }
});
//--------------------------------------------------------------------------
app.get('/api/correosfavoritos/:correo', async ({ params }) => {
    const { correo } = params;
    console.log('Solicitud para obtener correos favoritos recibida:', correo);

    try {
        // Verificar si el usuario existe
        const usuario = await prisma.usuario.findUnique({
            where: { correo },
            select: {
                id: true,
                correosRecibidos: {
                    where: { esFavorito: true }
                },
                correosEnviados: {
                    where: { esFavorito: true }
                }
            }
        });

        if (!usuario) {
            return {
                estado: 400,
                mensaje: "Usuario no encontrado"
            };
        }

        const correosFavoritos = [
            ...usuario.correosRecibidos,
            ...usuario.correosEnviados
        ];

        return {
            estado: 200,
            mensaje: "Correos favoritos obtenidos correctamente",
            correos: correosFavoritos
        };
    } catch (error) {
        console.error('Error al obtener correos favoritos:', error);
        return {
            estado: 400,
            mensaje: "Ha existido un error al obtener los correos favoritos",
            detalles: error.message
        };
    }
});
//-------------------------------------------------------------------------

// Endpoint para desmarcar un correo como favorito
app.delete('/api/desmarcarcorreo', async ({ body }) => {
    const { correo, clave, id_correo_favorito } = body;
    console.log('Solicitud para desmarcar correo como favorito recibida:', body); 
    // Verificar si id_correo_favorito es un número
    if (!id_correo_favorito || isNaN(id_correo_favorito)) {
        return {
            estado: 400,
            mensaje: "ID de correo no válido. Debe ser un número."
        };
    }

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

        // Verificar si el correo existe
        const correoExistente = await prisma.correo.findUnique({
            where: { id: parseInt(id_correo_favorito) },
        });

        if (!correoExistente) {
            return {
                estado: 400,
                mensaje: "Correo no encontrado"
            };
        }

        // Desmarcar el correo como favorito
        await prisma.correo.update({
            where: { id: parseInt(id_correo_favorito) },
            data: { esFavorito: false },
        });

        return {
            estado: 200,
            mensaje: "Correo desmarcado como favorito"
        };
    } catch (error) {
        console.error('Error al desmarcar correo como favorito:', error);
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