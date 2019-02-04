
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8
require_relative "SuppliesPackage"
require_relative "Hangar"
require_relative "Damage"
require_relative "Weapon"
require_relative "WeaponType"
require_relative "Loot"
require_relative "ShieldBooster"
require_relative "CardDealer"
require_relative "SpaceStationToUI"
require_relative "Transformation"

module Deepspace
  class SpaceStation
    @@MAXFUEL=100
    @@SHIELDLOSSPERUNITSHOT=0.1
    
    attr_reader :name, :ammoPower, :fuelUnits,
      :nMedals, :shieldPower, :pendingDamage,
      :weapons, :shieldBoosters, :hangar
    
    
    def initialize(n,s)
      @name=n
      @ammoPower=s.ammoPower
      @nMedals=0
      @shieldPower=s.shieldPower
      @pendingDamage=nil
      @weapons=Array.new
      @shieldBoosters=Array.new
      @hangar=nil
      assignFuelValue(s.fuelUnits)
    end
    
    private
    def assignFuelValue(f)
      if f>@@MAXFUEL
        @fuelUnits=@@MAXFUEL
      else
        @fuelUnits=f
      end
    end
    
    def cleanPendingDamage
      @pendingDamage=nil if @pendingDamage.hasNoEffect
    end
    
    public
    
    def createStation(station)
      @name=station.name
      @ammoPower=station.ammoPower
      @nMedals=station.nMedals
      @shieldPower=station.shieldPower
      @pendingDamage=station.pendingDamage
      @weapons=station.weapons
      @shieldBoosters=station.shieldBoosters
      @hangar=station.hangar
      assignFuelValue(station.fuelUnits)
    end
    
    def getUIversion
      return SpaceStationToUI.new(self)
    end
    
    def cleanUpMountedItems
      aux=[]
      @weapons.each { |arma|
        if arma.uses==0
          aux.push(arma)
        end
      }
      aux.each { |obj| @weapons.delete(obj)  }
      aux=[]
      @shieldBoosters.each{ |potenciador|
        if potenciador.uses==0
          aux.push(potenciador)
        end
      }
      aux.each { |obj| @shieldBoosters.delete(obj)}
    end
    
    def getSpeed
      return @fuelUnits.to_f/@@MAXFUEL.to_f
    end
    
    def discardHangar
      @hangar=nil
    end
    
    def discardShieldBooster(i)
      if i>=0 && i<@shieldBoosters.length
        s=@shieldBoosters.delete_at(i)
        if @pendingDamage!=nil
          @pendingDamage.discardShieldBooster
          cleanPendingDamage
        end
      end
    end
    
    def discardShieldBoosterInHangar(i)
      if @hangar!=nil
        @hangar.removeShieldBooster(i)
      end
    end
    
    def discardWeapon(i)
      if i>=0 && i<@weapons.length
        w=@weapons.delete_at(i)
        if @pendingDamage!=nil
          @pendingDamage.discardWeapon(w)
          cleanPendingDamage
        end
      end
    end
    
    def discardWeaponInHangar(i)
      if @hangar!=nil
        @hangar.removeWeapon(i)
      end
    end
    
    def mountShieldBooster(i)
      if @hangar!=nil
        aux=@hangar.shieldBoosters[i]
        @hangar.shieldBoosters.delete_at(i)
        if aux!=nil
          @shieldBoosters.push(aux)
        end
      end
    end
    
    def mountWeapon(i)
      if @hangar!=nil
        aux=@hangar.weapons[i]
        @hangar.weapons.delete_at(i)
        if aux!=nil
          @weapons.push(aux)
        end
      end
    end
    
    def move
      @fuelUnits=@fuelUnits-(@fuelUnits*getSpeed)
      if @fuelUnits<0
        @fuelUnits=0
      end
    end
    
    def protection
      factor=1
      if !@shieldBoosters.empty?
        for i in 0..@shieldBoosters.length-1
          s=@shieldBoosters.at(i)
          factor=factor*s.useIt  
        end
      end
      return @shieldPower*factor
    end
    
    def receiveHangar(h)
      if @hangar==nil
        @hangar=h
      end
    end
    
    def receiveShieldBooster(s)
      if @hangar==nil
        return false
      else
        return @hangar.addShieldBooster(s)
      end
    end
    
    def fire
      factor=1
      if !@weapons.empty?
        for i in 0..@weapons.length-1
          w=@weapons.at(i)
          factor=factor*w.useIt
        end
      end
      factor=factor*@ammoPower
      return factor
    end
    
    def receiveShot(shot)
      myProtection=protection
      if myProtection>=shot
        @shieldPower=@shieldPower-@@SHIELDLOSSPERUNITSHOT*shot
        @shieldPower=[0.0, @shieldPower].max
        return ShotResult::RESIST
      else
        return ShotResult::DONOTRESIST
      end  
    end
    
    def receiveSupplies(s)
      @ammoPower=@ammoPower+s.ammoPower
      @shieldPower=@shieldPower+s.shieldPower
      if(@fuelUnits+s.fuelUnits>@@MAXFUEL)
        @fuelUnits=@@MAXFUEL
      else
        @fuelUnits=@fuelUnits+s.fuelUnits
      end
    end
    
    def receiveWeapon(w)
      if @hangar==nil
        return false
      else
        return @hangar.addWeapon(w)
      end
    end
    
    def setLoot(loot)
      dealer=CardDealer.instance
      
      h=loot.nHangars
      if h>0
        hangar=dealer.nextHangar
        receiveHangar(hangar)
      end
      
      elements=loot.nSupplies
      for i in 1..elements
        sup=dealer.nextSuppliesPackage
        receiveSupplies(sup)
      end
      
      elements=loot.nWeapons
      for j in 1..elements
        weap=dealer.nextWeapon
        receiveWeapon(weap)
      end
      
      elements=loot.nShields
      for k in 1..elements
        sh=dealer.nextShieldBooster
        receiveShieldBooster(sh)
      end
      
      medals=loot.nMedals
      @nMedals+=medals
      
      if loot.efficient
        return Transformation::GETEFFICIENT
      elsif loot.spaceCity
        return Transformation::SPACECITY
      else
        return Transformation::NOTRANSFORM
      end
      
    end
    
    def setPendingDamage(d)
      @pendingDamage=d.adjust(@weapons, @shieldBoosters)
    end
    
    def validState
      return @pendingDamage==nil || @pendingDamage.hasNoEffect
    end
    
    def to_s
      cad= "\n*Potencia de disparo: #{@ammoPower}\n*Potencia de escudo: #{@shieldPower}\n"+
        "*#{@fuelUnits} Unidades de combustible\n*"+
        "#{@nMedals} medallas\nNombre: #{@name}"+"\nARMAS:\n"
        @weapons.each{ |arma|
        cad+=arma.to_s
      }
      cad+="\nPOTENCIADORES DE ESCUDO:\n"
        @shieldBoosters.each{ |potenciador|
        cad+=potenciador.to_s
      }
      cad+="\nDano pendiente:"+@pendingDamage.to_s+"\nHangar: \n"
      if(@hangar!=nil)
        cad+=@hangar.to_s
      else
        cad+="No tiene\n"
      end
      return cad
    end
    
  end
end
