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

def main():
    print("Bienvenido a CommuniKen")
    while True:
        print("1. Registrar usuario")
        print("2. Bloquear usuario")
        print("3. Obtener información de usuario")
        print("4. Salir")
        opcion = input("Elige una opción: ")
        
        if opcion == "1":
            nombre = input("Nombre: ")
            correo = input("Correo: ")
            clave = input("Clave: ")
            descripcion = input("Descripción: ")
            resultado = registrar_usuario(nombre, correo, clave, descripcion)
            print("Resultado:", resultado)
        elif opcion == "2":
            correo = input("Tu correo: ")
            clave = input("Tu clave: ")
            correo_bloquear = input("Correo del usuario a bloquear: ")
            resultado = bloquear_usuario(correo, clave, correo_bloquear)
            print("Resultado:", resultado)
        elif opcion == "3":
            correo = input("Correo del usuario: ")
            resultado = obtener_informacion(correo)
            print("Información del usuario:", resultado)
        elif opcion == "4":
            break
        else:
            print("Opción no válida")

if __name__ == "__main__":
    main()
