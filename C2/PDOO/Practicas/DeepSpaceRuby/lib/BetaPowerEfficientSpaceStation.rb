
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8

require_relative "Dice"

module Deepspace
  class BetaPowerEfficientSpaceStation < PowerEfficientSpaceStation
    
    @@EXTRAEFFICIENCY=1.2
   
    def initialize(station)
      super
      @dice=Dice.new
    end
    
    def fire
      if @dice.extraEfficiency
        factor=super*@@EXTRAEFFICIENCY
        return factor
      else return super
      end
    end
    
    def to_s
      return "BETA "+super
    end
    
  end
  
end
