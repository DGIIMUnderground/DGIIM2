#!/bin/bash
# Autor:
# 	Sergio Quijano Rey
# 	sergiquijano@gmail.com
# Descripcion:
# 	Ejercicio 3 del examen del Modulo I

# La orden time <proceso> nos da información básica para calcular los tiempos de 
# la fórmula
time find /

# Para obtener informacion sobre colas de preparados y cola de bloqueados
# podemos ejecutar la orden a estudiar y a la vez la orden mpstat fijandonos en
# las columnas %user %sys para ver el tiempo que pasa la cpu en modo usuario y kernel
# y la %irq para el tiempo gastado con interrupciones hardware y la columna %idle para
# el tiempo que pasa desocupada. Todo esto no lo hacemos sobre un proceso en concreto,
# sino sobre todo el sistema, luego mpstat nos da pistas de lo que ocurre, no la información
# concreta. Ejecuto mpstat 20 veces cada segundo
mpstat 1 20

# Con la orden ps también podemos obtener información relevante en los campos
# time. Para obtener el ppid lanzamos la primera orden, luego con el ppid lanzamos
# la segunda
ps aux | egrep find /
ps -l ppid

# Con todo esto, la orden clave es vmstat. Una vez lanzada, nos podemos fijar en
# las columnas r: numero de procesos en la cola de ejecucion, b: numero de procesos
# interrumpidos, asi como otros campos con us: tiempo ejecutando codigo usuario,
# sy: tiempo ejecutando el kernel, id: tiempo ocioso, wa: tiempo esperando a entradas/salidas
# Esta orden al igual que mpstat actua sobre todo el sistema, luego habria que ejecutar
# la orden antes de lanzar el proceso y observar como el proceso afecta al sistema,
# pero esta vez la informacion es mucho más precisa, y sumado a todas las observaciones
# anteriores nos daran la informacion buscada
vmstat 1 20

# Resultado de la ejecucion, antes de lanzar find / y durante la ejecucion
sergioquijano@ei142140:~$ vmstat 1 20
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
sergioquijano@ei142140:~$ vmstat 1 20
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd  libre búfer caché   si   so    bi    bo   in   cs us sy id wa st
 1  0  25024 348056  60512 716100    1   15   610  1312  277 1674 23  5 69  3  0
 0  0  25024 348072  60512 716100    0    0     0     0  138  522  3  1 96  0  0
 0  0  25024 346996  60512 716100    0    0     0     0  349 5419 54 17 29  0  0
 0  0  25024 347012  60512 716100    0    0     0     0  168 1105  5  2 93  0  0
 0  0  25024 346100  60512 716076   28    0    28     0  205 1507 16  8 35 40  0
 0  0  25024 343756  60860 716176    0    0   388     0  364 14777 28 12 57  3  0
 3  1  25024 340656  64488 716192    0    0  3640     0  940 27529 52 29 11  8  0
 1  1  25024 334160  70520 716168    0    0  6032     0 1285 22396 39 30  0 31  0
 0  1  25024 328952  74632 716148    0    0  4112     0 1019 28410 38 28  2 31  0
 3  0  25024 324356  78156 716200    0    0  3532     0  923 20627 40 24  6 31  0
 0  1  25024 320264  81412 716180    0    0  3260     0  964 21630 46 23  8 24  0
 3  1  25024 315488  85236 716180    0    0  3824     0 1051 24867 47 25  8 19  0
 1  0  25024 310652  89152 716152    0    0  3916     0 1050 20961 39 25  0 35  0
 4  1  25024 306120  93180 716140    0    0  4028     0 1372 15674 52 20  6 22  0
 5  1  25024 300676  95228 716188    0    0  2048     0  954 11615 59 32  2  7  0
 2  0  25024 300204  96880 716156    0    0  1656     0  843 5848 65 31  2  2  0
 4  1  25024 293008  99952 716188    0    0  3072     0  826 12104 62 21  5 12  0
 0  0  25024 286364 103740 716164    0    0  3788     0 1046 13338 52 20  3 25  0
 2  0  25024 279260 106420 716168    0    0  2688     0  772 20491 49 20 24  6  0
 0  0  25024 270840 110620 716180    0    0  4200     0 1322 24571 37 27 30  6  0
 r  b   swpd  libre búfer caché   si   so    bi    bo   in   cs us sy id wa st
 1  0  25024 348056  60512 716100    1   15   610  1312  277 1674 23  5 69  3  0
 0  0  25024 348072  60512 716100    0    0     0     0  138  522  3  1 96  0  0
 0  0  25024 346996  60512 716100    0    0     0     0  349 5419 54 17 29  0  0
 0  0  25024 347012  60512 716100    0    0     0     0  168 1105  5  2 93  0  0
 0  0  25024 346100  60512 716076   28    0    28     0  205 1507 16  8 35 40  0
 0  0  25024 343756  60860 716176    0    0   388     0  364 14777 28 12 57  3  0
 3  1  25024 340656  64488 716192    0    0  3640     0  940 27529 52 29 11  8  0
 1  1  25024 334160  70520 716168    0    0  6032     0 1285 22396 39 30  0 31  0
 0  1  25024 328952  74632 716148    0    0  4112     0 1019 28410 38 28  2 31  0
 3  0  25024 324356  78156 716200    0    0  3532     0  923 20627 40 24  6 31  0
 0  1  25024 320264  81412 716180    0    0  3260     0  964 21630 46 23  8 24  0
 3  1  25024 315488  85236 716180    0    0  3824     0 1051 24867 47 25  8 19  0
 1  0  25024 310652  89152 716152    0    0  3916     0 1050 20961 39 25  0 35  0
 4  1  25024 306120  93180 716140    0    0  4028     0 1372 15674 52 20  6 22  0
 5  1  25024 300676  95228 716188    0    0  2048     0  954 11615 59 32  2  7  0
 2  0  25024 300204  96880 716156    0    0  1656     0  843 5848 65 31  2  2  0
 4  1  25024 293008  99952 716188    0    0  3072     0  826 12104 62 21  5 12  0
 0  0  25024 286364 103740 716164    0    0  3788     0 1046 13338 52 20  3 25  0
 2  0  25024 279260 106420 716168    0    0  2688     0  772 20491 49 20 24  6  0
 0  0  25024 270840 110620 716180    0    0  4200     0 1322 24571 37 27 30  6  0

# Se puede observar como impacta la orden find a partir de la linea 44 de este 
# archivo, y con ello determinar la respuesta a la pregunta, dependiendo de de la orden
# que lancemos. En nuestro caso, la cola de ejecucion bloqueados no se ve muy afectada 
# por la orden find, luego estos tiempos son insignificantes a la hora de tenerlos 
# en cuenta al ejecutar la orden time
 
