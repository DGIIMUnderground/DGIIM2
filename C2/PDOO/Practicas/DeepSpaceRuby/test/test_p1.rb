#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8
require 'loot.rb'
require 'supplies_package.rb'
require 'shield_booster.rb'
require 'weapon.rb'
require 'weapon_type.rb'
require 'combat_result.rb'
require 'dice.rb'
require 'game_character.rb'
require 'shot_result'

module Deepspace

  class TestP1
    
    def initialize

    end
    
    def self.main
      
      puts "PRUEBA: \n"
      
      i=0
      #LOOT:
      while i<3
        botin=Loot.new(i,i,i,i,i)
        print "\nBotin ",i+1
        print "\n  Numero de suministros: ", botin.nSupplies
        print "\n  Numero de armas: ", botin.nWeapons
        print "\n  Numero de escudos: ", botin.nShields
        print "\n  Numero de hangares: ", botin.nHangars
        print "\n  Numero de medallas: ", botin.nMedals
        
        i+=1
      end
      
      print"\n"
      i=0  
      
      #SUPPLIES PACKAGE:
      while i<3
        paquete=DeepSpace::SuppliesPackage.new(i,i,i)
        print "\nPaquete de suministros ",i+1
        print "\n  Municion: ", paquete.ammoPower
        print "\n  Combustible: ", paquete.fuelUnits
        print "\n  Escudo: ", paquete.shieldPower
        
        i+=1
      end
        
      i=0
      
      #SHIELD BOOSTER
      while i<3
        mejora=DeepSpace::ShieldBooster.new("escudo_de_titanio",i,i)
        print "\n\nMejora de Escudo ",i+1
        print "\n  Mejora: ", mejora.boost
        print "\n  Usos: ", mejora.uses

            #Prueba de useIt()
        print "\nPrueba del metodo useIt()"
        print "\nPrimera vez: ", mejora.useIt()
        print "\nSegunda vez: ", mejora.useIt()
        
        i+=1
      end
        
      
      #WEAPON
      arma1=DeepSpace::Weapon.new("canon", DeepSpace::WeaponType::LASER, 0 )
      arma2=DeepSpace::Weapon.new("bazooka", DeepSpace::WeaponType::MISSILE, 1 )
      arma3=DeepSpace::Weapon.new("plasma", DeepSpace::WeaponType::PLASMA, 2 )
      puts "\n\nArma 1"
      print "  Tipo: "
        if arma1.type==WeaponType::LASER
          print "LASER"
        end
        if arma1.type==WeaponType::MISSILE
          print "MISSILE"
        end
        if arma1.type==WeaponType::PLASMA
          print "PLASMA"
        end
      print "\n  Usos: ", arma1.uses
      print "\n  Potencia de disparo: ", arma1.power

          #Prueba de useIt()
      print "\nPrueba del metodo useIt()"
      print "\nPrimera vez: ", arma1.useIt()
      print "\nSegunda vez: ", arma1.useIt()
      
      puts "\n\nArma 2"
      print "  Tipo: "
        if arma2.type==WeaponType::LASER
          print "LASER"
        end
        if arma2.type==WeaponType::MISSILE
          print "MISSILE"
        end
        if arma2.type==WeaponType::PLASMA
          print "PLASMA"
        end
      print "\n  Usos: ", arma2.uses
      print "\n  Potencia de disparo: ", arma2.power

          #Prueba de useIt()
      print "\nPrueba del metodo useIt()"
      print "\nPrimera vez: ", arma2.useIt()
      print "\nSegunda vez: ", arma2.useIt()
      
      puts "\n\nArma 3"
      print "  Tipo: "
        if arma3.type==WeaponType::LASER
          print "LASER"
        end
        if arma3.type==WeaponType::MISSILE
          print "MISSILE"
        end
        if arma3.type==WeaponType::PLASMA
          print "PLASMA"
        end
      print "\n  Usos: ", arma3.uses
      print "\n  Potencia de disparo: ", arma3.power

          #Prueba de useIt()
      print "\nPrueba del metodo useIt()"
      print "\nPrimera vez: ", arma3.useIt()
      print "\nSegunda vez: ", arma3.useIt()    
      
        
      #DICE
      puts "\n\nDice:"
      puts "  Prueba de las probabilidades:"
      dado=Dice.new
      hangars=0
      weapons=0
      shields=0
      who_starts=0
      first_shot=0
      move=0
      
      100.times do
        if dado.initWithNHangars==0
          hangars+=1
        end
        if dado.initWithNWeapons==1
          weapons+=1
        end
        if dado.initWithNShield==0
          shields+=1
        end
        if dado.WhoStarts(5)==0
          who_starts+=1
        end
        if dado.firstShot==GameCharacter::SPACESTATION
          first_shot+=1
        end
        if dado.spaceStationMoves(0.75)
          move+=1
        end

      end
      
      hangars/=100.0
      weapons/=100.0
      shields/=100.0
      who_starts/=100.0
      first_shot/=100.0
      move/=100.0
      
      print "  Resultados estadisticos:\n"
      print "    NHANGARSPROB: ",hangars
      print "\n    NWEAPONSPROB: ",weapons
      print "\n    NSHIELDSPROB: ",shields
      print "\n    FIRSTSHOTPROB: ",first_shot
      print "\n    WHO STARTS*: ", who_starts
      print "\n    SPEED**: ", move
    
      print "\n\n* El resultado esperado es 1/nPlayers, valor que se puede cambiar en la invocacion a dado.WhoStarts(nPlayers)\n"
      print "** El valor de SPEED depende del argumento que se le pase a dado.spaceStationMoves(speed), debe ser un numero entre 0 y 1\n"
      
    end  
    
    
  end

  TestP1.main
  
  
  
  
end


