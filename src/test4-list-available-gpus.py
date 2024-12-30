import tensorflow as tf
print([f"ID: {i}, Nombre: {tf.config.experimental.get_device_details(gpu).get('device_name', 'Desconocido')}" for i, gpu in enumerate(tf.config.list_physical_devices('GPU'))] or "No se encontraron GPUs disponibles.")
