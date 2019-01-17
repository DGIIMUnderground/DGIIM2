# Tema 4 SO

## Interfaz de los sistemas de archivos

### Definiciones

- Archivo: Colección de información almacenada en un dispositivo de almacenamiento secundario, el usuario puede hacer uso de esta información sin verse involucrado en cómo está almacenadad en el dispositivo de almacenamiento secundario.

### Estructura interna de un archivo

- Secuencia de bytes: El SO transfiere en una operación de lectura o escritura sobre el archivo una subcadena del mismo determinada por los parámetros especificados en la operación.

- Secuencia de registros de longitud fija.

- Secuencia de registros de longitud variable.

### Formas de acceso a un archivo

- Acceso secuencial: Se accede al resgitro siguiente al último accedido.

- Acceso directo: Se especifica a qué parte del archivo se quiere acceder independientemente de lo realizado en operaciones anteriores.

### Tipos de sistemas de archivos

- SA basados en disco: Forma clásica de almacenar archivos en medios no volátiles.

- SA virtuales: Generados por el kernel constituyen una forma simple de comunicación entre programas y usuarios. No requieren espacio de almacenamiento en hardware

- SA de red: Los datos están ubicados en un dispositivo hardware de otro ordenador. Es el otro ordenador el que se encarga de almacenarlos e informar de que los datos han llegado.

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

Cada elemento de un sistema de archivo tiene asociado un inodo.

Dentro de un sistema de archivos, cada inodo tiene un nº distinto, que sirve de identificativo.

El nº de inodo se corresponde con su ubicación secuencial dentro de la lista de inodos.

El contenido de un inodo es:

- Tipo de archivo.

- Propietario.

- Grupo.

- Permisos para 2 categorías : propietario, grupo y otros.

- Tres fechas: Último acceso, última modificación y última modificación de estado.

- Número de enlaces duros al archivo.

- Tamaño del archivo en bytes.

- Número de bloques asociados al archivo, medido en bloques de 512 B.

- Puntero al bloque de datos del fichero.

### Enlaces duros y simbólicos

> Hay que poner las fotos, que aqui no hay nada mas

### Acceso a un archivo

> Hay que poner la foto, es lo unico que hay, aunque no es muy relevante

### Buffer caché

Está situada entre el subsistema de archivos y los bloques en la arquitectura de unix.

Buffer es equivalente a bloque de disco en memoria o copia en memoria de bloque de disco.

Buffer cache o Cache de bufferes: Conjunto de bloques de disco que el kernel mantiene en MP para almacenar los recientemente utilizados.

Bloque alude a bloque lógico o cluster, esto es, un cierto número de bloques físicos consecutivos que se asignan o desasignan como una unidad.

Si un bloque de disco está en memoria solo puede estar en un buffer.

En lectura el kernel comprueba si el bloque aludidio se encuentra en la buffer cache, evitando asi la lectura. En escritura el bloque se mantiene también en un buffer para que no sea necesaria otra lectura si es aludido en el futuro. Así se eliminan accesos a disco.

Un buffer está en estado bloqueado si actualmente se está realizando una operación de E/S sobre él, en caso contrario está en estado libre y es elegible para leer sobre él un nuevo bloque de disco.

El buffer caché mantiene:

- Una lista de buffers bloqueados.

- Una lista de buffers libres con los cuales se pueden satisfacer nuevas asignaciones.

Se aplica el criterio LRU para elegir un buffer a ser reemplazado.

Cuando un proceso deja de usar un buffer este pasa al final de la lista de buffers libres. Cuando se  necesita un buffer para traer a MP un bloque nuevo se toma el primero de la lista.

El tamaño de la buffer caché se determina durante la inicialización del sistema y se cambia para adaptarse a la situación del conjunto de procesos y MP:

- Cuando se solicita un buffer nuevo y no hay buffers libres se solicita un marco de página más para albergar el bloque de disco solicitado.

- Cuando la MP disponible pasa a estar por debajo de un umbral predefinido el kernel puede decidir disminuir el tamaño de buffer caché liberando marcos de  página.

### Cabecera del buffer
