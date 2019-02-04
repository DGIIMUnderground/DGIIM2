
package deepspace;

import java.util.ArrayList;
import java.util.Iterator;

/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public abstract class Damage {
    public int nShields;

    
    Damage(int s){
        this.nShields=s;
    }
    
    Damage(Damage d){
        this.nShields=d.nShields;
    }
    
    public int getNShields(){
        return this.nShields;
    }
    
    
    abstract public DamageToUI getUIversion();
    
    abstract public Damage adjust(ArrayList<Weapon> w, ArrayList<ShieldBooster> s);
        /*int minShields=nShields;
        if (nShields>s.size())
            minShields=s.size();
        
        if (!weapons.isEmpty()){
            ArrayList<WeaponType> tipos= new ArrayList<>();
            int laserWeapons=0, missileWeapons=0, plasmaWeapons=0;
            int laserW=0, missileW=0, plasmaW=0;
            int i;
            
            
            for (i=0; i<weapons.size(); i++){
                if (weapons.get(i)==WeaponType.LASER)
                    laserWeapons++;
                if (weapons.get(i)==WeaponType.MISSILE)
                    missileWeapons++;
                if (weapons.get(i)==WeaponType.PLASMA)
                    plasmaWeapons++;
            }
            
            for (i=0; i<w.size(); i++){
                if (w.get(i).getType()==WeaponType.LASER)
                    laserW++;
                if (w.get(i).getType()==WeaponType.MISSILE)
                    missileW++;
                if (w.get(i).getType()==WeaponType.PLASMA)
                    plasmaW++;
            }
            
            int minWeaponsLaser=laserWeapons;
            if(laserWeapons>laserW)
                minWeaponsLaser=laserW;
            
            int minWeaponsMissile=missileWeapons;
            if(missileWeapons>missileW)
                minWeaponsMissile=missileW;
            
            int minWeaponsPlasma=plasmaWeapons;
            if(plasmaWeapons>plasmaW)
                minWeaponsPlasma=laserW;
            
            for (i=0; i<minWeaponsLaser; i++) {
                tipos.add(WeaponType.LASER);
            }
            for (i=0; i<minWeaponsMissile; i++) {
                tipos.add(WeaponType.MISSILE);
            }
            for (i=0; i<minWeaponsPlasma; i++) {
                tipos.add(WeaponType.PLASMA);
            }
            return new Damage(tipos, minShields);
        }
        else {
            int minWeapons=nWeapons;
            if (nWeapons>w.size())
                minWeapons=w.size();
            
            return new Damage(minWeapons, minShields);
        }*/
    
    private int arrayContainsType(ArrayList<Weapon> w, WeaponType t){
        Iterator<Weapon> it=w.iterator();
        int i=0;
        Weapon waux=(Weapon) it;
        while(it.hasNext() && waux.getType() != t){
            it.next();
            waux=(Weapon) it;
            i++;
        }
        if (it.hasNext())
            return i;
        else
            return -1;
    }
    
    abstract public void discardWeapon(Weapon w);
    
    public void discardShieldBooster(){
        if (this.nShields>0)
            this.nShields--;      
    }
    
    abstract public boolean hasNoEffect();
    
    @Override
    public String toString(){
        String mensaje="El numero de escudos eliminados ha sido "+nShields;
        return mensaje;
    }
}