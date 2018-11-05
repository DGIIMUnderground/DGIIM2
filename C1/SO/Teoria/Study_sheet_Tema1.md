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
