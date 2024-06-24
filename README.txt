PASOS PARA CORRER PROGRAMA:

1.Crear una base da datos en pgAdmin 4 donde se almacenaran tablas del programa.

2.En archivo .env que esta dentro de la carpeta apii, poner su contraseña y nombre en url de Base de datos.

3.ejecutar en la terminal de la carpeta apii los siguientes comandos:
powershell -c "irm bun.sh/install.ps1 | iex"
bun install
npx prisma migrate dev
npx prisma generate 

4.volver a la raiz del proyecto y en la terminal de la carpeta cliente ejecutar (debe tener pip instalado):
pip install -r requirements.txt

5.Una vez todo listo procedemos a abrir el servidor, vamos a carpeta apii y escribimos en la terminal:
Bun api.js
verificamos que el servidor este corriendo (opcional):
curl http://localhost:3000/

6.finalmente para correr el programa volvemos a la raiz y ponemos:
python cliente/cliente.py

6.5. Ahora cada vez que quiera correr el programa solo debe repetir los pasos 5 y 6.

FUNCIONAMIENTO DEL PROGRAMA:
-Al iniciar el programa se abre una interfaz que le permitira al usuario registrarse en el sistema
o entrar con una cuenta ya registrada anteriormente. Si elegimos la opcion dos se nos pedira un correo y una contraseña
los cuales si no estan registrados no podra iniciar sesion.

-Una vez iniciada sesion tenemos 7 opciones (2 mas que los requerimtos de la tarea). Agregamos la opcion de "bloquear usuario" y "desmarcar de favorito"
ya que en la seccion 4 de la tarea (Endpoints) se nos pidio que hagamos estos Endpoints, pero en cliente nunca los usamos, asi que los agregamos en nuestro programa.

Consideraciones: Dos integrantes de los 3 hicimos commit al github ya que el tercero fallo su computadora (Sebastian). Por suerte al ser hermanos el y yo, trabajamos desde un computador. 
Ademas la carpeta apii quisimos llamarla "api" pero nos fallo el programa, consideramos que sigue todavia el formato de condicioenes de entrega. 

Finalmente, tuvimos problemas para subir el commit final a la rama main de Github por lo que decidimos dejar como "Main" la rama Rama-Benjamin ya que ahi esta la tarea completada correctamente. Se agradece comprension en este ambito.