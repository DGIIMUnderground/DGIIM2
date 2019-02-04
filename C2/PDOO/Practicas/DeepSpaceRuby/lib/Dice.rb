
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8

require_relative 'GameCharacter.rb'

module Deepspace
  class Dice
    
    public
    
    def initialize
      @NHANGARSPROB = 0.25;
      @NSHIELDSPROB = 0.25;
      @NWEAPONSPROB = 0.33;
      @FIRSTSHOTPROB = 0.5;
      @EXTRAEFFICIENCYPROB = 0.8;
    end
    
    def initWithNHangars
      prob = rand
      if prob < @NHANGARSPROB
        return 0
      else
        return 1
      end
    end
    
     def initWithNWeapons
       prob = rand
       if prob < @NWEAPONSPROB
        return 1
      else
        if prob < 2*@NWEAPONSPROB
          return 2
        else 
          return 3
        end
      end
    end
    
    def initWithNShield
      prob = rand
      if prob < @NSHIELDSPROB
        return 0
      else
        return 1
      end
    end
    
    def extraEfficiency
      prob = rand
      if prob < @EXTRAEFFICIENCYPROB
        return false
      else
        return true
      end
    end
    
    def whoStarts(new_nPlayers)
      player = rand(new_nPlayers)
      return player
    end
    
    def firstShot
      prob = rand
      if prob < @FIRSTSHOTPROB
        return GameCharacter::SPACESTATION
      else
        return GameCharacter::ENEMYSTARSHIP
      end
    end
    
    def spaceStationMoves(new_speed)
      prob = rand
      return prob < new_speed
    end
    
  end
end
