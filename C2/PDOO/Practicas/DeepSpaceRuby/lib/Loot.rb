
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8

require_relative "LootToUI"

module Deepspace
  class Loot
    
    attr_reader :nSupplies, :nWeapons, :nShields, :nHangars, :nMedals, :efficient, :spaceCity
    
    public
    
    def initialize(nsu, nw, nsh, nh, nm, ef=false, city=false)
      @nSupplies = nsu
      @nWeapons = nw
      @nShields = nsh
      @nHangars = nh
      @nMedals = nm
      @efficient=ef
      @spaceCity=city
    end
    
    def getUIversion
      return LootToUI.new(self)
    end
    
    def to_s
        return "Suplementos: #{@nSupplies}, Armas: #{@nWeapons}, Escudos: #{@nShields}, Hangares: #{@nHangars}, Medallas: #{@nMedals}\n"
    end

  end
end
