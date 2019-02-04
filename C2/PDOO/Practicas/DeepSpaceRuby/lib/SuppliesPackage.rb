
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8

module Deepspace
  class SuppliesPackage
    
    attr_reader :ammoPower, :fuelUnits, :shieldPower
    
    public
    
    def initialize(ap, fu, sp)
      @ammoPower = ap
      @fuelUnits = fu
      @shieldPower = sp
    end
    
    def self.newCopy(s)
      new(s.ammoPower,s.fuelUnits, s.shieldPower)
    end
    
    def to_s
      return "Potencia de disparo: #{@ammoPower}\nUnidades de combustible: "+@fuelUnits.to_s+
        "\nPotencia de escudo: "+@shieldPower.to_s
    end
    
  end
end
