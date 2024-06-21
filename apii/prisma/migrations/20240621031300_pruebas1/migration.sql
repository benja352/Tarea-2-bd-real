/*
  Warnings:

  - You are about to drop the column `fuenteFirma` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the column `nombreEstiloFirma` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the column `correoId` on the `EstiloFirma` table. All the data in the column will be lost.
  - You are about to drop the column `usuarioCreadorId` on the `TemaCorreo` table. All the data in the column will be lost.
  - You are about to drop the column `fuentePreferida` on the `Usuario` table. All the data in the column will be lost.
  - You are about to drop the `PluginCorreo` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Publicidad` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[estiloFirmaId]` on the table `Correo` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "EstiloFirma" DROP CONSTRAINT "EstiloFirma_correoId_fkey";

-- DropForeignKey
ALTER TABLE "PluginCorreo" DROP CONSTRAINT "PluginCorreo_estiloFirmaId_fkey";

-- DropForeignKey
ALTER TABLE "Publicidad" DROP CONSTRAINT "Publicidad_usuarioId_fkey";

-- DropForeignKey
ALTER TABLE "TemaCorreo" DROP CONSTRAINT "TemaCorreo_usuarioCreadorId_fkey";

-- DropIndex
DROP INDEX "EstiloFirma_correoId_key";

-- AlterTable
ALTER TABLE "Correo" DROP COLUMN "fuenteFirma",
DROP COLUMN "nombreEstiloFirma",
ADD COLUMN     "estiloFirmaId" INTEGER,
ADD COLUMN     "temaId" INTEGER;

-- AlterTable
ALTER TABLE "EstiloFirma" DROP COLUMN "correoId";

-- AlterTable
ALTER TABLE "TemaCorreo" DROP COLUMN "usuarioCreadorId";

-- AlterTable
ALTER TABLE "Usuario" DROP COLUMN "fuentePreferida";

-- DropTable
DROP TABLE "PluginCorreo";

-- DropTable
DROP TABLE "Publicidad";

-- CreateIndex
CREATE UNIQUE INDEX "Correo_estiloFirmaId_key" ON "Correo"("estiloFirmaId");

-- AddForeignKey
ALTER TABLE "Correo" ADD CONSTRAINT "Correo_estiloFirmaId_fkey" FOREIGN KEY ("estiloFirmaId") REFERENCES "EstiloFirma"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Correo" ADD CONSTRAINT "Correo_temaId_fkey" FOREIGN KEY ("temaId") REFERENCES "TemaCorreo"("id") ON DELETE SET NULL ON UPDATE CASCADE;
