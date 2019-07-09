# coding: utf-8
module NAVE  # nombre del módulo debe ser constante

class Nave
    @n_naves    = 0    # atributo de instancia de la clase
    @@recursos  = 1000 # atriburo de la case
    @COSTE_NAVE = 100  # atributo de instancia de la clase constante

    # Sólo son modificables los atributos de instancia. Por tanto, lo siguiente no está permitido
        #attr_writer :recursos
        #attr_reader :n_nave
        #attr_reader :COSTE_NAVEself.class
    # Los símbolos anteriores son buscados como atributos de instancia, por lo que no los encuentra

    attr_reader :nave_valida


    def initialize  # metodo que crea una nueva nave espacial
        @nave_valida = false

        puts "Los recursos actuales de los que disponemos es #{@@recursos}, el coste de la nave es #{self.class.coste_nave}"
        # no se puede hacer #{@COSTE_NAVE} !
        # Sin embargo, con un método de instancia de la clase sí se puede acceder


        # aunque esto no es constante no se puede hacer     |
        # lo entiendo como un método de clase llamado       |
        # numero_naves= (1)                                 |<- Qué narices significa esto
        # self.class.numero_naves = 1;


        if @@recursos > self.class.coste_nave # De nuevo, debemos el coste de la nave de esa forma. No podemos usar @@COSTE_NAVE
            @nave_valida = true

            puts "se puede crear la clase"
            self.class.actualiza_recursos(-self.class.coste_nave)

            # Tampoco podemos hacer lo siguiente:
                # @n_naves += 1
            # Sin embargo, con un método de instancia de la clase sí podemos modificarlo
            self.class.n_naves_suma 1
        end
    end

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
        # Lo siguiente no se puede hacer:
            # puts "#{a,b,c}"
        # puts #{} solo admite una variable dentro del scope (brackets) y solo una
        # No obstante, podemos imprimirlas de la siguiente forma sin problema

        puts a,b,c

        @nave_valida = false # esto crea otro atributo de instancia de CLASE, que se llama igual que el atributo de instancia
                             #           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^         ^^^^^

        @n_naves = 0
    end

    def self.naves?
        @nave_valida
    end

end #clase nave

end # module
