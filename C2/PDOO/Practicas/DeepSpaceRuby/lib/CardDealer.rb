#encoding:utf-8

require 'singleton'

require_relative 'CardDeck'
require_relative 'SuppliesPackage'
require_relative 'Weapon'
require_relative 'WeaponType'
require_relative 'ShieldBooster'
require_relative 'Hangar'
require_relative 'Loot'
require_relative 'NumericDamage'
require_relative 'SpecificDamage'
require_relative 'EnemyStarShip'

module Deepspace

# @author Profesor
    
class CardDealer 
    include Singleton
    
    def initialize ()
        @suppliesPackages=CardDeck.new()
        @shieldBoosters=CardDeck.new()
        @weapons=CardDeck.new()
        @hangars=CardDeck.new()
        @enemies=CardDeck.new()
        initCards()
    end
 
    public 
    
    def nextSuppliesPackage() 
        return @suppliesPackages.next()
    end
    
    def nextWeapon()
        return @weapons.next()          
    end
    
    def nextShieldBooster() 
        return @shieldBoosters.next()
    end
    
    def nextHangar() 
        return @hangars.next()
    end
    
    def nextEnemy() 
        return @enemies.next();
    end
    
    private
    
    def initCards() 
        createSuppliesPackages()
        createWeapons()
        createShieldBoosters()
        createHangars()
        createEnemies()      
    end
    
    def createSuppliesPackages() 
        @suppliesPackages.add(SuppliesPackage.new(1,10,1))
        @suppliesPackages.add(SuppliesPackage.new(1,10,1))
        @suppliesPackages.add(SuppliesPackage.new(1,10,1))
        @suppliesPackages.add(SuppliesPackage.new(2,10,2))
        @suppliesPackages.add(SuppliesPackage.new(2,10,2))
        @suppliesPackages.add(SuppliesPackage.new(2,10,2))
        @suppliesPackages.add(SuppliesPackage.new(2,30,1))
        @suppliesPackages.add(SuppliesPackage.new(1,30,2))
        @suppliesPackages.add(SuppliesPackage.new(3,0,1))
        @suppliesPackages.add(SuppliesPackage.new(1,0,3))
        @suppliesPackages.add(SuppliesPackage.new(3,50,3))  
        @suppliesPackages.add(SuppliesPackage.new(40,100,40))
        @suppliesPackages.add(SuppliesPackage.new(100,100,100))
    end
    
    def createWeapons() 
       @weapons.add(Weapon.new("Láser infinito",WeaponType::LASER,100))
       @weapons.add(Weapon.new("Láser ACME",WeaponType::LASER,1))
       @weapons.add(Weapon.new("Láser ACME",WeaponType::LASER,1))
       @weapons.add(Weapon.new("Láser ACME",WeaponType::LASER,1))
       @weapons.add(Weapon.new("Láser ACME",WeaponType::LASER,1))
       @weapons.add(Weapon.new("Láser ACME",WeaponType::LASER,1))
       @weapons.add(Weapon.new("Láser normal",WeaponType::LASER,2))
       @weapons.add(Weapon.new("Láser normal",WeaponType::LASER,2))
       @weapons.add(Weapon.new("Láser normal",WeaponType::LASER,2))
       @weapons.add(Weapon.new("Láser Mejorado",WeaponType::LASER,4))
       @weapons.add(Weapon.new("Láser Mejorado",WeaponType::LASER,4))
       
       @weapons.add(Weapon.new("Misiles del apocalipsis",WeaponType::MISSILE,100))
       @weapons.add(Weapon.new("Misil ACME",WeaponType::MISSILE,1))
       @weapons.add(Weapon.new("Misil ACME",WeaponType::MISSILE,1))
       @weapons.add(Weapon.new("Misil ACME",WeaponType::MISSILE,1))
       @weapons.add(Weapon.new("Misil normal",WeaponType::MISSILE,2))
       @weapons.add(Weapon.new("Misil normal",WeaponType::MISSILE,2))
       @weapons.add(Weapon.new("Misil mejorado",WeaponType::MISSILE,2))     
       
       @weapons.add(Weapon.new("Cañón definitivo",WeaponType::PLASMA,100))
       @weapons.add(Weapon.new("Cañón ACME",WeaponType::PLASMA,1)) 
       @weapons.add(Weapon.new("Cañón ACME",WeaponType::PLASMA,1)) 
       @weapons.add(Weapon.new("Cañón ACME",WeaponType::PLASMA,1)) 
       @weapons.add(Weapon.new("Cañón mejorado",WeaponType::PLASMA,2))       
       
    end
    
    def createShieldBoosters() 
       @shieldBoosters.add(ShieldBooster.new("El escudo infinito",2.0,100))
       @shieldBoosters.add(ShieldBooster.new("El escudo definitivo",10.0,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo ACME",1.5,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo ACME",1.5,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo ACME",1.5,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo ACME",1.5,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo ACME",1.5,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo ACME",1.5,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo ACME",1.5,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo normal",3.0,2))
       @shieldBoosters.add(ShieldBooster.new("Escudo normal",4.0,2))
    end
                               
    def createHangars() 
        @hangars.add(Hangar.new(4))
        @hangars.add(Hangar.new(4))
        @hangars.add(Hangar.new(3))
        @hangars.add(Hangar.new(3))
        @hangars.add(Hangar.new(3))    
        @hangars.add(Hangar.new(2))
        @hangars.add(Hangar.new(2))
        @hangars.add(Hangar.new(1))
        @hangars.add(Hangar.new(1))
    end
    
    def createEnemies() 
        regularLoot0=Loot.new(1,2,1,1,1)
        regularLoot1=Loot.new(1,1,2,1,1)
        badLoot=Loot.new(1,1,1,0,1)
        goodLoot=Loot.new(2,2,2,1,2)
        
        regularDamage0=NumericDamage.new(2,1) 
        regularDamage1=NumericDamage.new(1,1) 
        lowDamage0=NumericDamage.new(1,1)
        lowDamage1=NumericDamage.new(0,1)
        lowDamage2=NumericDamage.new(1,0)
        
        regularSpecificDamage0=SpecificDamage.new([WeaponType::LASER,WeaponType::MISSILE,WeaponType::PLASMA],1)
        hardSpecificDamage0=SpecificDamage.new([WeaponType::LASER,WeaponType::LASER,WeaponType::LASER, \
                                        WeaponType::MISSILE,WeaponType::MISSILE,WeaponType::MISSILE, \
                                        WeaponType::PLASMA,WeaponType::PLASMA,WeaponType::PLASMA],2)    
        softSpecificDamage0=SpecificDamage.new([WeaponType::LASER],1)  
        softSpecificDamage1=SpecificDamage.new([WeaponType::MISSILE],1)  
        softSpecificDamage2=SpecificDamage.new([WeaponType::PLASMA],1)  
        mediumSpecificDamage0=SpecificDamage.new([WeaponType::LASER,WeaponType::MISSILE],2)  
      
        @enemies.add(EnemyStarShip.new("Enemigo fácil -1",0,0,regularLoot0,lowDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo fácil -1",0,10,badLoot,lowDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo fácil -1",10,0,badLoot,lowDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 0",10,10,badLoot,lowDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 0",10,10,badLoot,lowDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 0",10,10,badLoot,lowDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 1",10,20,badLoot,lowDamage1));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 1",10,20,badLoot,lowDamage1));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 1",10,20,badLoot,lowDamage1));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 2",20,10,badLoot,lowDamage2));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 2",20,10,badLoot,lowDamage2));
        @enemies.add(EnemyStarShip.new("Enemigo fácil 2",20,20,badLoot,lowDamage2));        
        @enemies.add(EnemyStarShip.new("Enemigo fácil 3",50,50,badLoot,softSpecificDamage0)); 
        @enemies.add(EnemyStarShip.new("Enemigo fácil 4",50,50,badLoot,softSpecificDamage1)); 
        @enemies.add(EnemyStarShip.new("Enemigo fácil 5",30,30,badLoot,softSpecificDamage2));         
        
        @enemies.add(EnemyStarShip.new("Enemigo normal 0",100,100,regularLoot0,regularDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo normal 1",150,70,regularLoot1,regularDamage1));   
        @enemies.add(EnemyStarShip.new("Enemigo normal 2",100,100,regularLoot0,mediumSpecificDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo normal 3",150,90,regularLoot1,mediumSpecificDamage0));  
        @enemies.add(EnemyStarShip.new("Enemigo normal 3",150,70,regularLoot0,regularSpecificDamage0));   
        @enemies.add(EnemyStarShip.new("Enemigo normal 3",150,70,regularLoot0,regularSpecificDamage0));
        @enemies.add(EnemyStarShip.new("Enemigo normal 3",150,70,regularLoot0,regularSpecificDamage0));        
          
        @enemies.add(EnemyStarShip.new("Enemigo difícil 0",200,100,goodLoot,hardSpecificDamage0));          
        @enemies.add(EnemyStarShip.new("Enemigo difícil 1",100,200,goodLoot,hardSpecificDamage0));   
        
        @enemies.add(EnemyStarShip.new("Enemigo imposible",500,500,goodLoot,hardSpecificDamage0));   
        
        # Enemigos que transforman
        
        transformLoot0=Loot.new(1,1,1,0,1,true,false)
        transformLoot1=Loot.new(1,1,1,0,1,false,true)
        
        @enemies.add(EnemyStarShip.new("Enemigo transforma 0",200,100,transformLoot0,regularDamage0))
        @enemies.add(EnemyStarShip.new("Enemigo transforma 1",100,200,transformLoot1,regularDamage1))
    end
end # class

end # module

if $0 == __FILE__
   test=Deepspace::CardDealer.instance 
   puts test.nextSuppliesPackage().to_s
   puts test.nextShieldBooster().to_s
   puts test.nextWeapon().to_s
   puts test.nextHangar().to_s
   puts test.nextEnemy().to_s
end
