import tensorflow as tf
import sys

print("Python version:", sys.version)
print("TensorFlow version:", tf.__version__)
print("\nGPU devices:")
print(tf.config.list_physical_devices('GPU'))

# Verificar si TensorFlow puede ver la GPU
print("\nTensorFlow built with CUDA:", tf.test.is_built_with_cuda())
print("GPU disponible:", tf.test.is_gpu_available())

# Información adicional sobre la GPU
if tf.config.list_physical_devices('GPU'):
  with tf.device('/GPU:0'):
# Realizar una operación simple para verificar la GPU
     a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
     b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
     c = tf.matmul(a, b)
     print("\nOperación de prueba en GPU exitosa:")
     print(c)

