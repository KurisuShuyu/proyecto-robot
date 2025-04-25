import os
import sys
import subprocess

# Verificar e instalar dependencias automáticamente
def instalar_dependencias():
    try:
        import googleapiclient
        import google.auth
        import pandas
        import openpyxl
    except ImportError:
        print("Instalando dependencias necesarias...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--upgrade", "pip"])
        subprocess.check_call([sys.executable, "-m", "pip", "install", "google-api-python-client", "google-auth", "pandas", "openpyxl"])

# Llamar a la función de instalación de dependencias
instalar_dependencias()

# Importar módulos después de la instalación
from googleapiclient.discovery import build
from google.oauth2.service_account import Credentials
import pandas as pd

# Configuración del bot
SERVICE_ACCOUNT_FILE = 'service-account-file.json'
CALENDAR_ID = 'your_calendar_id@group.calendar.google.com'
EXCEL_FILE = 'reporte_tickets.xlsx'

# Función principal del bot
def ejecutar_bot():
    try:
        # Autenticación con Google Calendar API
        creds = Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=["https://www.googleapis.com/auth/calendar.readonly"])
        service = build('calendar', 'v3', credentials=creds)

        # Obtener eventos del calendario
        print("Obteniendo eventos del calendario...")
        events_result = service.events().list(calendarId=CALENDAR_ID, timeMin=pd.Timestamp.now().isoformat() + 'Z').execute()
        events = events_result.get('items', [])

        if not events:
            print("No se encontraron eventos.")
            return

        # Procesar eventos
        data = []
        for event in events:
            start = event.get('start', {}).get('dateTime', event.get('start', {}).get('date'))
            title = event.get('summary', 'Sin título')
            attendees = event.get('attendees', [])
            emails = [attendee['email'] for attendee in attendees if '@kbeli.cl' in attendee.get('email', '')]
            ticket_number = title.split('-')[-1] if '-' in title else 'N/A'
            duration = 1  # Suponiendo duración de 1 hora por evento (ajustar según necesidad)

            data.append({
                'Fecha': start,
                'Número de Ticket': ticket_number,
                'Duración (horas)': duration,
                'Participantes': ', '.join(emails),
                'Título': title
            })

        # Generar archivo Excel
        print("Generando archivo Excel...")
        df = pd.DataFrame(data)
        df.to_excel(EXCEL_FILE, index=False)
        print(f"Archivo Excel generado: {EXCEL_FILE}")

    except Exception as e:
        print(f"Ocurrió un error: {e}")

# Ejecutar el bot
if __name__ == "__main__":
    ejecutar_bot()
