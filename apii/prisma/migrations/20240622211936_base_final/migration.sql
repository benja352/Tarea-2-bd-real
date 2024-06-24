/*
  Warnings:

  - You are about to drop the column `destinatario` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the column `mensaje` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the column `remitente` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the column `usuarioId` on the `Correo` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[estiloFirmaId]` on the table `Correo` will be added. If there are existing duplicate values, this will fail.
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
ADD COLUMN     "estiloFirmaId" INTEGER,
ADD COLUMN     "fechaEnvio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "fechaMostradoAnuncio" TIMESTAMP(3),
ADD COLUMN     "leido" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "nombreAnimacion" TEXT,
ADD COLUMN     "remitenteId" INTEGER NOT NULL,
ADD COLUMN     "temaId" INTEGER;

-- AlterTable
ALTER TABLE "Usuario" ADD COLUMN     "fechaCreacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

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
