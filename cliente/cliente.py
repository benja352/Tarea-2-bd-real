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
        print("1. Registrar usuario")
        print("2. Bloquear usuario")
        print("3. Obtener información de usuario")
        print("4. Marcar correo como favorito")
        print("5. Desmarcar correo como favorito")
        print("6. Salir")
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
            correo = input("Correo del usuario: ")
            resultado = obtener_informacion(correo)
            print("Información del usuario:", resultado)
        elif inicio == "4":
            correo = input("Tu correo: ")
            clave = input("Tu clave: ")
            id_correo_favorito = int(input("ID del correo a marcar como favorito: "))
            resultado = marcar_correo(correo, clave, id_correo_favorito)
            print("Resultado:", resultado)
        elif inicio == "5":
            correo = input("Tu correo: ")
            clave = input("Tu clave: ")
            id_correo_favorito = int(input("ID del correo a desmarcar como favorito: "))
            resultado = desmarcar_correo(correo, clave, id_correo_favorito)
            print("Resultado:", resultado)
        elif inicio == "6":
            break
        else:
            print("Opción no válida")

if __name__ == "__main__":
    main()

