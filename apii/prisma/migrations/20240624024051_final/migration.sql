/*
  Warnings:

  - You are about to drop the column `estiloFirmaId` on the `Correo` table. All the data in the column will be lost.
  - You are about to drop the `EstiloFirma` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `TemaCorreo` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Correo" DROP CONSTRAINT "Correo_estiloFirmaId_fkey";

-- DropForeignKey
ALTER TABLE "Correo" DROP CONSTRAINT "Correo_temaId_fkey";

-- DropIndex
DROP INDEX "Correo_estiloFirmaId_key";

-- AlterTable
ALTER TABLE "Correo" DROP COLUMN "estiloFirmaId";

-- DropTable
DROP TABLE "EstiloFirma";

-- DropTable
DROP TABLE "TemaCorreo";
