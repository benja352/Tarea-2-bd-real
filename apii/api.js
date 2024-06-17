import { Elysia } from 'elysia';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const app = new Elysia();

// Endpoint para registrar usuario
app.post('/api/registrar', async (req, res) => {
    const { nombre, correo, clave, descripcion } = req.body;
    try {
        const nuevoUsuario = await prisma.usuario.create({
            data: { nombre, correo, clave, descripcion },
        });
        res.status(200).json(nuevoUsuario);
    } catch (error) {
        res.status(400).json({ error: "Error al registrar usuario" });
    }
});

// Endpoint para bloquear un usuario
app.post('/api/bloquear', async (req, res) => {
    const { correo, clave, correo_bloquear } = req.body;
    try {
        const usuario = await prisma.usuario.update({
            where: { correo: correo_bloquear },
            data: { bloqueado: true },
        });
        res.status(200).json({ mensaje: "Usuario bloqueado correctamente" });
    } catch (error) {
        res.status(400).json({ error: "Error al bloquear usuario" });
    }
});

// Endpoint para obtener información de un usuario
app.get('/api/informacion/:correo', async (req, res) => {
    const { correo } = req.params;
    try {
        const usuario = await prisma.usuario.findUnique({
            where: { correo: correo },
        });
        if (usuario) {
            res.status(200).json(usuario);
        } else {
            res.status(404).json({ error: "Usuario no encontrado" });
        }
    } catch (error) {
        res.status(400).json({ error: "Error al obtener información del usuario" });
    }
});

app.listen(3000, () => {
    console.log('Servidor escuchando en el puerto 3000');
});
