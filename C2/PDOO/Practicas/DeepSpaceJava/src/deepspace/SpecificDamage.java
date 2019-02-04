
package deepspace;

import java.util.ArrayList;

/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class SpecificDamage extends Damage{
    private ArrayList<WeaponType> weapons=new ArrayList<>();
    
    SpecificDamage(ArrayList<WeaponType> wl, int s){
        super(s);
        this.weapons=wl;
    }
    
    SpecificDamage(SpecificDamage d){
        super(d);
        this.weapons=d.weapons;
    }

    @Override
    public SpecificDamageToUI getUIversion() {
        return new SpecificDamageToUI(this);
    }
    
    public ArrayList<WeaponType> getWeapons(){
        return this.weapons;
    }

    @Override
    public SpecificDamage adjust(ArrayList<Weapon> w, ArrayList<ShieldBooster> s) {
        int minShields=nShields;
        if (nShields>s.size())
            minShields=s.size();
        
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
            return new SpecificDamage(tipos, minShields);
    }

    @Override
    public void discardWeapon(Weapon w) {
       int i=0;
       while(i<this.weapons.size()){
                if (this.weapons.get(i)==w.getType()){
                    this.weapons.remove(i);
                }
                else
                    i++;
            }
    }

    @Override
    public boolean hasNoEffect() {
        return nShields==0 && weapons.isEmpty();
    }
    
    @Override
    public String toString(){
        String mensaje="El numero de escudos eliminados ha sido "+nShields+
                       "\ny los tipos de armas eliminadas han sido "+weapons;
        return mensaje;
    }

}
