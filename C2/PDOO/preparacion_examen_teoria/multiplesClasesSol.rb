# coding: utf-8
module A       #         | class/module name must be CONSTANT

  class Clase
    def self.imprime
      puts "Soy la verdadera clase"
    end
  end
  #Sobre escribe el valor de la clase, ahora esta es la clase nueva
  class Clase
    def initialize x,y
      @a = x
    end
    def self.imprime
      puts "Yo soy la legítima clase"
    end 
  end
  
end



# clase = A::Clase.new     | Error de argumentos
#A::Clase.imprime          | undefined method `Clase' for A:Module
A::Clase.imprime()
a=A::Clase.new 2,1        
#a.self.imprime            | undefined method `self'
A::Clase.imprime
(A::Clase.new(2,1)).class.imprime
a.class.imprime
