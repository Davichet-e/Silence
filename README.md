# Silence [![Build Status](https://travis-ci.org/IISSI-US/Silence.svg?branch=master)](https://travis-ci.org/IISSI-US/Silence)

# How to install the virtual environment

- Open a console prompt in the framework's root folder.
- Create a new virtual environment using `virtualenv env` (`env` is a name that is commonly given to Python virtual environments).
  - If you have different versions of Python in your system, especially if Python 2 and 3 are installed alongside each other, it is recommended to specify the Python version using `virtualenv -p python3 env`.
- Activate the virtual environment using `env\Scripts\activate` (Windows) or `source env/bin/activate` (Linux & Mac).
- Install Silence's requirements using `pip install -r requirements.txt`.

# About the Silence framework

Silence was developed by the IISSI1-TI team
(Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
and it is distributed as open source software under the GNU-GPL 3.0 License.
