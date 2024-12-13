# ESIT-IA
Imágenes docker para las asignaturas de IA de la ESIT

### Para actualizar la imagen en Docker hub:
```
$ docker build -t esit-ia:x.y.z .
$ docker tag esit-ia:x.y.z ccesitull/esit-ia:x.y.z
$ docker build -t ccesitull/esit-ia:x.y.z .
$ docker login
$ docker push ccesitull/esit-ia:x.y.z
```

### Creación del contenedor:
```
$ mkdir data
$ docker run -d -it -p 8888:8888 -v $(pwd)/data:/workspace --name esit-ia esit-ia:x.y.z
```
