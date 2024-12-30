# ESIT-IA
Imágenes docker para las asignaturas de IA de la ESIT

El objetivo de este repositorio es ofrecer una imagen Docker que ejecute en local los ejemplos propuestos en el asignatura de Inteligencia Artificial.


## GPU

Para la ejecuación sobre ordenadores con GPU se debe tener en cuenta.ls

- Tener instalado el driver de la tarjeta. Según el driver instalado se deberá instalar la versión CUDA correspondiente. nvidia-smi
- Tener instalar el paquete nvidia-container-toolkit  
    '''
    apt install nvidia-container-toolkit
    '''
- Configurar el runtime el demonio Docker
'''
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
'''
-  Ejecutar la imagen Docker con la directiva --gpu
'''
 docker run -it --gpus all
 '''

- Usar una imagen de nvidia que sea "devel" y con "cudann". Tener cuidado que sea compatible con el driver instalado en el host
'''
FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04
'''

- Trabajar con versiones fijadas 'pinneadas' de los paquetes 
- Revisar la compatibilidad de las librería cuda, tensorflow. 
   


### Para actualizar la imagen en Docker hub:
```
$ docker build -t esit-ia:x.y.z .
$ docker tag esit-ia:x.y.z ccesitull/esit-ia:x.y.z
$ docker build -t ccesitull/esit-ia:x.y.z .
$ docker login
$ docker push ccesitull/esit-ia:x.y.z
```

### Ejecución del registro local de docker:
```
$ ./run-docker-registry.sh
```
Este script se debe ejecutar al arrancar cada equipo, de tal manera que se 
cree un registro local en cada máquina, que va a actuar como proxy del Docker hub.

### Creación del contenedor:
```
$ mkdir data
$ docker run -d -it -p 8888:8888 -v $(pwd)/data:/workspace --name esit-ia localhost:5000/ccesitull/esit-ia:x.y.z
```
