/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package deepspace;

import java.util.ArrayList;

/**
 *
 * @author JuanAntonio
 */
public class TestP4 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        SuppliesPackage sp=new SuppliesPackage(1,10,1);
        SpaceStation station = new SpaceStation("Juan",sp);
        //System.out.println(station.toString());
        
        //gameUniverse.init(nombres); Revienta porque CardDealer tiene errores
        //System.out.println(station.fire());
        //station = new PowerEfficientSpaceStation(station);
        //System.out.println(station.toString());        
        station.receiveHangar(new Hangar(3));
        station.receiveShieldBooster(new ShieldBooster("Escudo ACME",1.5f,2));
        station.receiveShieldBooster(new ShieldBooster("Escudo ACME",1.5f,2));
        station.receiveWeapon(new Weapon("Misil ACME",WeaponType.MISSILE,2));
        station.receiveWeapon(new Weapon("Cañón definitivo",WeaponType.PLASMA,100));
        station.mountShieldBooster(0);
        station.mountWeapon(0);
        
        station = new PowerEfficientSpaceStation(station);
        System.out.println(station.fire());
        System.out.println(station.protection());
        station = new BetaPowerEfficientSpaceStation(station);
        System.out.println(station.fire());
        System.out.println(station.protection());
        
        System.out.println(station.toString());
        
        ArrayList<SpaceStation> collaborators=new ArrayList<>();
        collaborators.add(station);
        SpaceStation station2=new SpaceStation("Pepe", sp);
        station2=new SpaceCity(station2, collaborators);
        System.out.println(station2.fire());
        System.out.println(station2.protection());
        
        System.out.println(station2.toString());
        
        ArrayList <WeaponType> wl=new ArrayList<>();
        wl.add(WeaponType.LASER);
        wl.add(WeaponType.MISSILE);
        wl.add(WeaponType.PLASMA);
        NumericDamage damage1=new NumericDamage(5, 4);
        SpecificDamage damage2=new SpecificDamage(wl, 4);
        
        System.out.println(damage1.toString());
        System.out.println(damage2.toString());
        
        System.out.println("===================================================================");
        
        Loot loot=new Loot(1,1,1,1,1,false, true);
        Loot loot2=new Loot(1,1,1,1,1,true, false);
        
        Transformation transformacion1=station.setLoot(loot);
        System.out.format("\n%s\n",transformacion1.toString());//No se trasforma=bien
        SpaceStation station3=new SpaceStation("Luis", sp);
        Transformation transformacion2=station3.setLoot(loot);
        System.out.format("\n%s\n",transformacion2.toString());//Se trasforma=bien, ya que el loot no transforma por si solo
        Transformation transformacion3=station3.setLoot(loot2);
        System.out.format("\n%s\n",transformacion3.toString());//Se trasforma=bien, ya que el loot no transforma por si solo
        Transformation transformacion4=station2.setLoot(loot);
        System.out.format("\n%s\n",transformacion4.toString());//No se trasforma=bien
        Transformation transformacion5=station2.setLoot(loot2);
        System.out.format("\n%s\n",transformacion5.toString());//No se trasforma=bien
        
        
        ArrayList<String> nombres=new ArrayList();
        nombres.add("Juan");
        nombres.add("Antonio");
        nombres.add("Pedro");
        GameUniverse gameUniverse = new GameUniverse();
        gameUniverse.init(nombres);
        gameUniverse.makeStationEfficient();
        //gameUniverse.createSpaceCity();
        System.out.format("\n%s\n",gameUniverse.toString());
        
    }
    
}
