import requests

# URL base de la API
BASE_URL = "http://localhost:3000"


# Función para registrar un usuario
def registrar_usuario(nombre, correo, clave, descripcion):
    url = f"{BASE_URL}/api/registrar"
    payload = {
        "nombre": nombre,
        "correo": correo,
        "clave": clave,
        "descripcion": descripcion
    }
    response = requests.post(url, json=payload)
    return response.json()


# Función para Enviar un correo a un usuario
def enviar_correo(remitente, destinatario, asunto, cuerpo):
    url = f"{BASE_URL}/api/enviarcorreo"
    payload = {
        "remitente": remitente,
        "destinatario": destinatario,
        "asunto": asunto,
        "cuerpo": cuerpo
    }
    print("Payload enviado:", payload)  
    response = requests.post(url, json=payload)
    return handle_response(response)


# Función auxiliar para manejar respuesta de la API
def handle_response(response):
    try:
        response.raise_for_status()  
        return response.json()
    except requests.exceptions.HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}")
    except requests.exceptions.RequestException as req_err:
        print(f"Error occurred: {req_err}")
    except requests.exceptions.JSONDecodeError:
        print("Error al decodificar JSON. Respuesta del servidor:", response.text)
    return None

# Función para verificar la autenticación de un usuario
def verificar_usuario(correo, clave):
    url = f"{BASE_URL}/api/verificar"
    payload = {
        "correo": correo,
        "clave": clave
    }
    response = requests.post(url, json=payload)
    return handle_response(response)

# Función para bloquear a un usuario
def bloquear_usuario(correo, clave, correo_bloquear):
    url = f"{BASE_URL}/api/bloquear"
    payload = {
        "correo": correo,
        "clave": clave,
        "correo_bloquear": correo_bloquear
    }
    response = requests.post(url, json=payload)
    return response.json()

# Función para obtener información de un usuario
def obtener_informacion(correo):
    url = f"{BASE_URL}/api/informacion/{correo}"
    response = requests.get(url)
    return response.json()

# Función para marcar un correo como favorito
def marcar_correo(correo, clave, id_correo_favorito):
    url = f"{BASE_URL}/api/marcarcorreo"
    payload = {
        "correo": correo,
        "clave": clave,
        "id_correo_favorito": id_correo_favorito
    }
    response = requests.post(url, json=payload)
    return handle_response(response)

# Función para desmarcar un correo como favorito
def desmarcar_correo(correo, clave, id_correo_favorito):
    url = f"{BASE_URL}/api/desmarcarcorreo"
    payload = {
        "correo": correo,
        "clave": clave,
        "id_correo_favorito": id_correo_favorito
    }
    response = requests.delete(url, json=payload)
    return response.json()

# Función para obtener los correos favoritos de un usuario
def obtener_correos_favoritos(correo):
    url = f"{BASE_URL}/api/correosfavoritos/{correo}"
    response = requests.get(url)
    return handle_response(response)

def main():
    print("Bienvenido a CommuniKen")
    while True:
        print("1. Registrar Usuario")
        print("2. Estoy registrado")
        print("3. Salir")
        inicio = input("Elige una opción: ") 

        if inicio == "1":
            nombre = input("Nombre: ")
            correo = input("Correo: ")
            clave = input("Clave: ")
            descripcion = input("Descripción: ")
            resultado = registrar_usuario(nombre, correo, clave, descripcion)
            print("Resultado:", resultado)
        elif inicio == "2":
            correo_u = input("Escriba su correo: ")
            clave_u = input("Escriba su contraseña: ")
            verificacion = verificar_usuario(correo_u, clave_u)
            if verificacion["estado"] == 200:
                while True:
                    print("1. Enviar un correo")
                    print("2. Ver información de una dirección de correo electrónico")
                    print("3. Ver correos marcados como favoritos")
                    print("4. Marcar correo como favorito")
                    print("5. Desmarcar correo como favorito")
                    print("6. Bloquear Usuario")
                    print("7. Terminar con la ejecución del cliente")
                    
                    opcion = input("Elige una opción: ")
                    
                    if opcion == "1":
                        remitente_correo = correo_u
                        destinatario_correo = input("Correo del destinatario: ")
                        asunto = input("Asunto: ")
                        cuerpo = input("Cuerpo: ")
                        resultado = enviar_correo(remitente_correo, destinatario_correo, asunto, cuerpo)
                        print("Resultado:", resultado)
                    elif opcion == "2":
                        correo = input("Correo del usuario: ")
                        resultado = obtener_informacion(correo)
                        print("Información del usuario:", resultado)                
                    elif opcion == "3":
                        resultado = obtener_correos_favoritos(correo_u)
                        print("Correos favoritos:", resultado)
                    elif opcion == "4":
                        while True:
                            try:
                                id_correo_favorito = int(input("ID del correo a marcar como favorito: "))
                                break  
                            except ValueError:
                                print("ID de correo no válido. Debe ser un número.")
                        
                        resultado = marcar_correo(correo_u, clave_u, id_correo_favorito)
                        print("Resultado:", resultado) 
                    elif opcion == "5":
                        id_correo_favorito = int(input("ID del correo a desmarcar como favorito: "))
                        resultado = desmarcar_correo(correo_u, clave_u, id_correo_favorito)
                        print("Resultado:", resultado)     
                    elif opcion == "6":
                        correo_bloquear = input("Correo del usuario a bloquear: ")
                        resultado = bloquear_usuario(correo_u, clave_u, correo_bloquear)
                        print("Resultado:", resultado)
                    elif opcion == "7":
                        break
                    else:
                        print("Opción no válida")
            else:
                print("Usuario no encontrado o contraseña incorrecta")
        elif inicio == "3":
            exit()            
        else:
            print("Opción no válida")
            break

if __name__ == "__main__":
    main()
