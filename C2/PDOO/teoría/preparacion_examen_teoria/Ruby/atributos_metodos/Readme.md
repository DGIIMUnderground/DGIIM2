# Conceptos teóricos sobre los que se apoya esta carpeta  

## Atributos de instancia  
- Variables asociadas al objeto que lo describen.
- Cada instancia tiene un espacio único. 
- Recomendable inicializarlos en el initialize.
- Ejemplo: `@nivel_felicidad`

## Métodos de instancia  

- Funciones o procedimientos asociados a las instancias de a clase. 

## Atributos de la clase   
- Información asociada a la clase y no a la instancia, única en memoria. 
- Se declaran fuera de cualquiermétodo. 
- Existen dos métodos distintos. 

### Atributos de clase 
- Declarados como ` @@atributo_de_clase`
- Accesibles directamente desde el ámbito de instancia. 
- Se comparten con las subclses en herencia. 

### Atributos de instancia de la clase   
- Declarados como `@atributo_de_instancia_de_la_clase` (nótese la colisión de notación con los atributos de instancia). 
- Si se escribe `@atrubuto` dentro de un método de clase, este será un atributo de instancia de la clase, y se distinguirán aunque se llame igual que un atributo de instancia. 
- No sé puede acceder desde ámbito de instancia. 
- No se comparten en herencia. 

## Métodos de clase  
- Estos métodos se crean añadiendo un self. ejemplo: `def self.metodo_clase()`
- Funciones y procedimientos asociados a la propia clase, actualiza y acceden a atributos de clase. 
- NO SE PUEDE ACCEDER A MÉTODOS DE INSTANCIA DESDE MÉTODO DE CLASE. 


