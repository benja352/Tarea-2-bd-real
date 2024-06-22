-- CreateTable
CREATE TABLE "Usuario" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "correo" TEXT NOT NULL,
    "clave" TEXT NOT NULL,
    "descripcion" TEXT,
    "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Usuario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Correo" (
    "id" SERIAL NOT NULL,
    "remitenteId" INTEGER NOT NULL,
    "destinatarioId" INTEGER NOT NULL,
    "asunto" TEXT NOT NULL,
    "cuerpo" TEXT NOT NULL,
    "fechaEnvio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leido" BOOLEAN NOT NULL DEFAULT false,
    "esFavorito" BOOLEAN NOT NULL DEFAULT false,
    "colorFondo" TEXT,
    "nombreAnimacion" TEXT,
    "duracionAnimacion" INTEGER,
    "contenidoAnuncio" TEXT,
    "fechaMostradoAnuncio" TIMESTAMP(3),
    "estiloFirmaId" INTEGER,
    "temaId" INTEGER,

    CONSTRAINT "Correo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DireccionBloqueada" (
    "id" SERIAL NOT NULL,
    "usuarioId" INTEGER NOT NULL,
    "direccionBloqueada" TEXT NOT NULL,
    "fechaBloqueo" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DireccionBloqueada_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DireccionFavorita" (
    "id" SERIAL NOT NULL,
    "usuarioId" INTEGER NOT NULL,
    "direccionFavorita" TEXT NOT NULL,
    "fechaAgregado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "categoria" TEXT,

    CONSTRAINT "DireccionFavorita_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TemaCorreo" (
    "id" SERIAL NOT NULL,
    "nombreTema" TEXT NOT NULL,

    CONSTRAINT "TemaCorreo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EstiloFirma" (
    "id" SERIAL NOT NULL,
    "nombreEstilo" TEXT NOT NULL,
    "fuente" TEXT NOT NULL,

    CONSTRAINT "EstiloFirma_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_correo_key" ON "Usuario"("correo");

-- CreateIndex
CREATE UNIQUE INDEX "Correo_estiloFirmaId_key" ON "Correo"("estiloFirmaId");

-- AddForeignKey
ALTER TABLE "Correo" ADD CONSTRAINT "Correo_remitenteId_fkey" FOREIGN KEY ("remitenteId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Correo" ADD CONSTRAINT "Correo_destinatarioId_fkey" FOREIGN KEY ("destinatarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Correo" ADD CONSTRAINT "Correo_estiloFirmaId_fkey" FOREIGN KEY ("estiloFirmaId") REFERENCES "EstiloFirma"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Correo" ADD CONSTRAINT "Correo_temaId_fkey" FOREIGN KEY ("temaId") REFERENCES "TemaCorreo"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DireccionBloqueada" ADD CONSTRAINT "DireccionBloqueada_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DireccionFavorita" ADD CONSTRAINT "DireccionFavorita_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
