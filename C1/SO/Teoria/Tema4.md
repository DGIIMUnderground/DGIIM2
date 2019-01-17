# Tema 4 SO

> Por Mapachana

## Interfaz de los sistemas de archivos

### Definiciones

- Archivo.

### Estructura interna de un archivo

- Secuencia de bytes.

- Secuencia de registros de longitud fija.

- Secuencia de registros de longitud variable.

### Formas de acceso a un archivo

- Acceso secuencial.

- Acceso directo.

### Tipos de sistemas de archivos

- SA basados en disco.

- SA virtuales.

- SA de red.

### Responsabilidades básicas de la gestión de archivos del SO.

- Tener conocimiento de todos los archivos del sistema.

- Controlar la compartición y protección de archivos.

- Gestionar el espacio del sistema de archivos.

- Traducir las direcciones lógicas del archivo en físicas del disco.

- Realizar un tratamiento homogéneo de los distintos tipos de archivos que existen.

- Realizar un tratamiento homogéneo de archivos y dispositivos de E/S.

### Reflexión general sobre implementación

Debe asegurarse:

- Buena relación tamaño de metadatos frente a tamaño de archivo.

- No demasiado espacio ocupado en la gestión de espacio libre.

- Permitir las ventajas de asignación no contigua.

- Una alta velocidad de acceso.

## Diseño del sistema de archivos

### Estructura general del software de E/S

> Hay que añadir las imágenes, no hay otra cosa en esta sección

### Métodos de asignación de espacio

- Asignación contigua : Cada archivo se almacena en un conjunto de bloques consecutivos.

  - Datos almacenados sobre el archivo: nº bloque comienzo y tamaño en bytes.

  - Ventajas:

    - Sencilla de implementar.

    - Buen comportamiento en tiempo en acceso secuencial y acceso directo.

  - Inconvenientes:

    - Genera fragmentación externa.

    - Difícil solución al cambio de tamaño del archivo.

  - Traducción dirección física a lógica: DL nº byte y NB tamaño de bloque.

    - bloque a acceder = nºbloque comienzo + (DL/NB)

    - Desplazamiento = DL%NB

- Lista enlazada de bloques: El archivo se almacena en una lista de bloques, es decir, cada bloque reserva un espcaio para almacenar la dirección del siguiente.

- Tabla FAT: Se reserva una sección del disco al comienzo del disco para la tabla FAT, que contiene una entrada por cada bloque de disco.

- Indexación a 1 nivel: Se utiliza un bloque de disco para almacenar todas las direcciones de bloques que ocupa un archivo; este bloque se llama bloque índice.

- Variante UNIX: Usa todo lo anterior mezclado.  

### Gestión del espacio libre

- La FAT no necesita ningún método.

- El sistema mantiene una lista de los bloques que están libres, llamada lista de espacio libre. La lista de espacio libre tiene diferentes implementaciones:

  - Mapa o vector de bits: Cada bloque se representa con un bit (0 libre y 1 ocupado).

  - Lista enlazada: Enlaza todos los bloques libres de disco, guarda un puntero al primer bloque en un lugar concreto.

  - Lista enlazada con agrupación: Cada bloque de la lista almacena n-1 direcciones de bloques libres.

  - Cuenta: Cada entrada de la lista tiene una dirección de bloque libre y un contador del nº de bloques libres que le siguen.

### Implementación de directorios

Contenido de una entrada de directorio:

- En MS-DOS: Nombre de archivo + atributos + dirección de los bloques de datos.

- Nombre de archivo + puntero a una estructura de datos que contiene toda la información del archivo.

- Unix : nº inodo + nombre de archivo.

Cuando se abre un archivo:

- El SO busca en su directorio la entrada correspondiente.

- Extrae sus atributos y la locaclización de sus bloques de datos y los coloca en una tabla en MP.

- Cualquier referencia posterior usa la información de dicha tabla.

Implementación de enlace:

- Enlace simbólico: Se crea una nueva entrada en el directorio, se indica que es de tipo enlace y se almacena el camino absoluto o relativo del archivo al cual se enlaza.

- Enlaces hard: Se crea una nueva entrada en el directorio y se copia la dirección de la estructura de datos con la información del archivo.

## Generalidades sobre la gestión de archivos en unix

### Relación entre particiones y sistemas de archivos

Un sistema de archivos es una secuencia de bloques lógicos con una estructura:

- Bloque de arranque: Puede contener código de arranque para inicializar el SO.

- Superbloque: Estado y características del sistema de archivos.

- Lista de i-nodos: Secuencia de todos los inodos reservados para ese SA (tiene tamaño fijo).

- Bloques de datos.

### Información contenida en el superbloque

- Tamaño del sistema de archivos.

- Número de bloques libres en el SA.

- Una lista de punteros a bloques libres y un puntero al siguiente bloque libre de la lista de bloques libres.

- Tamaño de inodo.

- Tamaño de la lista de i-nodos.

- nº del inodo inicial.

- Número de i-nodos libres en el sistema.

- Una lista de i-nodos libres y un índice al siguiente i-nodo libre de la lista de i-nodos libres.

Además, cuando este superbloque está en memoria tiene asociado:

- Flag indicando si la lista de bloques libres está bloqueada.

- Flag indicando si la lista de inodos libres está bloqueada.

- Flag indicando si el superbloque ha sido modificado (copia en disco no actualizada).

### Sobre los inodos


