

package deepspace;

import java.util.ArrayList;
/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class Hangar implements Copyable <Hangar> {
    private int maxElements;
    private ArrayList<ShieldBooster> shieldBoosters=new ArrayList<>();
    private ArrayList<Weapon> weapons=new ArrayList<>();
    
    
    public Hangar(int capacity){
        maxElements=capacity;
    }
    
    public Hangar(Hangar h){
        weapons=h.weapons;
        shieldBoosters=h.shieldBoosters;
        maxElements=h.maxElements;
    }
    
    public HangarToUI getUIversion(){
        return new HangarToUI(this);
    }
    
    private boolean spaceAvailable(){
        
        return weapons.size()+shieldBoosters.size() < maxElements;
    }   
    
    public boolean addWeapon(Weapon w){
        if (this.spaceAvailable())
            return weapons.add(w);
        else return false;
    }
            
    public boolean addShieldBooster(ShieldBooster w){
        if (this.spaceAvailable())
            return shieldBoosters.add(w);
        else return false;
    }
    
    public int getMaxElements(){
        return maxElements;
    }
    
    public ArrayList<ShieldBooster> getShieldBoosters(){
        return shieldBoosters;
    }
    
    public ArrayList<Weapon> getWeapons(){
        return weapons;
    }
    
    public Weapon removeWeapon(int w){
        if (w>=weapons.size())
            return null;
        else{
            return weapons.remove(w);
        }
    }
    

    public ShieldBooster removeShieldBooster(int s){
        if (s>=shieldBoosters.size())
            return null;
        else{
            return shieldBoosters.remove(s);
        }
    }
        
    @Override
    public String toString(){
        String res="Esta instancia de la clase Hangar contiene las siguientes armas:\n "+weapons.toString()+
                "  \ny los siguientes potenciadores de escudo:\n"+shieldBoosters.toString()+"\ny puede almacenar "+maxElements+
                " elementos.\n";
        return res;
    }
    
    public Hangar copy(){
        return new Hangar(this);
    }
    
}
