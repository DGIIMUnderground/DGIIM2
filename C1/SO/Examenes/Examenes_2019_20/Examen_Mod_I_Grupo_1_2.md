# Examen SO Módulo I: Administración de Sistemas. Grupos 1 y 2 DGIIM. 2019/20.

## Ejercicio 1. [2.5 puntos]

1. Crea un usuario nuevo en el sistema con la orden `adduser`, con `username=user1` y directorio `home=home-user1`. Al crear el nuevo usuario, ¿se le ha asignado automáticamente un _password_? Muestra el archivo que demuestra si la respuesta es verdadera o falsa, indicando la línea (registro) correspondiente al usuario.Si la respuesta es falsa, indica la orden que utilizas para asignar el _password_ y muestra como queda la línea tras la asignación. Indica cuál es el archivo de configuración en el que se especifican los parámetros de envejecimiento del _password_. Cambia el máximo número de días que puede estar el usuario sin cambiar la contraseña a 7 días. Muestra el cambio en el archivo pertinente.

2. Suponiendo que eres un usuario normal del sistema, ¿sobre qué directorios `<directorios>`, de un sistema de archivos conforme con el FHS realizarías la siguiente orden para poder saber si el sistema dispone de la utilidad `wc`?

```
$ ls -l <directorios> | grep "wc" 
```

3. ¿Qué significan las opciones `defaults` y `noatime`, las cuales se pueden incluir en el campo opciones de `/etc/fstab`? Muestra las opciones tal y como se describe el manual en línea.

_Solución:_

1. Usamos `adduser user1 --home=/home/home-user1`. No se le asigna ninguna contraseña por defecto, para comprobarlo vemos en `/etc/passwd` que el campo de contraseña contiene una `x`, con lo cual la contraseña se encuentra en `/etc/shadow`, ahí buscamos el registro correspondiente a `user1` y vemos que en el campo correspondiente a la contraseña aparece `!!`. Esto significa que no hay contraseña por defecto, pero sin embargo no podremos hacer login sin usar `su`(desde `root`) hasta que le asignemos una contraseña. 

Para asignar una contraseña usamos la orden `passwd user1`, que nos pedirá introducir la contraseña nueva dos veces. Una vez cambiada podemos ver el cambio en `/etc/passwd`, donde aparece la contraseña encriptada. En el msimo archivo de configuración podemos encontrar la información de envejecimiento de la contraseña, concretamente en el quinto campo se indica la máxima edad de validez de la contraseña, en días. Para cambiar este valor a 7 días, usamos `chage -M 7 user1`. Vemos el cambio con `cat /etc/shadow | grep user1`.

2. El directorio en el que se encuentra es `/usr/bin`, pues ahí se encuentran los programas (binarios) específicos a nuestro usuario.

_Truco:_ Si no recordamos bien el directorio, basta con hacer `whereis <programa>` o `which <programa>`.

3. Consultamos el manual: `man mount` (`mount` es el programa que lee `fstab`):
* `defaults`: Use the default options: rw, suid, dev, exec, auto, nouser, and async. Note that the real set of all default mount options depends on kernel and filesystem type.  See the beginning of this section for more details.
* `noatime`: Do not update inode access times on this filesystem (e.g. for faster access on the news spool to speed up news servers). This works for all inode types (directories too), so it implies nodiratime.


## Ejercicio 2. [3 puntos]

1. Crea un archivo especial de dispositivo de bloques `/dev/loop0` con un tamaño de 25 MB tal como se hizo en la sesión 2. Realiza el formato del dispositivo con `fdisk` indicando una única partición y muestra la información de la partición una vez realizado el formato.

2. Crea un sistema de archivos `ext3` en el dispositivo del apartado 1. Copia todos los metadatos de SA que seas capaz de visualizar. Indica los siguientes metadatos en especial:
	* Número de Grupos de Cilindros (o de Bloques).
	* Número de Inodos totales, indodos por grupo de cilindros y tamaño del inodo.
	* Tamaño de bloque, número de bloques libres total y número de bloques libres por grupo de cilindros.

3. Monta el sistema de archivos recién creado en el directorio `/mnt/` con las siguientes opciones: solo lectura y toda la E/S sobre el sistema de archivos debe realizarse de forma síncrona.

_Solución:_

1. Para crear este archivo primero usamos `mknod /dev/loop0 b 7 0`, y después crearemos el otro archivo que vamos a vincular con `/dev/loop0` mediante la orden `dd if=/dev/zero of=/root/archivo_SA_25 bs=1k count=25000`, tardará un tiempo en crear el archivo. Ahora vinculamos el dispositivo `loop0` al archivo con la orden `losetup /dev/loop0 /root/archivo_SA_25`. Ahora ya tenemos todo listo para el ejercicio. 

Usamos `fdisk` para darle una partición al disco. Escribimos `fdisk /dev/loop0`, entramos en el menú de `fdisk` y pulsamos `n` para nueva partición. Dejamos todo por defecto (partición primaria que ocupa todo el dispositivo) y ya está listo. Después de particionar usamos `fdisk -l /dev/loop0` y obvervamos el output:

```
[root@localhost ~]# fdisk -l /dev/loop0 

Disk /dev/loop0: 25 MB, 25600000 bytes
29 heads, 41 sectors/track, 42 cylinders, total 50000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x59223430

      Device Boot      Start         End      Blocks   Id  System
/dev/loop0p1            2048       49999       23976   83  Linux

```

2. Ahora tenemos que crear un sistema de archivos en la partición. Usamos `mke2fs -t ext3 /dev/loop0` para darle un SA de tipo `ext3`. Al crear el sistema de archivos, la propia orden nos ofrece algunos metadatos:

```
[root@localhost ~]# mke2fs -L examen -t ext3 /dev/loop0
mke2fs 1.41.12 (17-May-2010)
Filesystem label=examen
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
6272 inodes, 25000 blocks
1250 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=25690112
4 block groups
8192 blocks per group, 8192 fragments per group
1568 inodes per group
Superblock backups stored on blocks: 
	8193, 24577

Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 24 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
```

Ya con esta información vemos que:

* Hay 25000 bloques o cilindros repartidos en 4 grupos de bloques de 8192 cada uno.
* Hay 6272 inodos en total, con 1568 inodos por grupo. El tamaño del inodo lo comprobamos con la orden `tune2fs -l /dev/loop0`, cuyo output listamos más abajo. Este tamaño es 128 bytes.
* Cada bloque tiene un tamaño de 1024 bytes, para los bloques libres y bloques libres por grupo usamos `tune2fs`. Vemos que hay 22867 bloques libres. **[TO DO: bloques libres por grupo de cilindros]**.

```
[root@localhost ~]# tune2fs -l /dev/loop0 
tune2fs 1.41.12 (17-May-2010)
Filesystem volume name:   examen
Last mounted on:          <not available>
Filesystem UUID:          ec1941a7-027d-4461-b069-e9c450b5e1f3
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype sparse_super
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              6272
Block count:              25000
Reserved block count:     1250
Free blocks:              22867
Free inodes:              6261
First block:              1
Block size:               1024
Fragment size:            1024
Reserved GDT blocks:      97
Blocks per group:         8192
Fragments per group:      8192
Inodes per group:         1568
Inode blocks per group:   196
Filesystem created:       Mon Oct 21 14:36:15 2019
Last mount time:          n/a
Last write time:          Mon Oct 21 14:36:15 2019
Mount count:              0
Maximum mount count:      24
Last checked:             Mon Oct 21 14:36:15 2019
Check interval:           15552000 (6 months)
Next check after:         Sat Apr 18 14:36:15 2020
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          128
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      d92a86ee-f316-461d-9baf-2a4821d97531
Journal backup:           inode blocks
```

3. Consultamos usando `man mount` las opciones necesarias, estás son `-r` para solo lectura y `-o sync` para que las E/S sean manejadas de forma síncrona. También es válida la opción `-o ro,sync`. Ejecutamos:

```
mount /dev/loop -t ext3 -o ro,sync /mnt 
```

## Ejericio 3. [4.5 puntos]
 
1. Indica el significado de los siguientes campos mostrados por la orden `top`: 'us', 'ni' y 'si'. Además indica para un determinado proceso de ejemplo cuáles son las columnas que muestran: el tamaño de la memoria RAM que realmente utiliza el proceso y el tamaño de la memoria que puede compartir con otros procesos. 

2. Indica la orden (y la información que muestra) que podrías utilizar para conseguir saber el uso de memoria del sistema. ¿Qué orden usarías para saber el uso de memoria de un determinado proceso? Muestra la información para un proceso ejemplo. ¿Qué orden usarías para poder saber la memoria _buffered_ y la memoria _cached_ por separado?

3. Crea un _script_ que devuelva exclusivamente la información sobre la cantidad de espacio libre y ocupado tanto de la memoria principal como del espacio de intercambio de tu sistema (Ubuntu).

4. Crea un archivo llamado `log` en tu directorio `home` y consigue que todos los Viernes a las 2 horas y 5 minutos durante los meses de Marzo, Abril y Mayo, se ejecute el guión del apartado anterior y se guarden los resultados en el archivo creado (`log`), de tal forma que se pueda observar la evolución de la memoria. Para verificar que funciona pruébalo especificando "cada minuto".

_Solución:_

1. El significado de los campos lo buscamos en `man top`:
	* us: El porcentaje de tiempo que la `CPU` ha estado ejecutando procesos de usuario.
	* ni: El porcentaje de tiempo que la `CPU` ha estado ejecutando procesos con _niceness_, pero de usuario.
	* si: El porcentaje de tiempo que la `CPU` ha estado ejecutando interrupciones de software.

El tamaño de la memoria RAM (física) que un proceso está usando viene indicado por la columna `RES`, y la memoria que puede compartir con otros procesos se indica en la columna `SHR`. Esta última columna debemos activarla pulsando `f` una vez que hayamos entrado en la interfaz de `top`, y una vez allí seleccionarla para que aparezca.

Para saber la memoria _buffered_ y _cached_ podemos usar `free -w` que separa el campo `buff/cache` en dos campos.

2. Para ver la información de memoria del sistema podemos usar `free` o `vmstat`, el segundo mostrará más información aparte de la memoria. Para saber el uso de memoria de un proceso usamos `ps -p<PID> -o pmem,vsz,rss` el campo de `%MEM` indica el porcentaje de memoria usado respecto al total, el campo `VSZ` muestra el tamaño de la memoria virtual y `RSS` el tamaó de la memoria física no instercambiada (_not-swapped_).

3. Este script sería como sigue:

```bash
#!/bin/bash
free | awk '/total/{ print "\t" $2 "\t" $3} /Mem:|Swap:/{ print $1 "\t" $3 "\t" $4}'
```

Esta orden primero toma la salida de `free`, y se queda con los campos 'used' y 'free' de la primera fila, y con los correspondientes valores de las filas 'Mem:' y 'Swap:'. Hemos tenido que usar `awk` de esta forma porque los campos (columnas) que produce `free` no están bien alineados. Esto se puede comprobar con `free | awk {print $1}` que se ve que imprime incorrectamente. 

La salida queda:
```
	    used	free
Mem:	4057948	831332
Swap:	492	1358468
```

4. Primero creamos el archivo con `touch log`. La línea que añadimos en `/etc/crontab` es:
```
5  2  *  mar-may fri root /root/scriptmemoria.sh >> /root/log
```

para probarlo, usamos la siguiente línea:
```
* * * * * root /root/scriptmemoria.sh >> /root/log
```
podemos comprobar el funcionamiento con `cat log`.


-----
Autor: Alejandro Villanueva Prados
