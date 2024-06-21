/*
  Warnings:

  - You are about to drop the column `destinatario` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the column `mensaje` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the column `remitente` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the column `usuarioId` on the `Correo` table. All the data in the column will be lost.
  - Added the required column `cuerpo` to the `Correo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `destinatarioId` to the `Correo` table without a default value. This is not possible if the table is not empty.
  - Added the required column `remitenteId` to the `Correo` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Correo" DROP CONSTRAINT "Correo_usuarioId_fkey";

-- AlterTable
ALTER TABLE "Correo" DROP COLUMN "destinatario",
DROP COLUMN "mensaje",
DROP COLUMN "remitente",
DROP COLUMN "usuarioId",
ADD COLUMN     "colorFondo" TEXT,
ADD COLUMN     "contenidoAnuncio" TEXT,
ADD COLUMN     "cuerpo" TEXT NOT NULL,
ADD COLUMN     "destinatarioId" INTEGER NOT NULL,
ADD COLUMN     "duracionAnimacion" INTEGER,
ADD COLUMN     "esFavorito" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "fechaEnvio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "fechaMostradoAnuncio" TIMESTAMP(3),
ADD COLUMN     "fuenteFirma" TEXT,
ADD COLUMN     "leido" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "nombreAnimacion" TEXT,
ADD COLUMN     "nombreEstiloFirma" TEXT,
ADD COLUMN     "remitenteId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Usuario" ADD COLUMN     "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "fuentePreferida" TEXT;

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
    "usuarioCreadorId" INTEGER NOT NULL,

    CONSTRAINT "TemaCorreo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Publicidad" (
    "id" SERIAL NOT NULL,
    "contenidoAnuncio" TEXT NOT NULL,
    "fechaMostrado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuarioId" INTEGER NOT NULL,

    CONSTRAINT "Publicidad_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PluginCorreo" (
    "id" SERIAL NOT NULL,
    "nombrePlugin" TEXT NOT NULL,
    "correosAfectados" TEXT NOT NULL,
    "idiomasSoportados" TEXT NOT NULL,
    "estiloFirmaId" INTEGER NOT NULL,

    CONSTRAINT "PluginCorreo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EstiloFirma" (
    "id" SERIAL NOT NULL,
    "nombreEstilo" TEXT NOT NULL,
    "fuente" TEXT NOT NULL,
    "correoId" INTEGER NOT NULL,

    CONSTRAINT "EstiloFirma_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "EstiloFirma_correoId_key" ON "EstiloFirma"("correoId");

-- AddForeignKey
ALTER TABLE "Correo" ADD CONSTRAINT "Correo_remitenteId_fkey" FOREIGN KEY ("remitenteId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Correo" ADD CONSTRAINT "Correo_destinatarioId_fkey" FOREIGN KEY ("destinatarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DireccionBloqueada" ADD CONSTRAINT "DireccionBloqueada_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DireccionFavorita" ADD CONSTRAINT "DireccionFavorita_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TemaCorreo" ADD CONSTRAINT "TemaCorreo_usuarioCreadorId_fkey" FOREIGN KEY ("usuarioCreadorId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Publicidad" ADD CONSTRAINT "Publicidad_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PluginCorreo" ADD CONSTRAINT "PluginCorreo_estiloFirmaId_fkey" FOREIGN KEY ("estiloFirmaId") REFERENCES "EstiloFirma"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EstiloFirma" ADD CONSTRAINT "EstiloFirma_correoId_fkey" FOREIGN KEY ("correoId") REFERENCES "Correo"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
