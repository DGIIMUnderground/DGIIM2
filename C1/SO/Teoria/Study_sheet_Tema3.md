# Tema 3

<!---
Esta vez es un poco diferente. No sé exactamente qué estilo va a tener, pero cualquier 
cosa será mejor que la presentación que tenemos 
Así se ponen los comentarios en markdown BTW. Al estilo HTML
-->

## Notas que dijo al final del tema

Consideraciones sobre la elección del proceso víctima:

- Que esté bloqueado; en igualdad, el que espere eventos + lentos
- Que libere suficiente memoria principal para albergar otro
- El que tenga menor prioridad
- Considerar el que lleva en MP
- Considerar si se ha ejecutado desde que llegó a MP

Consideraciones sobre el proceso a carga en memoria principal:

- Tiempo en disco
- Prioridad
- Satisfacción del requisito del tiempo mínimo de estancia en disco

---

## Notas y problemas sobre diferentes implementaciones

Problemas de la **paginación**:

- Problema de eficiencia: se producen 2 accesos a memoria
- Problema de consumo de espacio: para solventarlo, se utiliza paginación multinivel

Problemas de la **segmentación pura**: 

- No se usa en sistemas reales. Produce fragmentación externa por almacenarse en memoria de forma contigua
- Dificultad para crear los mapas de memoria virtual

Segmentación paginada

- Arregla los problemas de las anteriores

## Políticas

Posibilidades:
    - Asignación fija y sustitución local
    - Asignación variable y sustitución local
    - Asignación variable y sustitución global

### Políticas de sustitución

- Algoritmo óptimo:
    - Se sustituye la página que no será usada o será usada más tardía
    - Problema: se necesita saber la cadena con antelación
- Algoritmo FIFO:
    - La que lleva más tiempo se saca; se saca por orden cronológico de llegada
    - Problemas:
        - La que lleva más tiempo podría usarse con mucha frecuencia
        - Anomalía de Belady: *más marcos $\nRightarrow$ menos faltas de página*
- Algoritmo LRU (*Least Recently Used*)
    - La página que se debe reemplazar es la que no se ha referenciado desde hace más tiempo

### Políticas de asignación

Necesitamos saber cuántas páginas asignamos a los diferentes procesos. Esto se puede hacer de forma estática o dinámica (aignación **fija** o **dinámica**)

#### Asignación fija

##### Asignación por igual

Sea $m$ el número de marcos existentes, $n$ el número de procesos. Entoces, se tiene que a cada proceso se le asignan $m/n$ marcos

##### Asignación proporcional al tamaño

Si $s_i$ es el tamaño del proceso $p_i$, sabemos que $\sum^{n}_{i = 1} s_i = S$ es el tamaño total de los procesos. Por tanto, teniendo en cuenta el tamaño relativo de los procesos, se tiene que la asignación para cada proceso $i$ es $$a_i = \frac{s_i}{S}*m$$ donde $m$ es el número de marcos total

#### Asignación variable

El número de marcos asignados a un proceso varía según las necesidades que tenga el proceso (y posiblemente el resto de procesos del sistema) en diferentes instantes de tiempo. Con este tipo de asignación se pueden usar tanto estrategias de reemplazo locales como globales.

##### Hiperpaginación

Al aumentar el número de procesos, existe un valor a partir del cual el rendimiento del sistema caerá bruscamente. Se puede observar que ningún proceso adquiere tiempo de CPU. Además, hay un fuerte aumento del número de inercambio de páginas. Este problema se conoce como **hiperpaginación**

Para evitarlo, debemos asegurarnos de que cada proceso tenga asignado un espacio razonable en relación a su comportamiento (algoritmos de asignación variables)
También se puede actuar directamente sobre el grado de multiprogramación (algoritmos de regulación de cargas)