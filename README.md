# ESIT-IA

El objetivo de este repositorio es ofrecer una imagen Docker que permita ejecutar en local los ejemplos propuestos en el asignatura de Inteligencia Artificial y pudiera hacer uso de las GPU del ordenador.

El ejemplo  parte de un notebook inicial de Kaggle https://www.kaggle.com/code/patriciogarciabaez/rnas-preentrenadas

La replica del entorno Kaggle a un entorno local conlleva muchas dificultades. Como primera estrategia se plantea copiar exactamente las versiones de python y paquetes, esto no fue posible ya que había muchas dependencias no resolubles entre paquetes. El notebook Kaggle está "anclado" a un entorno original con fecha 2023-07-10, el Dockerfile asociado es https://github.com/Kaggle/docker-python/blob/main/Dockerfile.tmpl y fue construido "build" con referencia a paquetes como "last". Parece que las imágenes construidas están disponible en https://console.cloud.google.com/artifacts/docker/kaggle-images/us/gcr.io/python?inv=1&invt=AbmS8A


Como estrategia se decide crear un fichero Dockerfile que contruya una imagen Docker con todas las dependencias necesarias.
El contenedor está disponible en DockerHub https://hub.docker.com/r/ccesitull/esit-ia

Puede visualizar los notebooks en el directorio src


### Ejecución del contenedor sin GPUs

Ejecute el comando y acceda a http://localhost:8888

```
docker run -d -it -p 8888:8888 -v $(pwd)/data:/workspace --name esit-ia ccesitull/esit-ia:0.0.6
```

### Ejecución del contenedor con GPUs

Ejecute el comando y acceda a http://localhost:8888

```
docker run -d -it --gpus all -p 8888:8888 -v $(pwd)/data:/workspace --name esit-ia ccesitull/esit-ia:0.0.6
```

### Para construir la imagen en local

Si desea construir la imagen envés de descargarla use el siguiente comando

```
git clone https://github.com/Universidad-de-La-Laguna/esit-ia.git
docker build -t ejemplo-esit-ia .
```

## Configuración de la GPU

Este apartado está orientado para los adminstradores del ordenadores.  Para la ejecuación sobre ordenadores con GPU se debe tener en cuenta.ls

- Instalar el driver de la tarjeta. Según el driver instalado se deberá instalar la versión CUDA correspondiente. Con el comando nvidia-smi puede consultar la tarjeta, driver, version de CUDA soportada.

```
 nvidia-smi 
Wed Jan  8 12:49:56 2025       
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.171.04             Driver Version: 535.171.04   CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 3060        Off | 00000000:01:00.0 Off |                  N/A |
|  0%   44C    P8              18W / 170W |     68MiB / 12288MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A      8931      G   /usr/lib/xorg/Xorg                           56MiB |
|    0   N/A  N/A      8961      G   /usr/bin/gnome-shell                          6MiB |
+---------------------------------------------------------------------------------------+

```

- Instalar el paquete nvidia-container-toolkit  que permite a un contenedor Docker usar la GPUs
  La instalación se hace mediante el comando

```
apt install nvidia-container-toolkit
```

- Configurar el runtime el demonio Docker. En el CC además añadimos un registro local de proxy

```
cat /etc/docker/daemon.json 
{
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  },
  "registry-mirrors": ["http://localhost:5000"],
  "insecure-registries": ["localhost:5000"]
}
```

- Como imagen base del fichero Dockerfile se usa la imangen propuesta por Nvidia. Importante que sea "devel" y con "cudann". Tener cuidado que sea compatible con el driver instalado en el host


```
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04
```

- Como norma general trabajar con versiones fijadas 'pinneadas' de los paquetes  y revisar la compatibilidad de las librería cuda, tensorflow. 
   
