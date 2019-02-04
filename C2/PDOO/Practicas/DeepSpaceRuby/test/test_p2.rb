#encoding:utf-8

require_relative "Damage"
require_relative "Hangar"
require_relative "Weapon"
require_relative "GameUniverse"
require_relative "EnemyStarShip"
require_relative "SpaceStation"


module Deepspace
  class Test_P2
    def main
      
      puts "Prueba de las clases implementadas en la segunda practica\n"
      
      puts "Prueba de Hangar: "
      hangar1=Hangar.new(5)
      arma1=Weapon.new("Pistola",WeaponType::PLASMA,2)
      arma2=Weapon.new("Cannon",WeaponType::LASER,0)
      arma3=Weapon.new("Misil",WeaponType::MISSILE,5)
      potenciador1=ShieldBooster.new("Pinchos",4,1)
      potenciador2=ShieldBooster.new("Recubrimiento",5,5)
      potenciador3=ShieldBooster.new("Hierro",2,4)
      
      hangar1.addWeapon(arma1)
      hangar1.addShieldBooster(potenciador1)
      hangar1.addWeapon(arma2)
      hangar1.addShieldBooster(potenciador2)
      hangar1.addWeapon(arma3)
      hangar1.addShieldBooster(potenciador3)
      
      puts hangar1.to_s
      
      #puts"\n\nConstruimos una copia y le eliminamos algunos items:"
      
      hangar2=Hangar.newCopy(hangar1)
      hangar2.removeShieldBooster(1)
      hangar2.removeWeapon(2)
      
      #puts hangar2.to_s
      
      puts "\n\nPrueba de Damage\n"
      damage1=Damage.newNumericWeapons(5,4)#0 armas y 4 escudos
      wl=[WeaponType::PLASMA,WeaponType::MISSILE,WeaponType::PLASMA]
      damage2=Damage.newSpecificWeapons(wl,2)#Vector de tipos y 2 escudos
      
      puts damage1.to_s
      puts damage2.to_s

      damage3=damage1.adjust(hangar1.weapons, hangar1.shieldBoosters)
      puts "\ndamage1 ajustado:\n"
      puts damage3.to_s
      #damage3=damage2.adjust(hangar1.weapons, hangar1.shieldBoosters)
      puts "\ndamage2 ajustado:\n"
      puts damage3.to_s
      
      damage1.discardWeapon(arma1)
      #damage2.discardWeapon(arma1)#Si se cambia por arma3 no hace nada
      damage1.discardShieldBooster
      #damage2.discardShieldBooster
      #puts"damage1 y damage2 tras algunos descartes:"
      #puts damage1.to_s
      #puts damage2.to_s
      
      #puts"\nPrueba de hasNoEffect:"
      damagenull=Damage.newSpecificWeapons([],0)
      if(damagenull.hasNoEffect)
        #puts"Funciona"
      end
      damagenull=Damage.newNumericWeapons(0,0)
      if(damagenull.hasNoEffect)
         #puts"Tambien Funciona"
      end
      if(!damage1.hasNoEffect)
        #puts"Sigue funcionando"
      end
      if(!damage2.hasNoEffect)
        #puts"Definitivamente funciona"
      end
      
      puts "\n\nPrueba de EnemyStarShip"
      
      loot=Loot.new(3,2,4,2,7) #3 suplementos, 2 armas, 4 escudos, 2 hangares, 7 medallas
      enemyStarShip=EnemyStarShip.new("HalconMilenario",30,25,loot,damage2)
      #puts enemyStarShip.to_s
      
      #puts"Prueba de fire: #{enemyStarShip.fire}, Prueba de protection: #{enemyStarShip.protection}"
      #puts"\nPrueba de receiveShot"
      if(enemyStarShip.receiveShot(30)==ShotResult::RESIST)
       # puts"No funciona"
      elsif(enemyStarShip.receiveShot(20)==ShotResult::RESIST && enemyStarShip.receiveShot(30)==ShotResult::DONOTRESIST)
       # puts"Funciona"
      end
      
      puts"\n\nPrueba de SpaceStation"
      suppliesPackage=SuppliesPackage.new(30,150,25)
      suppliesPackage1=SuppliesPackage.new(2,20,17)
      suppliesPackage2=SuppliesPackage.new(3,3,3)
      
      spaceStation=SpaceStation.new("Skylab",suppliesPackage)
      
      spaceStation.setPendingDamage(damage1)
      spaceStation.receiveHangar(hangar1)
      #puts spaceStation.to_s
      spaceStation.move
      spaceStation.receiveSupplies(suppliesPackage1)
      spaceStation.move
      #puts spaceStation.to_s
      if(spaceStation.validState)
        #puts"\nLa estacion esta bien"
      end
      
      arma4=Weapon.new("Bazooka",WeaponType::MISSILE,5)
      potenciador3=ShieldBooster.new("CapaExtra",5,7)
      if spaceStation.receiveWeapon(arma4)
        puts"Algo falla"
      end
      spaceStation.mountWeapon(0)
      spaceStation.mountWeapon(0)
      spaceStation.mountWeapon(0)
      spaceStation.mountShieldBooster(0)
      spaceStation.mountShieldBooster(0)
      #puts"\n\nDespues de montarlo todo:\n"
      #puts spaceStation.to_s
      if(spaceStation.receiveShieldBooster(potenciador3) && spaceStation.receiveWeapon(arma4))
        #puts"\n\nDespues de anadir un potenciador y un arma\n"
        #puts spaceStation.to_s
        spaceStation.discardWeaponInHangar(0)
        spaceStation.discardShieldBoosterInHangar(0)
        #puts"\n\nDespues de unos descartes en el hangar:\n"
        #puts spaceStation.to_s
      end
      
      spaceStation.weapons.at(0).useIt
      spaceStation.weapons.at(0).useIt
      spaceStation.shieldBoosters.at(0).useIt
      spaceStation.cleanUpMountedItems
      #puts"\n\nDespues de unos usos y una limpieza:"
      
      #spaceStation.discardHangar
      
      #puts spaceStation.to_s
      
      loot=Loot.new(2,2,0,1,2)
      spaceStation.setLoot(loot)
      #puts spaceStation.to_s
      puts "AmmoPower: #{spaceStation.ammoPower}"
      puts "\n FUEGOOOO #{spaceStation.fire}"
      puts "\n PROTECCIOOON #{spaceStation.protection}"
      #puts spaceStation.to_s
      spaceStation.mountShieldBooster(0)
      spaceStation.mountWeapon(0)
      spaceStation.setPendingDamage(Damage.newSpecificWeapons([WeaponType::PLASMA, WeaponType::LASER, WeaponType::MISSILE], 3))
      #puts spaceStation.to_s
      spaceStation.discardShieldBooster(0)
      spaceStation.discardWeapon(0)
      puts spaceStation.to_s
      puts spaceStation.receiveShot(10)
      
      
      puts "===================================================================="
      puts "\nPrueba de GameUniverse"
      gameUniverse=GameUniverse.new
      nombres=["Carlos","Juan"]
      gameUniverse.init(nombres)
      puts gameUniverse.to_s
      
      enemyStarShip2=EnemyStarShip.new("DeadStar",999,998,loot,damage2)
      enemyStarShip3=EnemyStarShip.new("Patata",0.1,1,loot,damage2)
      spaceStation2=SpaceStation.new("Chetada",suppliesPackage2)
      result=gameUniverse.combatGo(spaceStation2,enemyStarShip2)
      puts result
      puts damage2.getUIversion.to_s
      puts "===================================================================="
      #puts gameUniverse.to_s
      if gameUniverse.nextTurn
        puts "TURNO SIGUIENTE"
      else
        puts "MISMO TURNO"
      end

    end
  end
  
  p = Test_P2.new
  p.main
end
