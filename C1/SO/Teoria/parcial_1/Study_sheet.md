# SO study sheet

> Disclaimer: esto no es un libro. No está diseñado para que se estudie. Su objetivo es proporcionar un listado de términos clave para servir como guía de repaso o estudio

## Tema 1: estructura de sistemas operativos

### Introducción

- Definición de sistema operativo
  - Conveniencia: interfaz máquina - usuario. Servicios
  - Eficiencia: gestión procesador, memoria,
  - Capacidad de evolucionar: actualizaciones
- Evolución de los SO
  - Procesamiento serial
    - Problemas: planificación, tiempo
    - Soluciones: herramientas software
  - **Sistemas monoprogramados**
    - Procesos de uno en uno en memoria
    - Problemas: desperdicio de tiempo, CPU, memoria; resultados
  - **Sistemas multiprogramados**
    - **Multiprogramación:** Varios procesos en memoria
    - Necesidades del SO:
      - Rutinas de E/S
      - Gestión memoria
      - Planificación CPU
  - **Sistemas de tiempo compartido**
    - Procesos interactivos
    - Multiprogramado
- **Características de un buen sistema operativo**
  - Correción: corregir fallos durante ejecución
    - Interrupciones
    - Excepciones
  - Eficiencia
  - Fiabilidad
    - Respuesta predecible a condicione
    - Protección contra ataques (malintencionados o sin querer)
  - Extensibilidad
  - Tolerancia a fallos
    - Respuestas diferentes a errores diferentes
    - Un error no grave no inutiliza el SO
  - Reentrancia
    - Varias instancias de ejecución
- Problemas en sistemas concurrentes
  - Llamadas al sistema, interrupciones, excepciones, SO en sí es concurrente

### Sistemas operativos de uso específico

- **SO de tiempo real**
  - Respuesta en tiempo específico
  - SO tiempo real estricto: tiempo especificado imperativo
  - SO tiempo real no estricto: el SO sigue funcionando aunque a veces no se cumpla el periodo de tiempo
- **Sistema informático distribuido**
  - Sin memoria ni reloj común
  - Única posibilidad para comunicar información
  - Disperso geográficamente
- **SO en red**
  - SO locales con capacidad para conectarse entre ellos
  - Necesaria implementación de E/S
  - Se conoce la ubicación de archivos y procesos en otras máquinas de la red
- **SO distribuido**
  - SO común para varios PCs de una red
  - Usuario desconoce la existencia de varias máquinas
  - Acceso transparente a las máquinas
- **SO paralelo**
  - Varias CPUs comparten reloj y memoria
  - Eficiencia de tareas computacionalmente complejas
  - Tarea dividida en actividades paralelas
  - SMP

### Arquitectura de sistemas operativos

- **Sistema monolítico**
  - SO como un único ejecutable en modo kernel. Un solo ejecutable
  - Problemas:
    - Sin ocultamiento de información. Cada procedimiento puede llamar a cualquier otro
    - Poco manejables. Sin estructura interna
    - Poco fiables: un error crashea el SO
    - Poco extensibles
    - Poca tolerancia a fallos
- **Estructura de capas**
  - SO organizado como jerarquía de capas
  - Una capa i-ésima se apoya en la i-1
- **Microkernel**
  - Kernel: funciones fundamentales del sistema
    - Cargado en memoria principal
    - Ejecución en modo privilegiado/kernel
    - Alto nivel de inhibición de interrupciones
  - Lo más importante del SO está en el kernel. El resto, implementado en procesos
  - Microkernel crea y comunica procesos (cliente-servidor)
  - Ventajas:
    - Mayor tolerancia a fallos y extensibilidad
    - Adaptable a sistemas distribuidos
  - Inconvenientes:
    - Peor rendimiento. Más ejecuciones para resolver un servicio

## Tema 2: procesos e hilos
### Generalidades

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

### Algoritmos de planificación
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
