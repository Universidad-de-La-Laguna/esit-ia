# ESIT-IA
Imágenes docker para las asignaturas de IA de la ESIT


El objetivo de este repositorio es ofrecer una imagen Docker que ejecute en local los ejemplos propuestos en el asignatura de Inteligencia Artificial.


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
