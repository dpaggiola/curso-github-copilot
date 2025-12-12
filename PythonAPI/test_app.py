import unittest
from app import app

class TestSaludoAPI(unittest.TestCase):
    """Casos de prueba para la API de saludo"""
    
    def setUp(self):
        """Configuración inicial para cada prueba"""
        app.config['TESTING'] = True
        self.client = app.test_client()
    
    def test_saludo_con_parametro(self):
        """Prueba el endpoint /saludo con un parámetro"""
        response = self.client.get('/saludo?texto=mundo')
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['mensaje'], 'hola mundo desde la API de Python')
    
    def test_saludo_sin_parametro(self):
        """Prueba el endpoint /saludo sin parámetro"""
        response = self.client.get('/saludo')
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['mensaje'], 'hola  desde la API de Python')
    
    def test_saludo_con_parametro_vacio(self):
        """Prueba el endpoint /saludo con parámetro vacío"""
        response = self.client.get('/saludo?texto=')
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['mensaje'], 'hola  desde la API de Python')
    
    def test_saludo_con_parametro_especial(self):
        """Prueba el endpoint /saludo con caracteres especiales"""
        response = self.client.get('/saludo?texto=Python%20123')
        
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json['mensaje'], 'hola Python 123 desde la API de Python')
    
    def test_saludo_retorna_json(self):
        """Prueba que el endpoint retorna un JSON válido"""
        response = self.client.get('/saludo?texto=test')
        
        self.assertEqual(response.content_type, 'application/json')
        self.assertIn('mensaje', response.json)

if __name__ == '__main__':
    unittest.main()
