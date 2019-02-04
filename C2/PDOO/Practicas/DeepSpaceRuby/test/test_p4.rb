#encoding:utf-8

# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "SpecificDamage"
require_relative "Damage"
require_relative "Hangar"
require_relative "Weapon"
require_relative "GameUniverse"
require_relative "EnemyStarShip"
require_relative "SpaceStation"
require_relative "SpaceCity"

module Deepspace
  class TestP4
    def self.main     
      weapons=[]
      #weapons.push(Weapon.new("Láser infinito",WeaponType::LASER,100))
      #weapons.push(Weapon.new("Láser ACME",WeaponType::LASER,1))
      weapons.push(Weapon.new("Láser ACME",WeaponType::LASER,1))
      #weapons.push(Weapon.new("Misil ACME",WeaponType::MISSILE,1))
      weapons.push(Weapon.new("Cañón ACME",WeaponType::PLASMA,1)) 
      
      shieldBoosters=[]
      shieldBoosters.push(ShieldBooster.new("El escudo infinito",2.0,100))
      #shieldBoosters.push(ShieldBooster.new("El escudo definitivo",10.0,2))
      shieldBoosters.push(ShieldBooster.new("Escudo ACME",1.5,2))
      
      
      damage=SpecificDamage.new([WeaponType::LASER,WeaponType::MISSILE,WeaponType::MISSILE,WeaponType::MISSILE,WeaponType::PLASMA],4)
      
      puts damage.to_s
      damage=damage.adjust(weapons, shieldBoosters)
      puts damage.to_s
      
      #damage1=damage1.adjust(weapons, shieldBoosters)
      #puts damage2.to_s
      
      suppliesPackages=[]
      suppliesPackages.push(SuppliesPackage.new(1,30,2))
      suppliesPackages.push(SuppliesPackage.new(3,0,1))
      suppliesPackages.push(SuppliesPackage.new(1,0,3))
      
      collaborators=[]
      collaborators.push(SpaceStation.new("Juan",suppliesPackages[0]))
      collaborators.push(SpaceStation.new("Antonio",suppliesPackages[1]))

      
    

      
      transformLoot1=Loot.new(1,1,1,1,1,true,false)
=begin      
      collaborators.each{ |estacion|
        estacion.setLoot(goodLoot)
      }
      base.setLoot(transformLoot1)
      city=SpaceCity.new(base,collaborators)
      puts city.to_s
      city.mountWeapon(0)
      city.mountShieldBooster(0)
      puts city.fire
      puts city.protection
      
=end      puts city.to_s    
      gameUniverse=GameUniverse.new
      nombres=["Juan", "Antonio"]
      gameUniverse.init(nombres)
      #puts gameUniverse.to_s
      #gameUniverse.createSpaceCity
      #puts gameUniverse.to_s
     
=begin      transformLoot0=Loot.new(1,1,1,0,1,true,false)
      base=SpaceStation.new("BASE",suppliesPackages[2])
      if base.setLoot(transformLoot0)==Transformation::GETEFFICIENT
        base=BetaPowerEfficientSpaceStation.new(base)
      end
      puts base.to_s
=end
      
      enemy=EnemyStarShip.new("Malo",1,2,transformLoot1, NumericDamage.new(1,1))
      station=SpaceStation.new("Juan", SuppliesPackage.new(500,50,500))
      
      puts gameUniverse.combatGo(station, enemy)
      puts gameUniverse.to_s
      
      
    end
    
    
    
  end
  
TestP4.main  
 
end
