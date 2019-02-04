
package deepspace;
import java.util.ArrayList;
/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class NumericDamage extends Damage{
    private int nWeapons;
    
    NumericDamage(int w, int s){
        super(s);
        this.nWeapons=w;
    }
    
    NumericDamage(NumericDamage d){
        super(d);
        this.nWeapons=d.nWeapons;
    }
    
    public int getNWeapons(){
        return this.nWeapons;
    }
    
    @Override
    public NumericDamageToUI getUIversion(){
        return new NumericDamageToUI(this);
    }
    
    @Override
    public NumericDamage adjust(ArrayList<Weapon> w, ArrayList<ShieldBooster> s){
        int minShields=nShields;
        if (nShields>s.size())
            minShields=s.size();
        int minWeapons=nWeapons;
            if (nWeapons>w.size())
                minWeapons=w.size();
            
        return new NumericDamage(minWeapons, minShields);
    }
    
    @Override
    public void discardWeapon(Weapon w){
        if(this.nWeapons>0)
            this.nWeapons--;
    }
    
    @Override
    public boolean hasNoEffect(){
        return nShields==0 && nWeapons==0;
    }
    
    @Override
    public String toString(){
        String mensaje="El numero de escudos eliminados ha sido "+nShields+
                        " \ny el numero de armas eliminadas ha sido "+nWeapons;
        return mensaje;
    }
    
    
}
