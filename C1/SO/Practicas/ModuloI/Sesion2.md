# Sesión 2. Herramientas de administración del SA

## 3. Partición de dispositivos de almacenamiento secundario

### <u>Actividad 2.1.</u>   Partición de un dispositivo: “USB pen drive” o “memory stick”

**En   esta   actividad   utilizaremos   un   dispositivo   USB   de   tipo   “pen   drive”   para   establecer particiones. Vamos a crear una tabla de particiones en las que se van a definir dos particiones primarias que se configuraran para albergar dos sistemas de archivos tipo linux, de manera que la primera algergará un SA `ext3`  y la segunda un  `ext4`. Ambas serán particiones tipo Linux  `0x83`. El tamaño de las particiones queda a vuestra libre elección pero por lo menos deberían tener 512 MB.**

**Como las particiones que vamos a hacer no van a ser excesivamente grandes vamos a utilizar la herramienta `fdisk`. Esta orden se puede manejar básicamente como un programa guiado por menús para la creación y manipulación de la tabla de particiones. Para poder actuar sobre el *pen drive* necesitamos saber que existe un archivo especial de dispositivo que actua como interfaz para el dispositivo físico (<dispositivo>), por ejemplo, `/dev/sda` representa el dispositivo de almacenamiento   secundario   sobre   el   que   queremos   trabajar.   La  <particion> es un <dispositivo> seguido de un número de partición (comenzando por el 1), p.e. `/dev/sda2`.**

**A continuación vamos a describir cómo llevaremos a  cabo en las aulas el procedimiento para poder realizar la partición de un dispositivo de almacenamiento secundario. Vamos a distinguir dos procedimientos:  partición  de  un  dispositivo  simulado mediante un archivo especial de dispositivo y partición de un *pen drive*.**

En el guión explica como hacerlo tanto con un *pen drive* como mediante un archivo especial de dispositivo. Según la profesora nosotros nos centramos en la última, así que desarrollo sólo esa opción.



##### <u>**Preparación previa a la partición de un dispositivo simulado mediante un archivo especial de dispositivo.**</u>

Indico las órdenes que escribo en la terminal y también las salidas que me dan las órdenes.

**Vamos   a   utilizar   un   dispositivo   simulado   mediante   un   archivo  `/dev/loop?`. Estos   archivos permiten crear un dispositivo de almacenamiento virtual cuyo espacio de almacenamiento viene soportado por un archivo asociado. A continuación se describen los pasos para construir este dispositivo simulado:**

1. **Crea los archivos `/dev/loop0`  y `/dev/loop1`, si no se encuentran en el sistema, utilizando las siguientes órdenes:**

```bash
[root@localhost ~]# mknod /dev/loop0 b 7 0
[root@localhost ~]# mknod /dev/loop1 b 7 1
```
**Ejecutando `ls /dev/loop0` y `ls /dev/loop1` lo más probable es que salten errores porque no existen los archivos, así que se crean mediante las órdenes que dice el guión.**

2. **Crea un archivo de 20 MB y otro de 30 MB en tu sistema de archivos con las siguientes órdenes:**
```bash
[root@localhost ~]# dd if=/dev/zero of=/root/archivo_SA20 bs=2k count=10000 
10000+0 records in
10000+0 records out
20480000 bytes (20 MB) copied, 0.19671 s, 104 MB/s
[root@localhost ~]# dd if=/dev/zero of=/root/archivo_SA30 bs=3k count=10000
10000+0 records in
10000+0 records out
30720000 bytes (31 MB) copied, 0.214606 s, 143 MB/s

```

3. **Ahora vamos a asociar un archivo de dispositivo loop a cada uno de los archivos que acabas de crear. De esta forma el “disco virtual” que representa el archivo pasará a estar asociado al archivo de dispositivo `/dev/loop0` y `/dev/loop1`. Para ello ejecuta las siguientes órdenes:**
```bash
[root@localhost ~]# losetup /dev/loop0 /root/archivo_SA20
[root@localhost ~]# losetup /dev/loop1 /root/archivo_SA30
```

4. **Puedes comprobar la configuración de tus “discos virtuales” mediante la siguiente orden que producirá como salida el siguiente resultado:**
```bash
[root@localhost ~]# fdisk -l /dev/loop0 /dev/loop1

Disk /dev/loop0: 20 MB, 20480000 bytes
255 heads, 63 sectors/track, 2 cylinders, total 40000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/loop0 doesn't contain a valid partition table

Disk /dev/loop1: 30 MB, 30720000 bytes
255 heads, 63 sectors/track, 3 cylinders, total 60000 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/loop1 doesn't contain a valid partition table
```



## 4. Asignación   de   un   Sistema   de   Archivos   a   una   partición (formateo lógico)

### <u>Actividad 2.2.</u> Creación de sistemas de archivos

**El objetivo es simplemente formatear lógicamente las particiones creadas con anterioridad de forma consistente con el tipo de SA que se estableció que iba a ser alojado. En la primera partición crearemos un SA de tipo `ext3`  y en la segunda un `ext4`.**

**La orden que permite establecer un SA de los reconocidos dentro del sistema Linux sobre una partición de disco es `mke2fs`  (consulta el manual en línea para familiarizarte con sus opciones). El resultado de la ejecución de esta orden es el formateo lógico de la partición escogida utilizando el SA que se ha seleccionado.** 

**Utiliza el manual en línea para conocer cómo ejecutar la orden de creación de SA. `mke2fs`  es la orden   genérica   para   creación   de   sistemas   de   archivos.   Como   requisito   es   necesario   que establezcas dos etiquetas de volumen para los SAs:  `LABEL_ext3`  para la primera partición y `LABEL_ext4`  para la segunda. Debería aparecer un listado en pantalla similar al siguiente:**

```bash
[root@localhost ~]# mke2fs -L "LABEL_ext3" -t ext3 /dev/loop0
mke2fs 1.41.12 (17-May-2010)
Filesystem label=LABEL_ext3
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
5016 inodes, 20000 blocks
1000 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=20709376
3 block groups
8192 blocks per group, 8192 fragments per group
1672 inodes per group
Superblock backups stored on blocks: 
	8193

Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 30 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.


[root@localhost ~]# mke2fs -L "LABEL_ext4" -t ext4 /dev/loop1
mke2fs 1.41.12 (17-May-2010)
Filesystem label=LABEL_ext4
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
7520 inodes, 30000 blocks
1500 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=30932992
4 block groups
8192 blocks per group, 8192 fragments per group
1880 inodes per group
Superblock backups stored on blocks: 
	8193, 24577

Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 22 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
```

## 5. Ajuste de parámetros configurables de un SA y comprobación de errores

Quizá en este apartado venga bien decir que la orden que genera el tochaco ese que hay al principio de la sección es `tune2fs -l /dev/loop0`.

### <u>Actividad 2.3.</u> Personalización de los metadatos del SA

**Consultando el manual en línea para la orden `tune2fs` responde a las siguientes preguntas:**

1. **¿Cómo   podrías   conseguir   que   en   el   siguiente   arranque   del   sistema   se   ejecutara automáticamente `e2fsck`  sin que se haya alcanzado el máximo número de montajes?**

   Si buscamos un poco en el manual en línea, encontramos la opción `-C`:

   ```
   -C mount-count
                 Set  the  number  of  times  the  filesystem  has been
                 mounted.  If set to a  greater  value  than  the  max-
                 mount-counts parameter set by the -c option, e2fsck(8)
                 will check the filesystem at the next reboot.
   ```

   Es decir, estableciendo con esa opción un número suficientemente grande (número más grande de veces que el sistema de archivos es montado) en el próximo arranque se ejecutará `e2fsck`.

2. **¿Cómo podrías conseguir reservar para uso exclusivo de un usuario username un número de bloques del sistema de archivos?**

   Ejecutando `tune2fs <sistema de archivos> -r <numero> -u <user>`

```
-r reserved-blocks-count
              Set the number of reserved filesystem blocks.
-u user
              Set the user  who  can  use  the  reserved  filesystem
              blocks.   user  can be a numerical uid or a user name.
              If a user name is given, it is converted to a  numeri‐
              cal uid before it is stored in the superblock.
   
```

## 6. Montaje y desmontaje de Sistemas de Archivos

### <u>Actividad 2.4.</u> Montaje de sistemas de archivos

**Utiliza el manual en línea para descubrir la forma de montar nuestros SAs de manera que cumplas los siguientes requisitos:**

* **El SA etiquetado como `LABEL_ext3`  debe estar montado en el directorio `/mnt/SA_ext3` y en modo de solo lectura.**
* **El SA etiquetado como `LABEL_ext4` debe estar montado en el directorio `/mnt/LABEL_ext4` y debe tener sincronizadas sus operaciones de E/S de modificación de directorios.**

Echándole un ojo al manual de `mount`:

```
-r, --read-only
              Mount the filesystem read-only.  A synonym is -o ro.
              
              
-o, --options opts
              Use the specified mount options. 
FILESYSTEM-INDEPENDENT MOUNT OPTIONS
dirsync
              All directory updates within the filesystem should  be
              done synchronously.  This affects the following system
              calls: creat, link,  unlink,  symlink,  mkdir,  rmdir,
              mknod and rename.
```
Las órdenes a ejecutar son:
```bash
[root@localhost ~]# mkdir /mnt/SA_ext3
[root@localhost ~]# mount -r /dev/loop0 /mnt/SA_ext3
[ 9013.420000] EXT3-fs: barriers not enabled
[ 9013.420000] kjournald starting.  Commit interval 5 seconds
[ 9013.420000] EXT3-fs (loop0): mounted filesystem with writeback data mode

[root@localhost ~]# mkdir /mnt/LABEL_ext4
[root@localhost ~]# mount -o dirsync /dev/loop1 /mnt/LABEL_ext4
[ 9069.160000] EXT4-fs (loop1): mounted filesystem with ordered data mode. Opts: (null)
```

Para el primer caso también se puede ejecutar `mount /dev/loop0 –o ro /mnt/SA_ext3`.

### <u>Actividad 2.5.</u> Automontaje de Sistemas de Archivos

**Escribe las dos líneas necesarias en el archivo `/etc/fstab` para que se monten automáticamente nuestros dos SA en el arranque del sistema con los mismos requisitos que se han pedido en la Actividad 2.4.**

De acuerdo al formato del archivo `/etc/fstab`

```
/dev/loop0 /mnt/SA_ext3 ext3 ro,auto 0 0
/dev/loop1 /mnt/LABEL_ext4 ext4 auto,dirsync 0 0
```