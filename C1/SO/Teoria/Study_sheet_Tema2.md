# Tema 2
## 2.1 Generalidades
- **Ejecución de procesos de usuario**
  - Proceso en modo privilegiado => se ejecuta código del SO
  - Pila de núcleo para cada proceso: manejar llamadas/retornos al/del modo núcleo
  - Código del SO en espacio de direcciones compartidas, se comparte con todos los procesos
  - Llamada al sistema: El procesador se pone en modo núcleo y el control se pasa al SO. => cambio de modo dentro del mismo proceso.
- **Creación de procesos**
  - Crear proceso => asignar memoria y estructura de datos para su administración
  - Sucesos que provocan creaciones de procesos en diferentes sistemas:
    - Sistemas bach: selección de uno de los trabajos por lotes en espera
    - Sistemas interactivos: cuando el usuario se conecta el SO crea un proceso que ejecuta un intérprete de órdenes
    - El mismo SO puede crear un proceso para responder a un servicio solicitado
- **Cambio de contexto**
  - **PCB**
  - Cambio de contexto => cambio de PCB en uso
    - Guardar contexto de P1 en su PCB
    - Cargar contexto de P2 desde su PCB
- **Colas de estado**
  - Tipos de colas:
    - **Cola de trabajos**: pendientes de ser admitidas
    - **Cola de preparados**: cargados en memoria principal. Listos para  ejecutarse
    - **Cola de bloqueados**: en espera de algún evento (Ejemplo: E/S)
  - Cada PCB está en una de dichas colas
- **Planificador de procesos**
  - Parte del SO que controla la utilización de un recurso
  - Tipos:
    - A largo plazo: selecciona trabajos a admitir
    - A corto plazo: selecciona trabajo que debe ejecutarse desde la cola de preparados. Equivalente con despachador aquí
    - A medio plazo: mete y saca procesos a/de memoria RAM
  - Ráfagas de CPU y de bloqueo: se alternan en el proceso
  - Mezcla de trabajos
    - Limitación por E/S => CPU poco usada
    - Limitación por CPU => E/S poco usada
  - Debe optimizar el uso de CPU y baja penalización para los procesos

## Algoritmos de planificación
- **FIFO**:
  - No apropiativo
  - Fácil de implementar. Poco útil
  - Invoncenientes:
    - Un proceso se adueña de la CPU
    - Ráfagas cortas mal tratadas
- **SJF**
  - No apropiativo
  - Cuando termina un proceso, entra el que tenga la ráfaga de CPU más corta
  - 2 procesos con idéntica ráfaga => FIFO
  - Necesita estimación
  - Utilidad teórica
- **SJF con desplazamiento**
  - Misma idea que SJF
  - Si entra un nuevo proceso con tiempo de ejecución < tiempo de ejecucición restante actual, el nuevo proceso es asignado a CPU
  - Ventajas, suponiendo un buen método de estimación:
    - Ráfagas cortas muy bien tratadas
    - Ráfagas largas muy mal tratadas
    - Tiene la menor penalización promedio
- **Round Robin**
  - Cola de ejecutables ordenada por cronológico
  - Se elige el proceso más antiguo de la cola de ejecutables
  - Tiempo de CPU máximo determinado por quantum
  - Si el proceso no ha terminado su tiempo total, se pone de vuelta en la cola de ejecutables
  - Si un proceso llega a la cola de ejecutables cuando otro acaba su quantum, tendría mayor preferencia el nuevo proceso.
  - Valor de quantum pequeño => demasiados cambios de contexto
  - Valor de quantum grande => muy similar a FIFO
- **Colas múltiples**
  - A menor número de prioridad, mayor preferencia de asignación
  - Cada nivel de prioridad tiene asociado un algoritmo para elegir entre los procesos de dicho nivel
  - Se pueden usar colas múltiples con diferentes algoritmos. Ej: FIFO con colas
  - Problema de inanición: un proceso puede estar esperando indefinidamente sin llegar nunca a ejecutarse. Soluciones:
    - Mecanismo de envejecimiento: aumentar prioridad a los porcesos que llevan cierto tiempo esperando
    - Cola con porcentaje determinado de tiempo de CPU a asegurar para cada proceso de la cola
- **Colas múltiples con realimentación** (o con traspaso)
  - Sean $cola_{n}, ..., cola_{N}$ distintas colas con $q_{1},...,q_{n}$ quantums respectivos. Por hipótesis, $q_{1} < q_{2} < ... < q_{n}$.
  - Cuando un proceso entra, se le asocia en $cola_{1}$. Cuando cumple cierto requisito, se le baja una cola
  - Cuando llega a $cola_{n}$, permanece ahí hasta que termina.
  - Si un proceso entró en estado de bloqueo, y se ha desbloqueado, puede...
    - Entrar de nuevo en la última cola
    o
    - Entrar en $cola_{1}$
  - Ráfagas tratadas acorde con su duración:
    - Ráfagas cortas salen rápido
    - Procesos con ráfagas largas van pasando por diferentes colas

---

### Terminología
##### Conceptos básicos
- **Ráfaga de CPU**: periodo de tiempo en un proceso en el que está en uso de CPU
- **Ráfaga de bloqueo**: periodo de tiempo en un proceso en el que se encuentra en estado bloqueado
- **Proceso limitado por E/S**: largos periodos de espera por la necesidad de usar el bus de datos
  - Ráfagas de CPU cortas
- **Proceso limitado por CPU**: largos periodos de tiempo de uso de CPU. Pocas interrupciones
  - Ráfagas de CPU largas
- **PCB** : Process Control Block. Almacena PC, registros, puntero a pila
- **Planificador de procesos**: Parte del SO que controla la utilización de un recurso
- **Despachador**: parte del SO que realiza las funciones necesarias para cambiar de proceso en CPU
  - Salva y restaura PCBs
  - Salto a la posición de memoria del nuevo proceso
- Política de planificación **apropiativa**:
  1. Se puede pasar a estado bloqueado un proceso
  2. Se puede retirar de CPU si hay otro proceso con mayor preferencia
- **Inanición**: proceso espera en colas con prioridad sin poder ejecutarse
##### Notación y variables para algoritmos de planificación
- Tiempo de CPU $t$
- Tiempo de respuesta / Finalización $T$ (finalización - creación)
- Tiempo de espera $E = T - t$
- Tiempo de penalización $P = T/t$
- Quantum: unidades de uso máximas de CPU
  - Nota: un algoritmo de planificación que no use el concepto de quantum queda descartado para entornos interactivos.
- Quanta $m_{i}$: en colas múltiples con realimentación, ¿determinado número de quantums? requeridos para cambiar de cola
##### Glosario de algoritmos
Explicados en la parte superior. Aquí solo se recoge su nombre y lo que significa
- **FIFO**: First In First Out /  FCFS: First Come First Served
- **SJF**: Shortest Job First
- **Desplazamiento**: llegadas de procesos que pueden mover a bloqueados al actual
- **SJF con desplazamiento** = SRTF: Shortest Remaining Time First
- **RR**: Round Robin / Planificador por turnos / Barrido cíclico
- **Colas múltiples**: diferentes prioridades por cola
---
- Sobre el concepto de quantum: un algoritmo de planificación que no lo use queda descartado para entornos interactivos.

---
## Tema 2.2: Diseño en implementación de procesos en Linux

### 2.2.1. Representación de los procesos
Estructura `task_struct`
### 2.2.2. Estado de un proceso

### 2.2.3. Estructura interna de un proceso Linux

### 2.2.4. Contexto de un proceso

### 2.2.5. El árbol de procesos

### 2.2.6. Hebras kernel
- Las crea el kernel mediante una llamada a clone
- Para realizar operaciones en segundo plano
- No tienen espacio de direcciones

### 2.2.7. Ejecutando llamadas al sistema para gestión de procesos
#### Funciones para la creación de procesos
|Llamada al sistema|Función de entrada|
|---|---|
|fork|sys_fork|
|vfork|sys_vfork|
|clone|sys_clone|

<u> Características de estas funciones: </u>
  - Implementación dependiente de la arquitectura
  - Extraen información suministrada en el espacio de usuario (parámetros de la llamada) e invocan a la función do_fork (independiente de la arquitectura)

#### Pasos para la creación de procesos
- Se transfiere el control a la función `do_fork` del kernel
- Dicha fución llama a la función `copy_process`, que realiza en sí la creación del nuevo proceso.
- `do_fork` hace posible que el nuevo hijo se ejecute

#### Actuación de `copy_process`
1. Se crea una nueva pila kernel, la estructura thread_info y la task_struct del nuevo proceso con los valores de la tarea actual.
2. Para los elementos de task_struct del hijo que daban tener valores distintos a los del padre, se les dan los valores iniciales correctos.
3. Se establece el estado del hijo a TASK_UNINTERRUPTIBLE mientrad se realizan las siguientes acciones.
4. Se establecen valores adecuados para los flags de la task_struct del hijo:
    - Pone a 0 el flag PF_SUPERPRIV: indica si la tarea usa privilegio de superusuario.
    - Pone a 1 el flag PF_FORKNOEXEC: indica si el proceso ha hecho fork pero no exec
5. Se llama a lloc_pid para asignar un PID a la nueva tarea
6. Según los flags pasados a `clone`, duplica o comparte recursos (archivos, información de sistemas de archivos, espacio de direccionamiento del porceso...)
7. Devuelve un puntero a la `task_struct` del hijo.

### 2.2.8. Creación de hebras con clone
- Función clone:
`int clone(int (*func) (void *), void *child_stack, int flags, void *func_arg, ...)`
- Crea un proceso hijo que comienza ejecutando la función `func`, que finaliza cuando retorne la función o realice una llamada `exit`.
- El tercer argumento son los indicadores de clonación. Se crea una hebra usando: `CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_THREAD | CLONE_SIGHAND`
  - `CLONE_VM`: padre e hijo comparten el mismo espacio de memoria virtual, es decir, la task_struct de ambos apunta a la mima mn_struct.
  - `CLONE_FS`: padre e hijo comparten la información relativa al sistema de archivos, es decir, la task_struct de ambos apunta a la misma fs_struct.
  - `CLONE_FILES`: padre e hijo comparten la misma tabla de descriptores abiertos, es decir, la task_struct de ambos apunta a la misma files_struct.
  - `CLONE_THREAD`: el hijo es incluido en el mismo grupo de procesos que el padre
  - `CLONE_SIGHAND`: padre e hijo comparten manejadores de señales, señales pendientes y señales bloqueadas.

### 2.2.9. Copy-on-Write
- Con esta técnica, en la creación de un nuevo proceso, inicialmente al hijo no se le asigna un nuevo espacio de memoria, sino que las páginas del padre resultan de entrada compartidas por ambos.
- Cuando uno de los dos procesos intenta acceder a una página se genera una excepción y se hace una copia de esa página para dicho proceso.

### 2.2.10. Terminación de procesos
- Terminación del proceso $\Rightarrow$ el kernel libera sus recursos y notifica al padre su terminación
- Motivos para la terminación:
  - Llamada al sistema `exit`
  - Recibe una señal ante la que tiene la acción preestablecida de terminar
- Esto lo hace la función `do_exit`

#### Funcinamiento de `do_exit`:
1. Establece el flag PF_EXITING de `task_struct`.
2. Decrementar el contador de cada recurso que indicar el número de procesos que lo están usando. Si vale 0 se destruye el recurso.
3. Almacenar el valor que se pasa como argumento a `exit` en el campo `exit_code` de la `task_struct`.
4. Enviar al padre la señal SIGCHLD indicando la finalización del hijo.
5. Si el proceso tiene hijso, se pone como padre de éstos al proceso init.
6. Se estable el campo `exit_state` de la `task_struct` a EXIT_ZOMBIE
7. Se llama a `schedule` para que el planificador elija un nuevo proceso a ejecutar.

- `do_exit` nunca retorna

---
## Tema 2.3: Planificación en Linux
- Algoritmo de planificación: **Prioridades con desplazamiento**

### 2.3.1. Una visión global de la planificación
- Planificación modular: diferentes algortimos según tipo de procesos
- Clases de planificación:
  - Planificación de tiempo real
  - Planificación neutra o limpia (CFS: Completly Fair Scheduling)
  - Planificación de la tarea "idle"

### 2.3.2. Datos en la task_struct para la planificación
```c
struct task_struct {
  ...
  int prio, static_prio, normal_prio;
  ...
}
```
- `static_prio`: prioridad estática o nominal de un proceso. Se le asigna cuando es creado, es modificado por la llamada nice.
  - Rango de valores:
    - [0, 99]: procesos de tiempo real
    - [100, 139]: procesos normales o regulares
- `normal_prio` y `prio`: prioridades dinámicas del proceso, calculadas a partir de static_prio.

Más cosillas:
```c
struct task_struct {
  ...
  const struct sched_class * sched_class; // clase de planificación a la que pertenece el proceso

  unsigned int policy; // política de planificación que se aplica al proceso
  ...
}
```
- `policy` tine los siguientes valores posibles:
  - Políticas manejadas por el planificador de tiempo real:
    - SECHD_RR: Round-Robin
    - SECHD_FIFO: FIFO
  - Políticas manejadas por le planificador CFS:
    - SCHED_NORMAL: para procesos normales (frente a los de tiempo real)
    - SCHED_BACH: tareas menos importantes, gran proporción de   - Rango de valores:
    - [0, 99]: procesos de tiempo real
    - [100, 139]: procesos normales o regularesCPU para cálculos. estos procesos nunca pueden desplazar a otros.
    - SCHED_IDLE: tareas que tienen un peso mínimo para ser elegidas para la asignación de CPU.

### 2.3.3. El planificador periódico
- Actualiza las estadísticas del kernel y activa el método de planificación periódico de la clase de planificación a la que corresponde el proceso actual.
- En caso de tener que replanificar:
  - Activa el flag TIF_NEED_RESCHED asociado al proceso en su thread_info
  - El kernel toma una nueva decisión de replanificación cuando sea oportuno

### 2.3.4. Planificador principal: introducción
- Implementado en la función schedule, invocada en diversos puntos del kernel.

#### Expropiación
- Se da cuando el SO retira la asignación de la CPU al proceso actual aunque pudiera seguir ejecutándose, cuando decide que hay otro preferente.
- Si el proceso actual está en un punto intermedio de una llamada al sistema o excepción y el nuevo proceso provoca una llamada al sistema o interrupción tendríamos dos caminos de ejecución dentro del kernel simultáneamente. Esto puede producir comportamiento incorrecto y tiene que ser cuidadosamente gestionado.
<br>
- **Kernel expropiativo** o reentrante: se le puede retirar la CPU a un proceso que está ejecutando código kernel. Implementa la protección necesaria para evitar errores.
- **Kernel no expropiativo** o no reentrante: no se puede quitar la CPU a un proceso que está ejecutando código kernel.
<br>
- **Expropiación en modo privilegiado**: acción de retirar la CPU a una tarea que está ejecutando código kernel.
- **Expropiación en modo usuario**: acción de retirar la CPU a una tarea que está ejecutando código usuario.
<br>
- Siempre que se ejecuta una parte del kernel se aprovecha para chequear sobre la asignación de CPU.
<br>
- La expropiación se realiza siempre partiendo de modo kernel y según qué esté ejecutando la tarea actual, pasando a modo usuario o kernel

### 2.3.5. Sobre la expropiación en modo privilegiado (kernel)

### 2.3.5. Sobre la expropiación en modo usuario

### 2.3.7. Actuación de schedule

### 2.3.8. Resumen sobre la invocación al planificador principal

### 2.3.9. Cambio de contexto

### 2.3.10. La clase de planificación CFS (Completly Fair Scheduler)

### 2.3.11. Implementación de CFS en Linux 2.6.24

### 2.3.12. La clase de planificación de tiempo real

### 2.3.13. Particularidades de SMP

---
## Tema 2.4: APÉNDICE. Reflexiones
