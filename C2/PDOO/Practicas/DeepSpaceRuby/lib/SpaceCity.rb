
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8
module Deepspace
  class SpaceCity < SpaceStation
    
    attr_reader :collaborators
    
    def initialize(base, rest)
      createStation(base)
      @base=base
      @collaborators=rest      
    end
    
    @override
    def fire
      disparo=super
      @collaborators.each{ |estacion|
        disparo+=estacion.fire
      }
      return disparo
    end
    
    @override
    def protection
      proteccion=super
      @collaborators.each{ |estacion|
        proteccion+=estacion.protection
      }
      return proteccion
    end
    
    @override
    def setLoot(loot)
      super
      return Transformation::NOTRANSFORM
      
    end
    
    def to_s
      cad="CIUDAD ESPACIAL:\nESTACION BASE:"+super+"\nCOLABORADORES:"
      @collaborators.each { |colaborador|
        cad+=colaborador.to_s
      }
      return cad
    end
    
    
  end
end
