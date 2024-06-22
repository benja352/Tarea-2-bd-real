import requests

# URL base de la API
BASE_URL = "http://localhost:3000"

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

def handle_response(response):
    try:
        response.raise_for_status()  # Verificar si hubo algún error HTTP
        return response.json()
    except requests.exceptions.HTTPError as http_err:
        print(f"HTTP error occurred: {http_err}")
    except requests.exceptions.RequestException as req_err:
        print(f"Error occurred: {req_err}")
    except requests.exceptions.JSONDecodeError:
        print("Error al decodificar JSON. Respuesta del servidor:", response.text)
    return None

def verificar_usuario(correo, clave):
    url = f"{BASE_URL}/api/verificar"
    payload = {
        "correo": correo,
        "clave": clave
    }
    response = requests.post(url, json=payload)
    return handle_response(response)

def bloquear_usuario(correo, clave, correo_bloquear):
    url = f"{BASE_URL}/api/bloquear"
    payload = {
        "correo": correo,
        "clave": clave,
        "correo_bloquear": correo_bloquear
    }
    response = requests.post(url, json=payload)
    return response.json()

def obtener_informacion(correo):
    url = f"{BASE_URL}/api/informacion/{correo}"
    response = requests.get(url)
    return response.json()

def marcar_correo(correo, clave, id_correo_favorito):
    url = f"{BASE_URL}/api/marcarcorreo"
    payload = {
        "correo": correo,
        "clave": clave,
        "id_correo_favorito": id_correo_favorito
    }
    response = requests.post(url, json=payload)
    return response.json()

def desmarcar_correo(correo, clave, id_correo_favorito):
    url = f"{BASE_URL}/api/desmarcarcorreo"
    payload = {
        "correo": correo,
        "clave": clave,
        "id_correo_favorito": id_correo_favorito
    }
    response = requests.delete(url, json=payload)
    return response.json()

def main():
    print("Bienvenido a CommuniKen")
    while True:
        print("1. Registrar Usuario")
        print("2. Bloquear Usuario")
        print("3. Estoy registrado")
        print("4. Salir")
        inicio = input("Elige una opción: ") 

        if inicio == "1":
            nombre = input("Nombre: ")
            correo = input("Correo: ")
            clave = input("Clave: ")
            descripcion = input("Descripción: ")
            resultado = registrar_usuario(nombre, correo, clave, descripcion)
            print("Resultado:", resultado)
        elif inicio == "2":
            correo = input("Correo: ")
            clave = input("Clave: ")
            correo_bloquear = input("Correo del usuario a bloquear: ")
            resultado = bloquear_usuario(correo, clave, correo_bloquear)
            print("Resultado:", resultado)
        elif inicio == "3":
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
                    print("6. Terminar con la ejecución del cliente")
                    
                    opcion = input("Elige una opción: ")
                    
                    if opcion == "1":
                        # Enviar un correo (implementación futura)
                        print("Funcionalidad de enviar correo aún no implementada")
                    elif opcion == "2":
                        correo = input("Correo del usuario: ")
                        resultado = obtener_informacion(correo)
                        print("Información del usuario:", resultado)                
                    elif opcion == "3":
                        print("Funcionalidad de ver correos favoritos aún no implementada")
                    elif opcion == "4":
                        id_correo_favorito = int(input("ID del correo a marcar como favorito: "))
                        resultado = marcar_correo(correo_u, clave_u, id_correo_favorito)
                        print("Resultado:", resultado) 
                    elif opcion == "5":
                        id_correo_favorito = int(input("ID del correo a desmarcar como favorito: "))
                        resultado = desmarcar_correo(correo_u, clave_u, id_correo_favorito)
                        print("Resultado:", resultado)     
                    elif opcion == "6":
                        break
                    else:
                        print("Opción no válida")
            else:
                print("Usuario no encontrado o contraseña incorrecta")
        elif inicio == "4":
            exit()            
        else:
            print("Opción no válida")
            break

if __name__ == "__main__":
    main()
