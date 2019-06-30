# Apuntes de clase

## Tabla de contenidos



## 1. Introducción

Estos apuntes repasan la asignatura Programación y Diseño Orientado a Objetos. Están pensados para usarlo como guía de estudio. Señalarán los conceptos más importantes, así como posibles fallos que se puedan dar a la hora de programar.

Antes de empezar, hay que tener en cuenta lo siguiente:

**En Java y en Ruby todo son referencias.**

En Java son todo referencias.

¿He dicho que en en Java son referencias siempre?

Pues lo son. Ten cuidado con eso. Si metemos mano a lo que no debemos, y de una forma que aparentemente no parece incorrecta, podríamos ser capaces de modificar el comportamiento interno de un objeto desde fuera. Por ejemplo:

```java
class ShitHappens {
    ArrayList<String> array;

    ...

    ArrayList<String> getArray () {
        return array;
    }
}
```

No está devolviendo una copia. Está devolviendo **el array entero**. Aunque es un getter, tocar lo que devuelve modifica el array de la clase. Bueno, y... ¿Qué pasará si devolvemos una copia?

```java
class ShitHappens {
    ArrayList<String> array;

    ...

    ArrayList<String> getArray () {
        ArrayList<String> retorno = new ArrayList<>();

        for (String elemento: array)
            retorno.add(elemento);

        return retorno;
    }
}
```

Tampooc nos vale. Estamos devolviendo **las referencias que se hayan dentro del array**. Así que podemos seguir tocándolo. Ya veremos más adelante cómo se hacen las copias debidamente. Pero hay que tener en cuenta lo anterior. Aquí todo son referencias

Es también muy importante que tengamos en cuenta siempre cómo debe funcionar una clase. Podría seguir el siguiente esquema por capas:

```
Accedemos justo a esta capa de arriba desde fuera de la clase
                                            |
        ---------------------------         |
        | Comportamiento externo  | < - - - +
        ---------------------------
Clase:  | Comportamiento internto |
        ---------------------------
        |         Estado          |
        ---------------------------
```

Como nota final, debemos señalar que Ruby no es fuertemente tipado. Usa lo que se denomina *duck typing*. Esto produce lo siguiente:

```ruby
class A
    def metodo (p)
        return p + 5
    end
end
```

¿Qué es `p`? ¿Un String? ¿Un entero? ¿Otra clase nuestra? ¿Tiene definido la suma?

La respuesta es: sepa dios `¯\_(ツ)_/¯`

Le puedes pasar lo que te dé la absoluta gana. Y ya si peta Ruby, te lo dirá. Porque **Ruby es interpretrado**. Y, si algo no funciona, te lo dirá. Pero si funciona aunque sepa mal, no tendrás ni un warning, ni un fallo al compilar.

Esto al menos te forzará a pensar en el diseño de tus programas y, sobre todo, a apreciar lo maravillosamente pesado que es un compilador.

Empezamos así con la asignatura




## 2. Instancias y clases

#### Java

Sintaxis:

- Métodos y atributos de clase: se usa `static`
- Métodos y atributos de instancia: no tienen ningún matiz en especial. No llevan static

`final` funciona como const
`static` comparte un mismo atributo entre todas las clases - atributo de clase

No llamar a métodos de clase desde una instancia. Don't do it. Stahp

#### Ruby

Sintaxis de atributos y variables:
- **En ámbito de instancia**
    - `@variable` crea o llama un atributo de instancia
    - `variable` crea una variable local **que no es de la clase**
- **En ámbito de clase**
    - `@variable` crea o llama un atributo de instancia de clase
    - `@@variable` crea o llama un atributo de clase
    - `variable` crea o llama una variable local

**Recuerda usar los correspondientes `@` en los métodos. Si no, se crearán variables**

Todo lo que empiece por mayúscula es constante. Ponerlo todo en mayúsculas es una buena costumbre.

Los atributos de instancia se definen y se inicializan dentro de métodos de instancia. En teoría, deberíamos hacerlo nada más que dentro de initialize.
Los atributos de instancia de clase se deben definir fuera de los métodos de instancia; es decir, en ámbito de clase.

Para crear los métodos de clase, se usa la partícula `self.` antes de un método

Los métodos de clase se llaman con `nombre_clase.método()`:
```rb
class Persona
    @MAYORIA_EDAD = 18 # atributo de instancia de clase constante

    def self.edad_legal
        @MAYORIA_EDAD # se puede omitir return
    end

end

```
Para llamar a ese método: `Persona.edad_legal`.
Usamos `self` para crear métodos de clase.




## 3. Constructores

#### Java

```java
class Punto3D {
    ...

    public static void main() {
        Punto3D punto;   // No se crea nada. Es un objeto nulo.
        Punto3D point = new Punto3D(); // Aquí sí
    }
}
```

#### Ruby

No se pueden tener varios `initialize`
Nuevos constructores:

```ruby
class Punto
    def self.new_2D(x, y)
        new(x,y,0)            # Importante llamar siempre a new() alf final. self.new_2D no construye nada por sí mismo
    end

    private_class_method :new # pasa a ser privado. Con esto lo sobreescribimos

end
```

Hay otras formas de recibir parámetros de forma variable: mediante un array o con valores por defecto. Están en la presentación. No los recomienda.




## 4. Pseudovariables

`this` se refiere a la instancia que está ejecutando el código. Equivalentemente `self`. Si estamos tratando métodos de clase, se refiere a la clase.




## 5. Paquetes

#### Java

No tiene subpaquetes: el paquete `A` y `A.B` no tienen nada que ver. La única relación es el almacenamiento en disco

#### Ruby

No usar `include`. Simplemente copia y pega contenido de archivos.




## 6. Visibilidad

#### Java

- `private`
    - Solo accesible desde el código de la propia clase. Tanto en ámbito de instancia como de clase
    - Permite acceder a elementos privados de una instancia de la misma clase
- `package`
    - Elementos públicos dentro del mismo paquete
    - Inaccesibles desde otros paquetes
- `protected`
    - Elementos públicos dentro del mismo paquete
    - Accesibles para subclases, aunque estén en otros paquetes
    - Inaccesibles desde otros paquetes por no subclases
    - Dentro de una misma instancia se podrán acceder a elementos protegidos de la superclase
- `public`
    - Libre albedrío. Como Pedro por su casa.


| **Visibilidad de atributos/métodos** | **`public`** | **`protected`** | **`package`** | **`private`** |
|--------------------------------------|--------------|-----------------|---------------|---------------|
| Misma clase                          | ✓            | ✓               | ✓             | ✓             |
| Clase del mismo paquete              | ✓            | ✓               | ✓             | ✗             |
| Subclase del mismo paquete           | ✓            | ✓               | ✓             | ✗             |
| Subclase de distinto paquete         | ✓            | Solo herencia   | ✗             | ✗             |
| No subclase de distinto paquete      | ✓            | ✗               | ✗             | ✗             |


#### Ruby

Lo anterior no se aplica. Los atributos son siempre privados. Los métodos son públicos por defecto.


`private` solo afecta a los métodos de instancia:

```ruby
private
def self.metodo_clase_privado
    puts "Cosas"
end

# Esta mierda no es privada
```

Para hacer un método de clase privado, hay que hacer lo siguiente:

```ruby
private
def self.metodo_clase_privado
    puts "Cosas"
end

private_class_method :metodo_clase_privado
```

Regla de oro de Ruby para métodos privados: *"no se puede acceder a un método privado si hay algún receptor explícito delante"*. Esto incluye `self` y variables. Esto implica:
- Solo se puede utilizar un método privado de la propia instancia
- No se puede acceder a métodos privados de clase desde el ámbito de instancia
- No se puede acceder a métodos privados de instancia desde el ámbito de clase

`protected` permite que los métodos puedan ser invocados con un receptor explícito siempre que la clase del código que la invoca sea la misma o una subclase. Solo se pueden proteger métodos de instancia.

```ruby
# Las líneas comentadas dan fallos

def Padre
    private
    def privado
    end

    protected
    def protegido
    end

    public
    def publico
    end
end

def Hija < Padre
    def test (p)
        privado
        #self.privado   # Receptor explícito delante de método privado
        #p.privado      # Receptor explícito delante de método privado

        protegido
        self.protegido
        p.protegido

        publico
        self.publico
        p.publico
    end
end

Hija.new.test(Hija.new)
Hija.new.test(Padre.new)

h = Hija.new
#h.privado            # Receptor explícito delante de método privado
#h.protegido          # Receptor explícito delante de método protegido fuera de una subclase
h.publico
```



## 7. Herencia

La clase hija que hereda del padre añade y/o modifica el comportamiento de la clase padre.

La relación que se establece es del tipo *es-un*. Reutilizar métodos no es motivo suficiente para aplicar herencia. Tampoco debe limitar el comportamiento del padre.

Realmente, podemos ver la herencia como una especie de composición implícita del lenguaje.

#### Java

**Los constructores no se heredan**, pero sí se pueden invocar. Por ello, se necesita llamar a `super`. **En la primera línea**. Si no se hace, la instancia del padre que se halla *"dentro"*
`super.metodo()` permite llamar a cualquier método. No se limita al que se está redefiniendo.

Restricciones de la redefinición:
- Cambiar la visibilidad a una más permisiva
- El valor retornado puede ser de una subclase al indicado en el ancestro
- No se pueden redefinir métodos `final`
- No se pueden redefinir métodos privados

#### Ruby

Ruby llama automáticamente al initialize del padre **si no se ha redefinido su initialize**. Si vas a cambiar algo, necesitas llamar a `super` o de lo contrario, no existirá una instancia del padre *"dentro"* de la hija.
Esto hace que no se puedan usar métodos del padre ni atributos. Cuidado.
`super` únicamente puede llamar al método del padre que se está redefiniendo. Si se utiliza sin argumentos, automáticamente se pasan los argumentos



## 8. Interfaces y clases abstractas

Ruby no tiene clases abstractas ni interfaces. Se puede simular, pero poco más. Por lo tanto, todo lo que hablaremos a continuación será aplicable principalmente a Java.

#### Clases abstractas

Una clase abstracta no tiene por qué implementar un método. Lo que hacen es **forzar** a que las hijas lo hagan. Estos métodos se denominan `abstract`. Tener hijos para esto...
**No se puede instanciar una clase abstracta**

#### Interfaces

Una interfaz es un contrato. Es una colección de métodos abstractos y propiedades constantes. Especifican qué se debe hacer, pero no cómo. Por tanto, las clases que implementen esa interfaz, están obligadas a proporcionar dichos métodos.

La principal diferencia entre una clase abstracta y una interfaz es que las interfaces no fuerzan a usar herencia.

No obstante, se puede diseñar una implementación por defecto para un método de la interfaz con `default`. Esto hace que los hijos no tengan por qué implementarlo obligatoriamente.

Características:
- Las instancias de una clase pueden realizar varias interfaces
- Una interfaz puede heredar de una o más interfaces
- Una interfaz solo puede tener: constantes, signaturas de métodos, métodos tipo default y el equivalente a los métodos de clase (static)
- Solo los métodos tipo default y static pueden tener asociada implementación
- Todos los métodos son públicos y las constantes public, static, y final
- No pueden ser instanciadas, solo realizadas o extendidas por otras interfaces
- Una clase puede heredar de otra e implementar varias interfaces.

Para resolver las colisiones de nombres, se puede hacer lo siguiente:

```java
interface A {
    default int metodo() { return 2; }
}

interface B {
    default int metodo() { return 1; }
}

class clase implements A, B {
    @Override
    int metodo() {
        return A.metodo() + B.metodo();
    }
}
```



## 9. Polimorfismo

En términos generales, el [polimorfismo es la propiedad que permite enviar mensajes sintácticamente iguales a objetos de distinto tipo](https://es.wikipedia.org/wiki/Polimorfismo_(inform%C3%A1tica)). También es la capacidad de un objeto de tomar diferentes formas. Como vemos, la definición es muy general. Por lo que es normal que nos encontremos diferentes tipos.

Existen 3 principalmente:
- Polimorfismo ad-hoc: una interfaz común para un conjunto de individuos de tipos específicos
- Polimorfismo paramétrico: capacidad de definir un método común a varios tipos distintos con propiedades comunes
- Subtyping: cuando un nombre denota instancias de diferentes clases relacionadas por una superclase común

En los lenguajes sin declaración de variables, el polimorfismo se da sin limitaciones y de forma natural. Cuando sí se usan tipos, hay ciertos aspectos que debemos tener en cuenta.

Aunque no lo hemos tratado explícitamente, en esta asignatura se hace mucho incapié en los principios SOLID (*Single responsibility, Open-closed, Liskov substitution, Interface segregation and Dependency inversion*).
En esta sección nos aseguraremos de seguir el principio de sustitución de Barbara Liskov:

> *["Cada clase que hereda de otra puede usarse como su padre sin necesidad de conocer las diferencias entre ellas"](https://es.wikipedia.org/wiki/Principio_de_sustituci%C3%B3n_de_Liskov)*
> \- *Barbara Liskov*

Es decir, si B es un subtipo de A, se pueden utilizar instancias de B donde se esperan las de A

---

### 9.1. Introducción al polimorfismo en Java

Java utliza tanto tipos estáticos como dinámicos. Cuando declaramos una variable sin hacer new, estamos usando el tipo estántico. Lo que viene tras `new` denota su tipo dinámico:

```java
estatico objeto = new dinamico();
```

Ruby no tiene mecanismo de declaración de variables. Cualquier variable puede referencias cualquier tipo de objeto.

El polimorfimo cobra sentido cuando se combina con ligadura dinámica. Es decir, el tipo dinámico determina el objeto que se ejecutará asociado a la llamada de un objeto. Como contrapartida, la ligadura estática hace que el código asociado a la llamada de un método se
determine en tiempo de compilación.

**El tipo estático limita lo que puede referenciar una variable**. Solo es capaz de referenciar instancias del tipo estático o subclases del tipo estático.
Además, **limita también los métodos que pueden ser invocados**. Solo se permiten invocar los métodos de los que dispone el tipo estático.

```java
class Persona {
    String andar()  {return "Ando como una persona"}

    String hablar() {return "Hablo como una persona"}
}

class Profesor extends Persona {
    @Override
    String hablar() {return "Hablo como un profesor"}
}

public class Main {
    public static void main (String[] args ){
        Persona p1 = new Persona();
        Persona p2 = new Profesor();  // <-----

        p1.hablar() // => "Hablo como una persona"
        p2.hablar() // => "Hablo como un profesor"
    }
}
```
Vemos que en el caso de `p2`, **se ha ejecutado el código asociado al tipo dinámico**.

> La disponibilidad de métodos de una variable viene dada por la intersección de los métodos de estático y dinámico, dándole prioridad a los del tipo dinámico

Se pueden ejecutar los métodos que tenga `Persona`, pero si se encuentran en `Profesor`, se usarán esos. Si no, recaen a los de `Persona`.

Veamos un ejemplo en el que el programa explota:

```java
class Profesor extends Persona {
    String impartir_clase() { // Este método no se haya en las superclases
        return "Impartiendo clase"
    }
}

public class Main {
    public static void main (String[] args ){
        Persona p = new Profesor();

        p.impartir_clase()
    //  ^^^^^^^^^^^^^^^^^^ Fallo de compilación: No se puede encontrar el método

        p = new Object()
    //  ^^^^^^^^^^^^^^^^^^ Fallo de compilación: Object no es una subclase de Persona
    }
}
```

---

### 9.2. Casting

Para arreglar ciertos problemas de compilación, haremos casting o *casteo*, un *spanglishmo* que suena bastante bien. Consiste en cambiar una expresión de un tipo de dato a otro. Esto puede ocurrir de forma implícita o explícita:

```java
double d;
int i;

if (d < i) // Implícita
    ...
```

Es importante matizar que castear no hace ninguna transformación en el objeto referenciado ni cambia su comportamiento. Únicamente es una indicación al compilador. El **programador se responsabiliza de lo que ocurra a partir de ahí con el objeto.**

> ![](./Fotos_apuntes/MJHID.gif)
> \- *Compilador*

La forma de esquivar ciertos erores de compilación esto son casteos. Pero te la juegas a que pete en tiempo de ejecución. Si estás seguro de que se puede encontrar el método, puedes hacerlo. Si no, ten cuidado.

A continuación veremos la forma explícita. Existen diferentes tipos de casteos:
- Downcast: se le indica al compilador que el tipo dinámico de una referencia es una subclase del tipo estático.
- Upcast: normalmente innecesario y reduntante. Aporta 0.
- Sidecast: nombre técnico para algo que seguro hará que explote tu programa.

El único tipo de casteo que produce errores en tiempo de compilación es el sidecast. El resto en ejecución.

Hay una excepción a lo dicho con upcast, y ocurre cuando una función tenga distinto comportamiento al ser pasado con un objeto u otro. Pero este caso no lo vemos nosotros.

Retomemos el ejemplo de antes usando casteos:

```java
public class Main {
    public static void main (String[] args ){
        Persona p = new Profesor();

        p.impartir_clase() // Fallo de compilación: No se puede encontrar el método
        p = new Object()   // Fallo de compilación: Object no es una sublcase de Persona

        Profesor prof = p; // Fallo de compilación. Un profesor no es en general una persona

    // ────────────────────────────────────────────────────────────────────────────────


        ((Profesor) p).impartir_clase();
    /*    ^^^^^^^^
        Cambiamos el tipo dinámico momentáneamente a Profesor. Y, entonces,
        Podemos saltarnos la restricción de la intersección de los tipos.
        Como el tipo dinámico es Profesor, y new hace que SÍ TENGAMOS disponibles los métodos
        de la clase Profesor, esto no tendrá ningún problema
    */


    // ────────────────────────────────────────────────────────────────────────────────


        Profesor profe = (Profesor) p;
    /*                    ^^^^^^^^
        Del mismo modo, como el tipo dinámico ha construido correctamente los elementos de Profesor,
        podemos hacer un downcast y asignarlo correctamente a la variable nueva.

        De hecho, fíjate en el error anterior, el de Profesor prof = p. Ahí no se puede hacer
        debido a que no hicimos el casteo.
    */


    // ────────────────────────────────────────────────────────────────────────────────


        profe.hablar(); // => "Hablo como un profesor". Se le da prioridad al tipo dinámico

        ((Persona) profe).hablar(); // => "Hablo como un profesor"
        /*
            Recuerdas lo que dijimos? Los upcast en general no hacen nada
            Efectivamente, ha conseguido hacer absolutamente 0 este upcast.
            Dissapointed but not surprised
        */

        Persona p2 = profe;
        p2.hablar(); // => "Hablo como un profesor"
        /*
            Este es un ejemplo de upcast implícito. Tampoco hace nada.
        */
    }
}
```

`new` construye la instancia del objeto. Por lo tanto, si NO has construido un objeto `X`, no vas a poder castear y usas métodos del objeto final. Dará error en tiempo de ejecución.

Pero, como lo más normal es que la caguemos olímpicamente al castear, analicemos algunos fallos:

```java
public class Main {
    public static void main (String[] args ){
        Persona p = new Persona();

        Profesor profe = (Profesor) p; // Fallo en tiempo de ejecución
        // No tenemos construido los datos necesarios de Profesor, por lo que castear hacia abajo es imposible

        ( (Profesor) new Persona() );      // Fallo en tiempo de ejecución
        ( (Profesor) p).impartir_clase();  // Fallo en tiempo de ejecución
        // De nuevo, no tenemos los métodos de Profesor porque nunca se construyeron. No se pueden usar

        ( (Profesor) ((Object) new Profesor()) ).impartir_clase(); // Este funciona
    /*
        Veamos por qué funciona el anterior:

        Primero, se crea un nuevo Profesor. A continuación se castea hacia arriba => no se hace nada.
        Lo siguiente que se hace es downcastearlo a un profesor. Por lo que tampoco se hace nada.
        Nos hemos quedado como estábamos
        Por último, se intenta usar impartir_clase(). Perfecto, porque hemos construido Profesor
    */

    }
}
```

Veamos ahora unos poquitos ejemplos de sidecast. Darán fallos, pero no tienen por qué ser en ejecución:

```java
class Alumno extends Persona {
    // Clase hermana
}

public class Main {
    public static void main (String[] args ){
        Alumno a1 = new Profesor();          // Error en compilación: tipos incompatibles
        Alumno a2 = (Alumno) new Profesor()  // Error en compilación: tipos incompatibles

        Alumno a3 = ( (Alumno) ((Object) new Profesor()) );
    /*
        Fallo en ejecución: Profesor no puede ser casteado a alumno.

        Como el primer casteo ha funcionado, a partir de ahí es responsabilidad del programador.
        Sí, el casteo de nuevo es inútil, pero ha funcionado.
        Por lo tanto, el compilador ya no comprobará nada
    */

    }
}
```



## 10. Polimorfismo paramétrico

También conocido como *generics* o *templates*. Permiten definir métodos y clases genéricas cuyas operaciones son aplicables a distintos tipos de datos. Por ejemplo, si un método devuelve la suma de dos objetos, esta operación es válida para strings, floats, enteros, dobles o cualquier clase que tenga definida la suma.

#### Java

Se pueden pasar parámetros a clases, interfaces y métodos que serán tipos.

```java
class Array<T> {...}
```

Además, se puede forzar a que dicho parámetro herede de cierta clase:

```java
abstract class Forma {}

class Cuadrado extends Forma {...}
class Circulo extends Forma {...}
class Triangulo extends Forma {...}

class ArrayFormas <T extends Forma>
```

Aunque lo siguiente es una chapuza, si nos ponemos farrucos, podemos tener arrays con distintos tipos de datos que no tienen demasiado sentido a priori. Por ejemplo, un array con `[String, int]`

#### Ruby

Ruby no es fuertemente tipado. Tiene duck typing. Así que... Todo es genérico `¯\_(ツ)_/¯`




## 11. Copia de objetos

Copia de profundidad baja:

```java
Arraylist<tipo> getArray(){
    return (ArrayList) (array.clone());
}
```

Ojo, que esto te sigue permitiendo modificar los elementos de dentro. Simplemente evita que le hagas operaciones al array del tipo `clear()`

Copia defensiva de mayor nivel. Es decir, copia profunda:

```java
class Numero implements Cloneable {
    private Interger i;

    @Override
    public Numero clone() throws CloneNotSupportedException {
        Numero nuevo = (Numero) super.clone();
        nuevo.i = i.clone();
        return nuevo;
    }
}

class ComplejaMasSegura implements Cloneable {
    ArrayList numeros;

    ArrayList getNumeros() {
        // Copia profunda
        ArrayList<Numero> nuevo = new ArrayList<>();
        Numero n = null;

        for (Numero i: this.numeros) {
            try {
                n = i.clone(); // Implementada en Numero. Ya es segura
            } catch (CloneNotSupportedException e) {
                System.err.println("CloneNotSupportedException");
            }

            nuevo.add(n);
        }

        return nuevo;
    }

    public ComplejaMasSegura clone() throws CloneNotSupportedException {
        ComplejaMasSegura nuevo = (ComplejaMasSegura) super.clone();
        nuevo.numeros = this.getNumeros(); // Ya se hace la copia profunda
        return nuevo;
    }
}
```



## 12. UML

Sintaxis:
<img src="./Fotos_apuntes/UML.png" alt="UML" class="center">

#### Tipos de relaciones

- Asociación: relación estructural fuerte y duradera en el tiempo. Línea continua. Navegabilidad indicada por puntas de flechas. Son líneas continuas.
Pueden tener, además, una clase asociada que se usa como enlace. Con respecto a las propiedades, se pueden indicar cuántos elementos tienen la asociación y otras propiedades. Ejemplo de asociación:

```
--------------------               --------------------
|   Lista éxitos   |   contiene    |     Canción      |
-------------------- x━━━━━━━━━━►  --------------------
| - nombre: string |        0..*   |- titulo: string  |
--------------------               |- artista: string |
                                   |- fecha: Date     |
                                   --------------------
```

- Hay otros tipos de asociaciones especiales.
    - Agregación: una clase representa el todo y la otra las partes (Rombo vacío: ♢)
    - Composición: agregación donde todas las partes no tienen sentido sin el todo. La cardinalidad debe ser 0..1 o 1 (Rombo relleno: ♦)
- Dependencia: relación débil y poco duradera. Por ejemplo, un parámetro. Se utiliza línea discontinua:
```
---------------------------            ---------------------
|          Gestor         |            |      Factura      |
--------------------------- x------->  ---------------------
| GenerarFactura: Factura |            |- referencia: int  |
---------------------------            |- CIF: string      |
                                       |- cantidad: float  |
                                       ---------------------
```
- Generalización
- Realización

La herencia se indica como una asociación con una punta de flecha hueca

#### Paquetes
Se pueden dar relaciones de dependencia entre paquetes