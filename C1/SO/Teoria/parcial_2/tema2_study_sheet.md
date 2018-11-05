# Tema 2.2: Diseño en implementación de procesos en Linux

## 2.2.1. Representación de los procesos

## 2.2.2. Estado de un proceso

## 2.2.3. Estructura interna de un proceso Linux

## 2.2.4. Contexto de un proceso

## 2.2.5. El árbol de procesos

## 2.2.6. Hebras kernel
- Las crea el kernel mediante una llamada a clone
- Para realizar operaciones en segundo plano
- No tienen espacio de direcciones

## 2.2.7. Ejecutando llamadas al sistema para gestión de procesos
### Funciones para la creación de procesos
|Llamada al sistema|Función de entrada|
|---|---|
|fork|sys_fork|
|vfork|sys_vfork|
|clone|sys_clone|

<u> Características de estas funciones: </u>
  - Implementación dependiente de la arquitectura
  - Extraen información suministrada en el espacio de usuario (parámetros de la llamada) e invocan a la función do_fork (independiente de la arquitectura)

### Pasos para la creación de procesos
- Se transfiere el control a la función `do_fork` del kernel
- Dicha fución llama a la función `copy_process`, que realiza en sí la creación del nuevo proceso__
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

## 2.2.8. Creación de hebras con clone

## 2.2.9. Copy-on-Write

## 2.2.10. Terminación de procesos

---
# Tema 2.3: Planificación en Linux

## 2.3.1. Una visión global de la planificación

## 2.3.2. Datos en la task_struct para la planificación

## 2.3.3. El planificador periódico

## 2.3.4. Planificador principal: intraducción

## 2.3.5. Sobre la expropiación en modo privilegiado

## 2.3.5. Sobre la expropiación en modo usuario

## 2.3.7. Actuación de schedule

## 2.3.8. Resumen sobre la invocación al planificador principal

## 2.3.9. Cambio de contexto

## 2.3.10. La clase de planificación CFS (Completly Fair Scheduler)

## 2.3.11. Implementación de CFS en Linux 2.6.24

## 2.3.12. La clase de planificación de tiempo real

## 2.3.13. Particularidades de SMP

---
# Tema 2.4: APÉNDICE. Reflexiones
