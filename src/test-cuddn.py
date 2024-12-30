import ctypes
try:
  ctypes.CDLL('libcudnn.so')
  print("cuDNN está instalado correctamente.")
except OSError:
  print("No se pudo encontrar cuDNN.")

