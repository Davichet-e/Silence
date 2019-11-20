# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from os import listdir
from os.path import dirname, basename

__all__ = [basename(f)[:-3] for f in listdir(dirname(__file__))
           if f.endswith(".py") and not f.endswith("__init__.py")]
