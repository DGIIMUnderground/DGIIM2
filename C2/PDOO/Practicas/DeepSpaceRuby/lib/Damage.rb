
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8

require_relative "WeaponType"
require_relative "Weapon"
require_relative "DamageToUI"

module Deepspace
  
  class Damage
    
    attr_reader :nShields
    
    def initialize(s)
      @nShields=s
    end
    
    public  
    def getUIversion
      return DamageToUI.new(self)
    end
    
    def adjust(w,s)
	#Mirad en NumericDamage.rb y SpecificDamage.rb

    end


    
    def adjustShieldBoosters(s)
      return [s.length,@nShields].min
    end
    
    def discardWeapon(w)
    end
    
    def discardShieldBooster
      if @nShields>0
        @nShields=@nShields-1
      end
    end
    
    def hasNoEffect
      return @nShields==0
    end
    
    private_class_method :new
  end
  
end


