---
author: Sergio Quijano Rey
title: Apuntes sobre administración de Sistemas
date: 15/12/2018
---

# Apuntes útiles sobre administración de sistemas linux

--------------------------------------------------------------------------------

## Órdenes útiles

* `watch`: ejecuta un programa de forma periódica y muestra los resultados en pantalla completa
	* `-n sec`: se ejecuta cada `sec` segundos, por defecto 2 segundos
	* `-d`: muestra diferencias entre ejecuciones consecutivas
	* La ejecución en pantalla completa se parece a la ejecución de htop, se 
	  limpia y escribe en pantalla en vez de caer en cascada las salidas del programa
* `lsblk`: muestra los dispositivos conectados al sistema
	* `lsblk -f` muestra toda la información como punto de montaje, etiqueta, tipo de sistema de archivos

--------------------------------------------------------------------------------

## Administración de usuarios 

* Modo superusuario
	* Se accede con `su`
	* Su carpeta `home` es `root`
* Cambiar de un usuario a otro desde la terminal
	* `su - <username>`: pide la contraseña y se loggea
	* `su -`: para acceder al usuario root
* Listar todos los usuarios del sistema:
	* `awk -F: '{ print $1 }' /etc/passwd`
* Es útil saber usar `awk` o `sed` para tomar información de los archivos del sistema

### Usuarios

* Se pueden consultar su `UID` y `GID` en `/etc/pwd`
* Los grupos suplementarios en `/etc/group`
* Para crear usuarios
	* `useradd`
		* Ejecutando `useradd` sin parámetros se nos muestra en pantalla
		  todas las opciones que soporta
		* Toma los valores por defecto de los archivos:
			* `/etc/default/useradd`
			* `/etc/login.defs`
			* `/etc/skel`
		* Los valores por defecto se pueden consultar con `useradd -D`
	* `adduser`: es exactamente lo mismo que `useradd`
* Para modificar parámetros de los usuarios
	* `usermod`: modifica una cuenta ya existente
		* `usermod`: sin parametros muestra información sobre los flags que se le pasa
		* `usermod --home <newhome>`: establece la `home` a la ruta especificada.
		  No se borra la anterior `home`
		* `usermod --home <newhome> --move-home`: hace lo mismo que el anterior
		  comando pero moviendo los contenidos de la `home` a la nueva localización
		* `usermod -e <date>`: la fecha de expiración es `<date>`
		* `usermod -g <val>`: el grupo primario se establece a `<gid>`
		* `usermod -G <groups>`: la lista de grupos suplementarios se establece
		  a la dada por `<groups>`
		* `usermod -a <group>`: añade el usuario al grupo como suplementario
	* `userdel`: elimina una cuenta, por defecto no borra su `home`
		* `userdel <username>`: borra el usuario, no borra su `home`
		* `userdel -i <username>`: borra el usuario y su `home`
	* `newusers`: crea una nueva cuenta, o varias cuentas en batch, a través de un archivo de texto con formato `/etc/passwd` o 
	   tomando los datos de la entrada estandar
	   	* El formato de `passwd` se puede ver con `man 5 passwd`
	* `system-config-users`: herramienta en modo gráfico
		* No tengo ni idea de como se utiliza
	* `passwd` para cambiar la contraseña de un usuario
		* `passwd <user>`: saca un prompt para cambiar la contraseña de `<user>`
		* Sin parámetros cambia la contraseña del usuario actual
	* `chage`: para cambiar los valores de envejecimiento y limites de tiempo
		* `chage`: sin parámetros muestra las opciones

### Grupos

* Se puede consultar el `groupname` y `groupid` en `/etc/group`
* Algunas órdenes para gestionar grupos (**todas ellas sin parámetros muestran sus opciones**)
	* `groupadd grupo` crea un nuevo grupo
	* `groupmod grupo` modifica un grupo existente
	* `groupdel grupo` elimina un grupo
	* `newgrp grupo` cambia de grupo activo (lanza un shell con ese grupo)
	* `gpasswd grupo` asigna una contraseña a un grupo
	* `gpasswd -OPTION user grupo` modifica la situación entre grupo-usuario
		* `gpasswd -a <user> <gropu>`: añade `<user>` a `<group>`
		* `gpasswd -d <user> <gropu>`: quita `<user>` de `<group>`
	* `groups [usuario]` informa de los grupos a los que pertenece un usuario
	* `id [usuario]` lista el identificador del usuario y los grupos a los que pertenece
	* `grpck` comprueba la consistencia del archivo de grupos
	* `id` muestra id de usuario y de grupo
* Un grupo con `GID` inferior a 500 está preconfigurado por el sistema
* El root tiene `uid`, `gid` y `gropus` con valor 0

--------------------------------------------------------------------------------

## Archivos de configuración del sistema

### Directorios importantes de linux

* `/bin`: programas de utilidad para cualquier usuario
* `/sbin`: programas para utilizar por el root
* `/boot`: para el boot loader
* `/dev`: archivos especiales de dispositivo
* `/etc`: archivos de configuración del sistema
* `/home`: directorio donde se guardan los `home's` de los usuarios
* `/lib`: bibliotecas para que funcionen los programas de `bin` y `sbin`
* `/media`: punto de montaje para dispositivos extraíbles
* `/mnt`: punto de montaje para sistemas de archivos temporales
* `/opt`: programas que no forman parte de la distribución instalada del sistema
* `/proc`: archivos virtuales que hacen de interfaz entre procesos y núcleo
* `/tmp`: archivos temporales, se suelen borrar al apagar el sistema
* `/usr`: ejecutables, códigos fuente, bibliotecas, programas y utilidades
* `/var`: archivos cuyo contenido suele cambiar durante la ejecución del sistema

### Archivos de configuración del sistema

* `/etc/passwd`: cuentas de usuario
	* El formato de este archivo se puede consultar con `man 5 passwd`
* `/etc/group`: información sobre los grupos
* `/etc/shadow`: guarda los usuarios junto a las contraseñas encriptadas y su tiempo de envejecimiento
	* Guarda varios hasheos de las contraseñas
	* Guarda la última fecha de cambio de contraseña
	* Guarda datos sobre envejecimiento como;
		* Mínimo tiempo para poder cambiar la contraseña
		* Máximo tiempo sin cambiar la contraseña
		* Cuándo se va a avisar del usuario para que cambie la contaseña
* `/etc/skel`: archivos de configuración del shell
* `/etc/login.defs`: valores por defecto de envejecimiento y límites de tiempo
* Configuración shell y la sesión de terminal
	* `~/.bash_profile`: se ejecuta al hacer login
	* `~/.bashrc`: se ejecuta cada vez que se ejecuta un shell (al abrir shell, ejecutar un programa...)
		* Suele cargar los contenidos de `.bash_profile` y `.bash_aliases`
	* `~/.bash_logout`: se ejecuta al finalizar la sesión
* `/etc/shells`: shells instaladas y disponibles para lanzar por los usuarios del sistema
* `vmlinuz*` es el ejecutable que lanza el kernel del sistema
* Información sobre los puntos de montaje:
	* `/etc/fstab`: muestra los puntos de montaje que se realizan en el *booteo* del sistema
		* Es útil para que los montajes se realicen de forma automática
		* El formato se puede consultar con `man fstab`
		* Formato: `<filesys> <mountpoint> <type> <options> <dump> <pass>`
			* <filesys>: número que identifica el archivo especial de bloques
			* <mountpoint>: directorio que actúa como punto de montaje
			* <type>: tipo de sistema de archivos
			* <options>: opciones para el proceso de montaje: se pueden consultar con `man fstab` y `man 8 mount`
			* <dump>: no se suele usar, si su valor es distinto de 0 indica la frecuencia con la que se hacen copias de seguridad
			* <pass>: indica el orden en el que se comprueban los estados de los sistemas de archivos
	* `/etc/mtab`: muestra los puntos de montaje **actuales** del sistema
		* Tiene exactamente el mismo formato que `/etc/fstab`
		* Si un disco está conectado pero no montado, no aparece en este archivo
* `/proc/filesystems`: lista los tipos de sistemas de archivos disponibles en el sistema
* `/proc/mounts`: sistemas de archivos montados actualmente, mismo formato que `/proc/mounts`

--------------------------------------------------------------------------------

## Particiones, formateo y montaje de sistemas de archivos

### Particiones y sistemas de archivos 

* `/sbin/sfdisk -T`: muestra los sistemas de archivos soportados y su código numérico
* Particiones primarias
	* Se almacenan el en `Master Boot Record` o `MBR`
	* Solo se soportan 4, por compatibilidad hacia atrás
* Particiones lógicas
	* Son subdivisiones de una partición primaria
	* Una partición primaria puede tener más de 4 particiones lógicas
* Es común crear una partición primaria con el objetivo de crear tantas particiones lógicas como queramos
	* Se le asigna el formato `extended` que se corresponde con el valor `05`
* Sobre los nombres de dispositivos en linux:
	* Los dispositivos se identifican con `/dev/<algo>` donde algo suele ser:
		* `sd<letra`>
	* Por ejemplo, `/dev/sda`, `/dev/sdb`
	* Las particiones del dispositivo se identifican con el nombre del dispositivo
	  seguido del número de la partición.
	* Por ejemplo, si `/dev/sda` tiene tres particiones, aparecerán como:
		* `/dev/sda1`
		* `/dev/sda2`
		* `/dev/sda3`

### Particiones para que un dispositivo sirva de arranque

* Se necesitan obligatoriamente
	* Una partición primaria: en linux se identifica con `/`
	* Al menos una partición `swap`
* A partir de esto, podemos crear tantas particiones primarias y lógicas como queramos

### Particiones para un dispositivo secundario

* Se necesita forzosamente:
	* Al menos una partición primaria o secundaria
	* No es necesario crear un `swap`, aunque nos es posible
* A partir de esto podemos crear tantas particiones como queramos

### Directorios del estándar `FHS` que pueden tener una partición independiente

* `FHS` es el estándar de la organización linux para un sistema de archivos.
* Se puede consultar el estándar con `man hier`
* `/`: debe tener una partición primaria, de forma obligatoria
* `/home`: los motivos por los que podemos querer tener una partición única para `/home` son:
	* `/home` almacena los archivos personales de los usuarios
	* Podemos limitar el tamaño que ocupen los archivos de los usuarios del sistema (*método poco flexible*)
	* Podemos formatear el `SO` para cambiarlo preservando los archivos del `/home`
* `/usr`
	* Almacena los ejecutables binarios del sistema
* `/var`
	* Contiene directorios *SPOOL* como dispositivos de impresión
	* Se suele asignar una partición distinta de `/` cuando linux actúa como un servidor



### Esquema del proceso general para crear particiones y formatear un dispositivo

* Lo desmontamos del sistema
* Creamos una nueva tabla de particiones con `fdisk` o `gparted`
* Formateamos cada partición creada con `mkfs`
* Montamos el dispositivo en nuestra estructura de directorios con `mount`

### Proceso para crear un UBS o DiscoDuro virtual

~~~bash
# Crea los archivos necesarios si no existen
# La opcion b 7 indica que son dispositivos tipo bloque (USB o disco duro)
# Estas dos instrucciones no hacen falta si ya existen /dev/loop0 /dev/loop1
mknod /dev/loop0 b 7 0
mknod /dev/loop1 b 7 1

# Crea un archivo de 20MB y otro de 30MB
dd if=/dev/zero of=/root/archivo_SA20 bs=2k count=10000
dd if=/dev/zero of=/root/archivo_SA30 bs=3k count=10000

# Asocio los dispositivos tipo bloque con los archivos creados
losetup /dev/loop0 /root/archivo_SA20
losetup /dev/loop1 /root/archivo_SA30

# Compruebo la configuración de los discos virtuales
fdisk -l /dev/loop0 /dev/loop1
~~~

### Proceso Preparación previa para particionar un USB

* Se introduce el USB
* Se puede ver que archivo y directorio especial se le ha asignado en `/proc/mount`
* Se puede ver que ha aparecido un nuevo dispositivo con `lsblk`
* Se desmonta el USB con la orden `umount`

### Proceso de crear la tabla de particiones

* Se crean las particiones con la orden fdisk
	* `fdisk -l` lista las particiones que haya en el sistema, de todos los dispositivos conectados
	* `fdisk /dev/sda`: para entrar a editar la tabla de particiones en modo comando
		* `m`: muestra ayuda
		* `p`: muestra la tabla de particiones actual
		* `d`: elimina una partición de la tabla: pide el numero de la partición
		* `n`: añade una partición: se pide introducir `l` o `p` para logica o primaria
		* `t`: especifica un número para una partición
		* `w`: guarda los cambios
		* `q`: sale sin guardar los cambios

### Proceso de dar formato a las particiones creadas

* Se debe haber creado la tabla de particiones con `fdisk`
* Se puede usar la instrucción `mke2fs`
	* Solo sirve para formatear con `ext`
	* Por tanto, no es muy recomendable
* Se puede usar la instrucción `mkfs.label /dev/sdb/partitionnumber`
	* `label` debe ser el nombre del formato a utilizar
	* `partitionnumber` debe ser el número de la partición que hemos indicado con fdisk
		* Se puede saber con `lsblk`
		* Se puede saber con `fdisk -l`
	* No suele funcionar, no tiene soporte
* Se puede usar la orden `mkfs`, **opción que a mi me funciona**:
	* `mkfs -t <type> <dispositivo>`
		* `<type>` es un tipo de archivos soportados por linux
		* `<dispositivo>` es una partición, no un dispositivo entero `/dev/sda1` en lugar de `/dev/sda`
	* Por ejemplo: `mkfs -t ext4 /dev/sda1` (*no hay ningún motivo para usar ext2 o ext3 frente a ext4*)
* Para dar formato `swap` se usa `mkswap`

### Ajuste de parámetros configurables

* Aplicable cuando se usan formatos linux (`ext*`)
* Se usa la orden `tune2fs`
	* `tune2fs -l <dispositivo>`: muestra información de los sistemas de archivos del dispositivo
	* `tune2fs -c number <dispisitivo>`: establece el número máximo de montajes que se pueden hacer en el dispositivo sin comprobar consistencia
	* `tune2fs -L label dispositivo`: asigna una etiqueta a un dispositivo o partición

### Montaje/Desmontaje

* `mount` para el montaje
	* Sin parámetros muestra los puntos de montaje cargados en el sistema
	* Modos de uso:
		* `mount -t <ftype> <device> <destino>`
			* `<ftype>`: tipo de sistema de archivos
			* `<device>`: ruta del dispositivo especial, normalmente `/dev/sd...`
			* `<destino>`: ruta donde queremos colocar la raíz del dispositivo
		* `mount <device>`:
			* Se busca en `/etc/fstab` un punto de montaje libre
			* No es recomendable hacer esto
		* `mount <device> <mountpoint>`
			* Es la opción que más se usa
			* Monta el dispositivo en el punto de montaje especificado
		* `mount -l <label> <mountpoint>`:
			* Se usa una etiqueta en vez del nombre del dispositivo
			* Se puede utilizar con todas las combinaciones en las que intervenga `<device>`
		* `mount -a`:
			* Monta todos los dispositvios especificados en `/etc/fstab`
		* `mount <device> <mountpoint> -o <options>`
			* Se tienen en cuenta las opciones a la hora de realizar el montaje
			* Las opciones siguen el mismo formato que en `/etc/fstab`
			* Las opciones se pueden consultar con `man fstab` y `man 8 mount`
		* `mount -r <device> <mountpoint>`
			* Realiza el montaje en modo lectura únicamente
		* `mount -w <device> <mountpoint>`
			* Realiza el montaje en modo lectura y escritura
	* Por ejemplo, `mount -t ext4 /dev/sda1 /media/USB`
	* Por ejemplo, `mount /dev/sda1 /media/USB`
* `umount` para el desmontaje
	* `umount <directoriomontaje>`
	* `umount <dispositivo>`
	* Por ejemplo, `umount /media/USB` o `umount /dev/sda1`
	* Si el dispositivo esta `busy` y aún así queremos desmontarlo usamos 
	  `umount -f <directorio>`
* Para el automontaje, se escribe una entrada en `/etc/fstab` como ya hemos estudiado

### Reparar inconsistencias

* `fsck`
	* Opera sobre metadatos, no sobre los archivos en si
	* Modos de ejecución:
		* `fsck -A`: comprueba todos los sistemas de archivos de `/etc/fstab`
		* `fsck <dispositivo>`: comprueba el dispositivio especificado
		* `fsck -r <dispositivo>`: comprueba el dispositivo y muestra otras estadísticas
	* Existe el programa `e2fsck` que actúa igual que `fsck` pero solo para
	  sistemas de archivos con formato `ext`

--------------------------------------------------------------------------------

## Administración del Software

### Uso de YUM

* YUM es un gestor de paquetes para `.rpm`
* Órdenes básicas de YUM
	* `yum list`: Lista los paquetes disponibles en los repositorios para su instalación
	* `yum list installed`: Lista los paquetes actualmente instalados
	* `yum list updates`: Muestra todos los paquetes con actualizaciones disponibles en los repositorios para su instalación
	* `yum install <nombre-paquete>`: Instala el paquete cuyo nombre es especificado
	* `yum update`: Se actualizan todos los paquetes instalados
	* `yum remove <nombre-paquete>`: Elimina el paquete cuyo nombre es especificado, así como los paquetes que dependen de éste
	* `yum --help`: lista las opciones de ayuda

### Uso de RPM

* Análogo a `dpkg` existe `rpm`
* Algunas órdenes básicas:
	* `rpm -i paquete`: instala paquete
	* `rpm -e paquete`: elimina paquete
	* `rpm -U paquete`: actualiza el paquete
	* `rpm -F <nombre-servidor/FTP>`
	* `rpm -qa | grep <partenombre> | sort`: busca un paquete instalado cuyo nombre coincida en parte con partenombre
	* `rpm -qi nombrepaquete`: muestra información sobre el paquete instalado especificado
	* `rpm -V nombre`: busca un paquete recientemente instalado. Si se instaló correctamente, no produce salida

--------------------------------------------------------------------------------

## Administración de cuotas

* Sirve para limitar el uso del sistema de archivos a un usuario, de forma más flexible que usando particiones del `/home`
* Se necesita tener instalado el paquete `quota`
* Tipos de límite
	* Límite hard: una vez se llega al límite, el usuario no puede sobrepasarlo
	* Límite soft: se puede superar un límite (*aunque no se puede llegar a otro nivel especificado*) durante un periodo de tiempo conocido como *periodo de gracia*
* Procedimiento para establecer cuotas en un sistema de archivos:
	1. Editar el archivo /etc/fstab y activar el sistema de cuotas de usuario para el SA tipo ext3 
		* En las opciones del `/etc/fstab` debe aparecer `usrquota,grpquota`
	2. Montar de nuevo el SA en el espacio de nombres para que se active la opción previamente establecida. `mount -o remount <directorio_punto_de_montaje>`
	3. Crear el archivo que permite llevar el control de cuotas de usuario para el SA. El nombre de este archivo es aquota.user. `quotacheck -nm <directorio_punto_de_montaje>`
		* A mi me funciona con `quotacheck -acug <puntodemontaje>`
		* Después, `quotacheck -avug`
	4. Ahora procedemos a activar el sistema de control de cuotas de usuario. `quotaon -a`
	5. Ahora solo falta editar la cuota para cada usuario del sistema mediante la siguiente orden. `edquota username`
		* Podemos editar quotas para grupos con `edquota -g <groupname>`
	6. Para finalizar estableceremos el periodo de gracia para el límite soft. `edquota -t`
* Otras órdenes útiles:
	* `quota username`: asignación de las cuotas para un usuario.
	* `repquota <SA>`: estadística de las cuotas para todos los usuarios .
		
--------------------------------------------------------------------------------

## Monitorización de la CPU

* `uptime`: muestra información del sistema
	* Hora actual
	* Usuarios conectados
	* Tiempo que lleva en marcha el sistema
	* Carga del sistema en los últimos 1, 5 y 15 minutos
	* Opciones
		* `uptime -p`: muestra cuanto tiempo lleva el sistema encendido
* `w`: muestra los usuarios conectados y la carga que generan
* `time`: mide el tiempo de ejecución de un programa y muestra recursos consumidos
	* Tiempo total del programa (real)
	* Tiempo ejecutándose en modo usuario (user)
	* Tiempo ejecutándose en modo kernel (sys)
* `nice`: lanza un proceso con una prioridad dada
	* Se da un rango [-20, 19]
	* Valores más altos indican una prioridad menor
	* Para asignar prioridades negativas hay que estar en modo root
* `renice`: modifica el valor de prioridad de un proceso que se está ejecutando
* `pstree`: visualiza el árbol de procesos en ejecución
	* Sería interesante conocer los flags del comando
	* No son muchas las opciones, por lo que se puede consultar cómodamente con `man`
* `ps`: muestra los procesos en ejecución
	* Sin argumentos muestra los procesos lanzados por el usuario
	* Se suele lanzar `ps -ef` para mostrar toda la información del sistema
	* `ps aux` tiene el mismo resultado que el comando anterior
	* Para buscar un proceso es útil lanzar `ps aux | egrep <proceso>`
* `top`: muestra información sobre los procesos en tiempo real
	* Se pueden enviar señales en tiempo real
	* La versión mejorada de `top` es mucho más útil: `htop`
	* Comandos
		* `r`: se introduce un proceso para cambiarle el parámetro `nice`
		* `k`: mandar una señal (*kill*)
		* `n`: cambiar el número de procesos que se muestran
		* `q`: para salir
		* Ordenamiento:
			* `N` por pid
			* `P` por uso de CPU
			* `A` por tiempo
* `mpstat`: muestra estadísticas de uso de la CPU
	* Campos que se muestran
		* CPU: identificador del procesador
		* %user: porcentaje de uso a nivel de usuario
		* %nice: porcentaje de uso con tareas nivel de usuario con prioridad nice
		* %sys: porcentaje de uso de la CPU en modo núcleo
		* %iowait: porcentaje de tiempo desocupado de la CPU
		* %irq: porcentade de tiempo gastado con interrupciones hardware
		* %idle: porcentaje de tiempo con CPU desocupada y sin peticiones de disco pendientes
		* intr/s: número de interrupciones por segundo recibidas por el procesador
	* Modos de ejecución
		* `mpstat <intervalo> <numero>`: ejecuta un número `<numero>` de muestras cada `<intervalo>` segundos,
		  al final se muestra la media de los datos

--------------------------------------------------------------------------------

## Monitorización de la memoria

* `free`: muestra información sobre el uso de memoria principal, únicamente esto
	* Análogo a `mpstat` pero con el uso de memoria RAM
	* Es útil ejecutar `watch -d free` para simular de alguna forma el modo interactivo
	* Opciones:
		* `free -h`: muestra la información en modo humano
		* `free -l`: muestra toda la información (*low*, *high memory*).
		  Low es para el kernel (un tercio de la RAM), High es para el usuario (los otros dos tercios)
* `vmstat`: muestra información de memoria masiva, swap, procesos, entradas/salidas, cpu
	* `vmstat <periodo> <ejecuciones>`: ejecuta `<ejecuciones>` cada `<periodo>` segundos
	* Su primera salida suele mostrar las estadísticas desde el inicio del sistema hasta
	  la ejecución del comando
	* La columna `r` muestra los procesos que están en colas de ejecución
	* La columna `wa` muestra los procesos en espacio de intercambio
	* La columna `so` muestra si se está incrementando el espacio de intercambio
	* La columna `free` muestra el espacio de memoria principal disponible
	* En la columna CPU:
		* La columna `us` muestra programas y peticiones de usuarios
		* La columna `sy` se muestran tareas del sistema (entradas/salidas, actualizaciones de estadísticas...)
		* La columna `id` se muestra cuando no se hace nada en absoluto
	
--------------------------------------------------------------------------------

## Gestión de dispositivos Entrada/Salida

* `ls`: la orden más básica para la consulta de metadatos
	* Sería conveniente conocer todos los flags de esta orden
	* Los flags mostrados en `man` no son muchos, no hace falta estudiarlos
	* Flags para mostrar la salida con cierto orden
		* `ls -X`: Ordena alfabéticamente
		* `ls -t`: Ordena por última modificación
		* `ls -u`: Ordena por último tiempo de acceso
		* `ls -c`: Ordena por última modificación incluyendo metadatos 
	* Flags de metadatos
		* `ls -l`: formato largo, muestra los metadatos
		* `ls -n`: como `ls -l` y adicionalmente muestra usuarios y grupos de forma numérica
		* `ls -a`: muestra entradas ocultas
		* `ls -A`: muestra entradas ocultas excepto `.` y `..`
		* `ls -i`: muestra el inodo de cada archivo
		* `ls -h`: se muestra el formato humano
	* Otros flags
		* `ls -R`: hace el listado de forma recursiva por los subdirectorios
		* `ls -B`: no muestra backups (los backups acaban con el caracter `~`)
		* `ls -d`: lista los directorios y no sus contenidos
		* `ls -g`: como `ls -l` pero sin listar el propietario
		* `ls -L`: muestra los metadatos del archivo linkeado en vez de los del link
		* `ls -Q`: pone los nombres entre comillas dobles
* `df`: para cada sistema de archivos montado muestra información sobre espacio ocupado,
  espacio libre...
	* `df -h`: muestra la información para humanos (unidades)
	* `df -i`: muestra el número de inodos usados y disponibles, en vez de espacio disponible
	* Sirve para sistemas de archivos por completo, no para directorios
* `du`: muestra la cantidad de disco usado por los directorios de forma recursiva
	* Hay que tener en cuenta que la última linea muestra la cantidad total de todo el subárbol
	* Hay que tener en cuenta la fragmentación interna de los bloques de archivos
	* Opciones
		* `du -h`: muestra la información con formato para humanos
		* `du -l`: para trabajar con los enlaces duros
		* `du -a`: muestra el espacio también de los archivos, no solamente de los directorios
		* `du -d<profundidad>`: solo aplica recursividad a la profundidad especificada 
			* Con valor 0, muestra el tamaño del directorio especificado `du -h -d0`
			* Con valor 1, solo muestra el primer nivel del directorio especificado
		* `du -i`: en vez de mostrar tamaño de disco usado, muestra inodos usados
		* `du -B<blocksize>` muestra la cantidad de `<blocksize>` que hay en el directorio
			* Se especifica con un número y unidad, `du -B12KB`
			* Por defecto es 1024bytes
* `mknod`: crea archivos especiales
	* Tipos:	
		* De bloques: representan dispostivos de bloques como USBs o discos duros
		* De carácteres: reprensentan terminales
		* De FIFO: sirve para comunicación entre procesos
	* Para ver información sobre esta utilidad: `mknod --help`
	* Podemos especificar en número principal *major* y el número secundario *minor*
		* *Major* especifica el controlador al que está conectado el dispostivo
		* *Minor* especifica el dispositivo en si
		* Estos valores depende de la distribución en la que nos encontremos,
		  hay que consultar el convenio actual
	* Formas de lanzar la orden
		* `mknod <path> <type> <major> <minor>`
			* Crea el archivo especificado por `<path>`
			* `<type>` puede ser `c`, `b` o `p` para caracteres, bloques, fifo (*pipe*)
		* `mknod <path> p`
			* Crea un FIFO
			* No hace falta dar los dos números
	* Para obtener los números principales: `cat /proc/devices`
	* Para elegir un número secundario, hay que escoger uno que no esté siendo
	  utilizado por otros dispositivos con el mismo número principal

--------------------------------------------------------------------------------

## Creación de enlaces a archivos

* La orden básica es `ln`
	* Dos tipos de enlaces:
		* Enlaces simbólicos: se referencia el nombre del archivo
		* Enlaces duros: se referencian los metadatos del archivo
	* Todos los archivos tienen un enlace duro desde el nombre de archivo a su inodo
	* Todos los directorios tienen dos enlaces duros, uno a `.` que representa
	  al directorio y otro a `..` en sus hijos, que lo representan como nodo padre
	* Formas de invocar `ln`
		* `ln archivo_original archivo_enlace`: crea un enlace duro
		* `ln -s archivo_original archivo_enlace`: crea un enlace simbólico

--------------------------------------------------------------------------------

## Demonios

* Características de un demonio
	* No están asociados a un terminal o proceso login
	* Se ejecutan en background
	* Suelen tener asociado un mecanismo para que en caso de que finalice de 
	  forma imprevista se relancen
	* Pueden ser servidores, en cuyo caso, están a la espera de que ocurra
	  cierto evento. En otro caso, ejecutan una utilidad de forma periódica
* **Importante sobre demonios**:
	* Con instalar los demonios estos no van a funcionar solos, hay que invocarlos
	* Esto se suele hacer con `service` o `systemctl` (*esta última a mi me funciona mejor, es la más moderna*)
	* Proceso:
		* `systemctl start crond`: se inicia crond
		* `systemctl status crond`: para ver si está en funcionamiento
		* `systemctl enable crond`: si queréis un demonio de verdad en vuestro
		  ordenador, esto hace que se inicie solo al encender el equipo
	* Este proceso es el mismo que con `service`, cambiando el orden `orden-servicio` por `servicio-orden`
	* En general, el demonio se llama igual que el programa, con una `d` al final
	* No es lo mismo el demonio que el programa que ejecuta o los programas a
	  los que accedemos para configurar su funcionamiento
* Demonio `atd`
	* Algunas funcionalidades del demonio
		* `at`: ordenar la ejecución de órdenes a una determinada hora
		* `atq`: consultar la lista de órdenes
		* `atrm`: eliminar órdenes
		* `batch`: ordenar la ejecución de órdenes que se ejecutarán cuando la carga del sistema sea baja.
	* El formato de la orden principal es `at [-q queue] [-f <script>] [-mldbv] TIME`
		* `TIME` indica la hora a la que se va a ejecutar una orden, una única vez. Los
		  posibles valores para `TIME` se pueden consultar con `man at`
		* También se puede consultar en `/usr/share/doc/at/timespec`
		* Por ejemplo, `at -t -f scritp.sh`
	* Algunos ejemplos:
		* `at now + 1 minute -f sript.sh`
	* La salida estándar y la salida de error se envía por correo al usuario con
	  el programa `/usr/bin/sendmail`. Por esto, es conveniente redirigir las salidas
	  o bien a `/dev/null` o a archivos alojados en el sistema de archivos que podamos
	  consultar más tarde, sin tener que haber configurado el envío de emails que
	  es bastante molesto
	  	* Estos archivos han de ser especificados con rutas absolutas
	* El script que ejecuta el demonio se debe especificar con su ruta absoluta
	  o debe encontrase en los directorios de búsqueda de ejecución, porque el 
	  demonio que lo lanza no va a tener la variable de entorno para saber
	  cual es el directorio actual
	* `/etc/at.deny` y `/etc/at.allow` especifican qué usuarios pueden ejecutar
	  los demonios y qué usuarios no
	* Si no se especifican rutas absolutas en los archivos donde redirigimos, no se crean
	  estos archivos
	* Si invocamos scripts sin especificar rutas absolutas, puede que no se 
	  ejecute el script (solo podemos usar relativas cuando usemos `at -f <file>`)
* Demonio `cron`:
	* Sirve para lanzar scripts de forma periódica
	* `cron.allow` y `cron.deny` especifican los usuarios que pueden ejecutar el demonio, y aquellos que no
	* Existe un archivo `crontab` en el que se especifican los comandos a lanzar
	* El formato del archivo es: `minuto hora día-del-mes mes día-de-la-semana orden`
	* Cada uno de estos campos puede contener:
		* Un asterisco, que indica cualquier valor posible
		* Un número entero, que activa ese valor determinado
		* Dos enteros separados por un guión, que indican un rango de valores
		* Una serie de enteros o rangos separados por una coma, activando cualquier valor de los que aparecen en la lista.
		* Se hace un `AND` de los campos menos para el `dia-mes` y `dia-semana`, en los que se hace un `OR`
	* Se pueden establecer variables (*pueden ser de entorno como HOME, PATH, o SHELL*) con `<nombre>=<valor>`
		* Las variables `HOME` `LOGNAME` se toman de `/etc/passwd`
		* `SHELL` se establece a `/bin/sh`
		* **No funciona la sustitución de variables**
	* Este formato se puede consultar en `man 5 crontab`
	* Con la orden `crontab` se puede especificar, crear o listar los archivos para que los lea cron
		* `crontab -l`: muestra el contenido el fichero crontab que ejecuta el usuario actual
		* `crontab -r`: elimina le fichero crontab que ejecuta el usuario actual
		* `crontab <file>`: ejecuta <file> como crontab
		* `crontab -e`: edita el fichero crontab, si usamos el anterior
		  comando para cambiar de fichero crontab, edita este último
	* Opciones para ejecutar cron
		* `cron -p`: se admite que cualquier usuario utilice `crontab`
		* `cron -P`: el valor de `PATH` se toma de las variables de entorno

--------------------------------------------------------------------------------

## Notas sobre Docker

* Docker emplea tecnología de contenedores, es mucho más eficiente que usar `UML`
  pues no se duplican aquellos recursos innecesarios. Es más cómodo de usar.
* `UML` solo sirve para lo que hacemos en las prácticas. Docker sirve para esto y
  además es fundamental a la hora de crear programas que dependen de forma crítica
  del sistema en el que corra. Por ejemplo, un programa en `C` escrito con llamadas
  al sistema UNIX no va a funcionar en Windows. Con docker podemos hacer que funcione
  donde sea
* Funcionamiento para hacer las prácticas:
	* Lo primero es instalar docker
		* `sudo pacman -S docker`
		* `sudo apt install docker.io`
	* Activar el demonio para docker
		* `sudo systemctl enable docker`
		* `sudo systemctl start docker`
	* Ahora, usar docker
		* `sudo docker run -it fedora:latest bash`
		* `-it`: indica que se use la terminal en modo interactivo
		* Luego se pone `distribucion:version`
		* Luego el comando a ejecutar, en este caso queremos tener acceso
		  a una sesión de terminal
	* Con esto el funcionamiento es idéntico al uso del `UML`
* Para cosas más avanzadas, se puede aprender a escribir ficheros `Dockerfile` que
  permiten hacer muchas cosas
