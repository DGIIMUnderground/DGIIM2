# coding: utf-8

# ¿cuáles son los fallos?
module a

  class clase
  end
  class Clase
    def self.imprime
      puts "Soy la verdadera clase"
    end
  end
  class Clase
    def initialize x,y
      @a = x
    end
    def self.imprime
      puts "Yo soy la legítima clase"
    end 
  end
  
end

#¿qué imprime cada cosa?
clase = A::Clase.new
clase.imprime
A::Clase.imprime
(A::Clase(1,2).new).imprime
a = A::Clase.new 2,1        
a.self.imprime           
a.class.imprime
