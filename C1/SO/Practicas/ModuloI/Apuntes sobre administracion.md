# Apuntes útiles sobre administración de sistemas linux

* Pequeña lista con los contenidos de la parte 1 de las prácticas de Sistemas Operativos
* Autor: [Sergio Quijano Rey](sergiquijano@gmail.com)

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
	* `chage`: para cambiar los valores de envejecimiento y limites de tiempo

### Grupos

* Se puede consultar el `groupname` y `groupid` en `/etc/group`
* Algunas órdenes para gestionar grupos
	* `groupadd grupo` crea un nuevo grupo
	* `groupmod grupo` modifica un grupo existente
	* `groupdel grupo` elimina un grupo
	* `newgrp grupo` cambia de grupo activo (lanza un shell con ese grupo)
	* `gpasswd grupo` asigna una contraseña a un grupo
	* `gpasswd -a user grupo` añade un usuario a un grupo
	* `groups [usuario]` informa de los grupos a los que pertenece un usuario
	* `id [usuario]` lista el identificador del usuario y los grupos a los que pertenece
	* `grpck` comprueba la consistencia del archivo de grupos
	* `id` muestra id de usuario y de grupo
* Un grupo con `GID` inferior a 500 está preconfigurado por el sistema

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
* `/usr`: ejecutables, codigos fuente, bibliotecas, programas y utilidades
* `/var`: archivos cuyo contenido suele cambiar durante la ejecución del sistema

### Archivos de configuración del sistema

* `/etc/passwd`: cuentas de usuario
	* El formato de este archivo se puede consultar con `man 5 passwd`
* `/etc/group`: información sobre los grupos
* `/etc/shadow`: guarda los usuarios junto a las contraseñas encriptadas y su tiempo de envejecimiento
* `/etc/skel`: archivos de configuración del shell
* `/etc/login.defs`: valores por defecto de envejecimiento y límites de tiempo
* Configuración shell y la sesión de terminal
	* `~/.bash_profile`: se ejecuta al hacer login
	* `~/.bashrc`: se ejecuta cada vez que se ejecuta un shell (al abrir shell, ejecutar un programa...)
		* Suele cargar los contenidos de `.bash_profile` y `.bash_aliases`
	* `~/.bash_logout`: se ejecuta al finalizar la sesión
* `vmlinuz*` es el ejecutable que lanza el kernel del sistema
* Información sobre los puntos de montaje:
	* `/etc/fstab`
		* Es útil para que los montajes se realicen de forma automática
		* Formato: `<filesys> <mountpoint> <type> <options> <dump> <pass>`
			* <filesys>: número que identifica el archivo especial de bloques
			* <mountpoint>: directorio que actúa como punto de montaje
			* <type>: tipo de sistema de archivos
			* <options>: opciones para el proceso de montaje
			* <dump>: no se suele usar, si su valor es distinto de 0 indica la frecuencia con la que se hacen copias de seguridad
			* <pass>: indica el orden en el que se comprueban los estados de los sistemas de archivos
	* `/etc/mtab`
* `/proc/filesystems`: lista los tipos de sistemas de archivos disponibles
* `/proc/mounts`: sistemas de archivos montados actualmente

--------------------------------------------------------------------------------

## Particiones, formateo y montaje de sistemas de archivos

### Particiones y sistemas de archivos 

* `/sbin/sfdisk -T`: muestra los sistemas de archivos soportados y su código numérico
* Particiones primarias
	* Se almacenan el en `Master Boot Record` o `MBR`
	* Solo se soportan 4, por compatibilidad hacia atrás
* Particiones lógicas
	* Son subdivisiones de la partición primaria
* Es común crear una partición primaria con el objetivo de crear tantas particiones lógicas como queramos
	* Se le asigna el formato `extended` que se corresponde con el valor `05`

### Particiones para que un dispositivo sirva de arranque

* Se necesitan obligatoriamente
	* Una partición primaria: en linux se identifica con `/`
	* Al menos una partición `swap`
* A partir de esto, podemos crear tantas particiones lógicas como queramos

### Directorios del estándar `FHS` que pueden tener una partición independiente

* `/`: debe tener una partición primaria, de forma obligatoria
* `/home`: los motivos por los que podemos querer tener una partición única para `/home` son:
	* `/home` almacena los archivos personales de los usuarios
	* Podemos limitar el tamaño que ocupen los archivos de los usuarios del sistema (*método poco flexible*)
	* Podemos formatear el `SO` para cambiarlo preservando los archivos del `/home`
* `/usr`
	* Almacena los ejecutables binarios del sistema
* `/var`
	* Contiene directorios *SPOOL* como dispositivos de impresión
	* Se suele asignar una partición distinta de `/` cuando linux actua como un servidor


### Particiones para un dispositivo secundario

* Se necesita forzosamente:
	* Al menos una partición primaria o secundaria
	* No es necesario crear un `swap`, aunque nos es posible
* A partir de esto podemos crear tantas particiones como queramos

### Esquema del proceso general para crear particiones y formatear un dispositivo

* Lo desmontamos del sistema
* Creamos una nueva tabla de particiones
* Formateamos cada partición creada
* Montamos el dispositivo en nuestra estructura de directorios

### Proceso para crear un UBS o DiscoDuro virtual

~~~bash
# Crea los archivos necesarios si no existen
# La opcion b 7 indica que son dispositivos tipo bloque (USB o disco duro)
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
* Se desmonta el USB con la orden `umount`

### Proceso partición de un USB

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

### Formatear particiones

* Se puede usar la instrucción `mke2fs`
	* mke2fs
* Se puede usar la instrucción `mkfs.label /dev/sdb/partitionnumber`
	* `label` debe ser el nombre del formato a utilizar
	* `partitionnumber` debe ser el número de la partición que hemos indicado con fdisk
		* Se puede saber con `lsblk`
		* Se puede saber con `fdisk -l`
	* Para memoria swap se usa `mkswap`
* Se puede usar la orden `mkfs`
	* Es la más útil según mi experiencia
	* `mkfs -t <type> <dispositivo>`
		* `<type>` es un tipo de archivos soportados por linux
		* `<dispositivo>` es una partición, no un dispositivo entero `/dev/sda1` en lugar de `/dev/sda`
	* Por ejemplo: `mkfs -t ext4 /dev/sda1`

### Ajuste de parámetros configurables

* Aplicable cuando se usan formatos linux (`ext*`)
* Se usa la orden `tune2fs`
	* `tune2fs -l <dispositivo>`: muestra información de los sistemas de archivos del dispositivo
	* `tune2fs -c number <dispisitivo>`: establece el número máximo de montajes que se pueden hacer en el dispositivo sin comprobar consistencia
	* `tune2fs -L label dispositivo`: asigna una etiqueta a un dispositivo

### Montaje/Desmontaje

* `mount` para el montaje
	* `mount -t <ftype> <origen> <destino>`
		* `<ftype>`: tipo de sistema de archivos
		* `<origen>`: ruta del dispositivo especial, normalmente `/dev/sd...`
		* `<destino>`: ruta donde queremos colocar la raíz del dispositivo
	* Por ejemplo, `mount -t ext4 /dev/sda1 /media/USB`
* `umount` para el desmontaje
	* `umount <directoriomontaje>`
	* Por ejemplo, `umount /media/USB`
* Para el automontaje, se escribe una entrada en `/etc/fstab` como ya hemos estudiado

### Reparar inconsistencias

* `fsck`
	* Opera sobre metadatos, no sobre los archivos en si

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
	* Límite soft: una vez se llega al límite, el usario no puede sobrepasarlo
	* Límite hard: se puede superar un límte (*aunque no se puede llegar a otro nivel especificado*) durante un periodo de tiempo conocido como *periodo de gracia*
* Procedimiento para establecer cuotas en un sistema de archivos:
	1. Editar el archivo /etc/fstab y activar el sistema de cuotas de usuario para el SA tipo ext3 (mirar como se hace en el manual)
	2. Montar de nuevo el SA en el espacio de nombres para que se active la opción previamente establecida. `mount -o remount <directorio_punto_de_montaje>`
	3. Crear el archivo que permite llevar el control de cuotas de usuario para el SA. El nombre de este archivo es aquota.user. `quotacheck -nm <directorio_punto_de_montaje>`
	4. Ahora procedemos a activar el sistema de control de cuotas de usuario. `quotaon -a`
	5. Ahora solo falta editar la cuota para cada usuario del sistema mediante la siguiente orden. `edquota username`
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
	* Carga del sistema
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
* `ps`: muestra los procesos en ejecución
	* Se suele lanzar `ps -ef` para mostrar toda la información del sistema
	* `ps aux` tiene el mismo resultado que el comando anterior
* `top`: muestra información sobre los procesos en tiempo real
	* Se pueden enviar señales en tiempo real
	* La versión mejorada de `top` es mucho más útil: `htop`
* `mpstat`: muestra estadísticas de uso de la CPU
	* CPU: identificador del procesador
	* %user: porcentaje de uso a nivel de usuario
	* %nice: porcentaje de uso con tareas nivel de usuario con prioridad nice
	* %sys: porcentaje de uso de la CPU en modo núcleo
	* %iowait: porcentaje de tiempo desocupado de la CPU
	* %irq: porcentade de tiempo gastado con interrupciones hardware
	* %idle: porcentaje de tiempo con CPU desocupada y sin peticiones de disco pendientes
	* intr/s: número de interrupciones por segundo recibidas por el procesador

--------------------------------------------------------------------------------

## Monitorización de la memoria

* `free`: muestra información sobre el uso de memoria principal
	* Análogo a `mpstat` pero con el uso de memoria RAM
	* Es útil ejecutar `watch -d free` para simular de alguna forma el modo interactivo
* `vmstat`: muestra información de memoria masiva, swap, entradas/salidas, cpu
	* `vmstat <periodo> <ejecuciones>`: ejecuta <ejecuciones> cada <periodo> segundos
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
* `df`: para cada sistema de archivos montado muestra información sobre espacio ocupado,
  espacio libre...
	* `df -h`: muestra la información para humanos (unidades)
	* `df -i`: muestra el número de inodos usados y disponibles, en vez de espacio disponible
* `du`: muestra la cantidad de disco usado por los directorios de forma recursiva
	* `du -l`: muestra información para humanos
	* `du -d<num>`: solo profundiza <num> en el sistema de archivos. Con <num> igual a 1
	  obtenemos solo los tamaños del directorio en el que nos encontremos
	* `du -i`: en vez de mostrar tamaño de disco usado, muestra inodos usados
* `mknod`: crea archivos especiales
	* Tipos:	
		* De bloques: representan dispostivos de bloques como USBs o discos duros
		* De carácteres: reprensentan terminales
		* De FIFO: sirve para comunicación entre procesos
	* Para ver información sobre esta utilidad: `mknod --help`

--------------------------------------------------------------------------------

## Creación de enlaces a archivos

* La orden básica es `ln`
	* Dos tipos de enlaces:
		* Enlaces simbólicos: se referencia el nombre del archivo
		* Enlaces duros: se referencian los metadatos del archivo
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
* Demonio `atd`
	* Algunas funcionalidades del demonio
		* `at`: ordenar la ejecución de órdenes a una determinada hora
		* `atq`: consultar la lista de órdenes
		* `atrm`: eliminar órdenes
		* `batch`: ordenar la ejecución de órdenes que se ejecutarán cuando la carga del sistema sea baja.
	* El formato de la orden principal es `at [-q queue] [-f <script>] [-mldbv] TIME`
		* `TIME` indica la hora a la que se va a ejecutar una orden, una única vez. Los
		  posibles valores para `TIME` se pueden consultar con `man at`
	* Algunos ejemplos:
		* `at now + 1 minute -f sript.sh`
	* La salida estándar y la salida de error se envia por correo al usuario con
	  el programa `/usr/bin/sendmail`. Por esto, es conveniente redirigir las salidas
	  o bien a `/dev/null` o a archivos alojados en el sistema de archivos que podamos
	  consultar más tarde, sin tener que haber configurado el envío de emails que
	  es bastante molesto
	* El script que ejecuta el demonio se debe especificar con su ruta absoluta
	  o debe encontrase en los directorios de búsqueda de ejecución, porque el 
	  demonio que lo lanza no va a tener la variable de entorno para saber
	  cual es el directorio actual
	* `/etc/at.deny` y `/etc/at.allow` especifican qué usuarios pueden ejecutar
	  los demonios y qué usuarios no
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
	* Se pueden establecer variables (*pueden ser de entorno como HOME, PATH, o SHELL*) con `<nombre>=<valor>`
	* Este formato se puede consultar en `man 5 crontab`
	* Con la orden `crontab` se puede especificar, crear o listar los archivos para que los lea cron
		* `crontab -l`: muestra el fichero crontab que ejecuta el usuario actual
		* `crontab -r`: elimina le fichero crontab que ejecuta el usuario actual
		* `crontab <file>`: ejecuta <file> como crontab
		* `crontab -e`: edita el fichero crontab
