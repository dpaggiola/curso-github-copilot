from flask import Flask, request
from flasgger import Swagger

app = Flask(__name__)
swagger = Swagger(app)

@app.route('/saludo', methods=['GET'])
def saludo():
    """
    Saludo concatenado
    ---
    parameters:
      - name: texto
        in: query
        type: string
        required: false
        description: Cadena de entrada a concatenar
    responses:
      200:
        description: Mensaje concatenado exitosamente
        schema:
          properties:
            mensaje:
              type: string
              example: "hola mundo desde la API de Python"
    """
    # Obtener el parámetro de entrada desde la query string
    entrada = request.args.get('texto', '')
    
    # Concatenar las cadenas
    resultado = f"hola {entrada} desde la API de Python"
    
    return {'mensaje': resultado}

if __name__ == '__main__':
    app.run(debug=True, port=5000)
