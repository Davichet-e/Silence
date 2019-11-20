# Cómo montar el entorno

- Abrir una consola en la raíz del repositorio
- Crear un entorno virtual nuevo usando `virtualenv env` (`env` es un nombre estándar que se le suele dar a los entornos virtuales)
  - Si hay instalada más de una versión de Python, especialmente si conviven la 2 y la 3, conviene especificarla usando `virtualenv -p python3 venv`
- Activar el entorno virtual usando `venv\Scripts\activate`. Debería aparecer entonces el nombre del entorno en el prompt.
- Instalar los requisitos usando `pip install -r requirements.txt`
