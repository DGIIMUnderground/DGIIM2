#encoding:utf-8


require_relative "EnemyToUI"
require_relative "Damage"
require_relative "Loot"
require_relative "ShotResult"

module Deepspace
  class EnemyStarShip
    
    attr_reader :ammoPower, :name, :shieldPower, :loot, :damage
    public
    
    def initialize(n,a,s,l,d)
      @name=n
      @ammoPower=a
      @shieldPower=s
      @loot=l
      @damage=d
    end
    
    def self.newCopy(e)
      new(e.name,e.ammoPower,e.shieldPower,e.loot,e.damage)
    end
    
    def getUIversion
      return EnemyToUI.new(self)
    end
    
    def fire
      return @ammoPower
    end
    
    def protection
      return @shieldPower
    end
    
    def receiveShot(shot)
      if @shieldPower<shot
        return ShotResult::DONOTRESIST
      else
        return ShotResult::RESIST
      end
    end
    
    def to_s
      return "\nNombre: #{@name}, \nDano: "+@damage.to_s+"\nBotin: "+@loot.to_s+"\nEnergia del escudo: #{@shieldPower} \nPotencia de disparo: #{@ammoPower}\n\n"
    end
    
  end
end

