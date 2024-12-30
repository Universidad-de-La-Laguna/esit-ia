import keras_cv
from tensorflow import keras
import matplotlib.pyplot as plt

import tensorflow as tf

model = keras_cv.models.StableDiffusion(img_width=512, img_height=512)
prompt = "photograph of a cowboy riding a bike"
images = model.text_to_image(prompt, batch_size=1)

# Mostrar las imágenes generadas
for i, image in enumerate(images):
        plt.imshow(image)
        plt.axis("off")
plt.savefig(f"generated_image_{i}.png")
