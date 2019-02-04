
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8
require_relative "Transformation"
require_relative "SpaceStation"


module Deepspace
  class PowerEfficientSpaceStation < SpaceStation
    
    @@EFFICIENCYFACTOR=1.1
    
    def initialize(station)
      createStation(station)
    end
    
    def fire
      factor=super*@@EFFICIENCYFACTOR
      return factor
    end
    
    def protection
      factor=super*@@EFFICIENCYFACTOR
      return factor
    end
    
    def setLoot(loot)
      super
      if loot.efficient
        return Transformation::GETEFFICIENT
      else
        return Transformation::NOTRANSFORM
      end
    end
    
    def to_s
      return "POWER EFFICIENT SPACE STATION"+super
    end
    
  end
end
