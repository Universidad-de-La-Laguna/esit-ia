import keras_cv
from tensorflow import keras
import matplotlib.pyplot as plt

import tensorflow as tf

gpus = tf.config.list_physical_devices('GPU')
if gpus:
# Restrict TensorFlow to only allocate 1GB of memory on the first GPU
  try:
    tf.config.set_logical_device_configuration(gpus[0], [tf.config.LogicalDeviceConfiguration(memory_limit=7024)])
    logical_gpus = tf.config.list_logical_devices('GPU')
    print(len(gpus), "Physical GPUs,", len(logical_gpus), "Logical GPUs")
  except RuntimeError as e:
# Virtual devices must be set before GPUs have been initialized
     print(e)

model = keras_cv.models.StableDiffusion(img_width=25, img_height=25)
prompt = "photograph of a cowboy riding a bike"
images = model.text_to_image(prompt, batch_size=1)

# Mostrar las imágenes generadas
for i, image in enumerate(images):
        plt.imshow(image)
        plt.axis("off")
plt.savefig(f"generated_image_{i}.png")
