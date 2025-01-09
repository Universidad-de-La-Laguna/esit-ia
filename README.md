# ESIT-IA

El objetivo de este repositorio es ofrecer una imagen Docker que permita ejecutar en local los ejemplos propuestos en el asignatura de Inteligencia Artificial y pudiera hacer uso de las GPU del ordenador.

Como estrategia se decide crear un fichero Dockerfile que contruya una imagen Docker con todas las dependencias necesarias.

El contenedor está disponible en DockerHub https://hub.docker.com/r/ccesitull/esit-ia


Puede visualizar los notebooks en el directorio src https://github.com/Universidad-de-La-Laguna/esit-ia/tree/main/src


Como buena práctica se aconseja dividir los ejemplos en varios notebooks que disminuya la dependencia entre ellos


## Ejecuión en los ordenadores en el CC

Para poder ejecutar ejecutar los comandos docker como alumno o profesor debe primeramente 

```
docker-rootless.sh 
```

En el caso del Centro de Cálculo de la ESIT lo ordenadores con GPUs disponible se encuentran en la sala 1.2.


### Ejecución del contenedor sin GPUs

Ejecute el comando y acceda a http://localhost:8888 o a http://localhost:8888/lab

```
cd  datos/Disco_Duro_Virtual/home/
git clone https://github.com/Universidad-de-La-Laguna/esit-ia.git
docker run -d -it -p 8888:8888 -v $(pwd):/workspace --name esit-ia ccesitull/esit-ia:0.0.6
```

### Ejecución del contenedor con GPUs

Ejecute el comando y acceda a http://localhost:8888 o a http://localhost:8888/lab

```
docker run -d -it --gpus all -p 8888:8888 -v $(pwd):/workspace --name esit-ia ccesitull/esit-ia:0.0.6
```

### Para construir la imagen en local

Si desea construir la imagen envés de descargarla use el siguiente comando

```
git clone https://github.com/Universidad-de-La-Laguna/esit-ia.git
cd esit-ia
docker build -t ejemplo-esit-ia .
```



## Configuración de la GPU

Este apartado está orientado para los adminstradores del ordenadores. 

Para la ejecuación sobre ordenadores con GPU se debe tener en cuenta:

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

- En modo Docker Rootless se debe configurar  el fichero /etc/nvidia-container-runtime/config.toml  mediante

```
nvidia-ctk config --set nvidia-container-cli.no-cgroups --in-place
```

según https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

```
cat /etc/nvidia-container-runtime/config.toml
#accept-nvidia-visible-devices-as-volume-mounts = false
#accept-nvidia-visible-devices-envvar-when-unprivileged = true
disable-require = false
supported-driver-capabilities = "compat32,compute,display,graphics,ngx,utility,video"
#swarm-resource = "DOCKER_RESOURCE_GPU"

[nvidia-container-cli]
#debug = "/var/log/nvidia-container-toolkit.log"
environment = []
#ldcache = "/etc/ld.so.cache"
ldconfig = "@/sbin/ldconfig.real"
load-kmods = true
no-cgroups = true
#path = "/usr/bin/nvidia-container-cli"
#root = "/run/nvidia/driver"
#user = "root:video"

[nvidia-container-runtime]
#debug = "/var/log/nvidia-container-runtime.log"
log-level = "info"
mode = "auto"
runtimes = ["docker-runc", "runc", "crun"]

[nvidia-container-runtime.modes]

[nvidia-container-runtime.modes.cdi]
annotation-prefixes = ["cdi.k8s.io/"]
default-kind = "nvidia.com/gpu"
spec-dirs = ["/etc/cdi", "/var/run/cdi"]

[nvidia-container-runtime.modes.csv]
mount-spec-path = "/etc/nvidia-container-runtime/host-files-for-container.d"

[nvidia-container-runtime-hook]
path = "nvidia-container-runtime-hook"
skip-mode-detection = false

[nvidia-ctk]
path = "nvidia-ctk"
```

- Como imagen base del fichero Dockerfile se usa la imangen propuesta por Nvidia. Importante que sea "devel" y con "cudann". Tener cuidado que sea compatible con el driver instalado en el host


```
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04
```

- Como norma general trabajar con versiones fijadas 'pinneadas' de los paquetes  y revisar la compatibilidad de las librería cuda, tensorflow. 

- Al final de cada notebook se añade el comando 

```
!pkill -9 -f ipykernel_launcher 
``` 

para matar el proceso de kernel de Jupyter y liberar la memoria ocupada por los modelos en la GPUs. 
Queda pendiente hacer la liberación de memoria de una manera más elegante



## Antecedentes

El ejemplo  parte de un notebook inicial de Kaggle https://www.kaggle.com/code/patriciogarciabaez/rnas-preentrenadas

La replica del entorno Kaggle a un entorno local conlleva muchas dificultades. Como primera estrategia se plantea copiar exactamente las versiones de python y paquetes, esto no fue posible ya que había muchas dependencias no resolubles entre paquetes. El notebook Kaggle está "anclado" a un entorno original con fecha 2023-07-10, el Dockerfile asociado es https://github.com/Kaggle/docker-python/blob/main/Dockerfile.tmpl y fue construido "build" con referencia a paquetes como "last". Parece que las imágenes construidas están disponible en https://console.cloud.google.com/artifacts/docker/kaggle-images/us/gcr.io/python?inv=1&invt=AbmS8A


