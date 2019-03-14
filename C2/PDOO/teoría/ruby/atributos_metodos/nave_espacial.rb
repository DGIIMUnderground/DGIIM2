# coding: utf-8
module NAVE  # nombre del módulo debe ser constante
  
  class Nave
    @n_naves = 0 # atributo de instancia de la clase 
    @@recursos = 1000 # atriburo de la case
    @COSTE_NAVE = 100

    # sólo son modificables para atributos de instancia, todo esto no está permitido
    # son buscados como atributos de instancia y no los encuentra 
    #attr_writer :recursos
    #attr_reader :n_nave
    #attr_reader :COSTE_NAVEself.class

    attr_reader :nave_valida

    # metodo que crea una nueva nave espacial
    def initialize
      
      @nave_valida = false
      puts "Los recursos actuales de los que disponemso es #{@@recursos}, el coste de la nave es " # no se puede hacer #{@COSTE_NAVE}
      
      puts self.class.coste_nave #con un método de instancia de la clase sí se puede acceder
      
      # aunque esto no es constante no se puede hacer
      # lo entiendo como un método de clase llamado
      # numero_naves= (1)
      # self.class.numero_naves = 1; 
      
      if @@recursos > self.class.coste_nave#  @COSTE_NAVE esto no se puede hacer por
        @nave_valida = true
        puts "se puede crear la clase"
        self.class.actualiza_recursos (-self.class.coste_nave)

        # tampoco te permite esto @n_naves += 1
        self.class.n_naves_suma 1
      end
      
    end #intialize
    def validez
      @nave_valida
    end

    def self.coste_nave
      @COSTE_NAVE
    end
    def self.n_naves_suma cantidad
      @n_naves += cantidad
    end

    def self.cantidad_naves
      @n_naves
    end 
    def self.actualiza_recursos  cantidad
      @@recursos += cantidad

    end
    def self.getRecursos
      @@recursos
    end

    def self.destruccion_flota a,b,c,d
      # puts "#{a,b,c}" # no se pueden introducir esta variables
      puts a,b,c
      @nave_valida = false # esto crea otro atributo de instancia de CLASE, que se llama igual que el atributo de instancia
      @n_naves = 0
    end

    def self.naves?
      @nave_valida
    end
    
  end #clasee nave  

end #module 


# ===================== main =================
 
