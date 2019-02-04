
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8
require_relative "Damage"
require_relative "NumericDamageToUI"

module Deepspace
  class NumericDamage < Damage

    public_class_method :new
    
    attr_reader :nWeapons
    
    def initialize(w,s)
      super(s)
      @nWeapons=w
    end
    
   @override
   def adjust(w,s)
     return NumericDamage.new([@nWeapons,w.length].min, adjustShieldBoosters(s))
   end
    
   def copy
     return NumericDamage.new(@nWeapons,@nShields)
   end
   
   @override
   def discardWeapon(w)
     if @nWeapons>0
      @nWeapons-=1 
     end
   end
   
   @override
   def hasNoEffect
      if @nWeapons==0
        return super
      end
      return false
   end
   
   def getUIversion
     return NumericDamageToUI.new(self)
   end
   
   @override
   def to_s
     return "Dano numerico: #{@nShields} escudos y #{@nWeapons} armas"
   end
   
    
  end
end
