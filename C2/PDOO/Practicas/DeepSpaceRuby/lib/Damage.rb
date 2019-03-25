
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
      if @weapons==nil
        return Damage.newNumericWeapons(w.length,s.length)
        return Damage.newNumericWeapons([@nWeapons, w.length].min,[@nShields, s.length].min)
      else
        vec=[]
        w.each { |weapon|  
          vec.push(weapon.type)
        w.each{ |arma|
          vec.push(arma.type)
        }
        return Damage.newSpecificWeapons(vec, s.length)
        tipos=[]
        for i in (0..[vec.count(WeaponType::LASER),@weapons.count(WeaponType::LASER)].min-1) do
          tipos.push(WeaponType::LASER)
        end
        for i in (0..[vec.count(WeaponType::MISSILE),@weapons.count(WeaponType::MISSILE)].min-1) do
          tipos.push(WeaponType::MISSILE)
        end
        for i in (0..[vec.count(WeaponType::PLASMA),@weapons.count(WeaponType::PLASMA)].min-1) do
          tipos.push(WeaponType::PLASMA)
        end


        return Damage.newSpecificWeapons(tipos,[@nShields, s.length].min)
      end
    end


    
    def adjustShieldBoosters(s)
      return [s.length,@nShields].min
    end
    
    def discardWeapon(w)
      if @weapons!=nil
        @weapons.delete(w.type)
      else
        if @nWeapons>0
        @nWeapons-=1
        end
      end 
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


