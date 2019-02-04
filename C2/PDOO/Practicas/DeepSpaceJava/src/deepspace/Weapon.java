package deepspace;



/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class Weapon implements Copyable <Weapon>, CombatElement {
    private String name;
    private WeaponType type;
    private int uses;
    
    public Weapon(String new_name, WeaponType new_type, int new_uses ){
        name=new_name;
        type=new_type;
        uses=new_uses;
    }
    
    public Weapon(Weapon s){
        name=s.name;
        type=s.type;
        uses=s.uses;
    }
    
    public WeaponType getType(){
        return type;
    }
    
    @Override
    public int getUses(){
        return uses;
    }
    
    public float power(){
        return type.getPower();
    }
    
    WeaponToUI getUIversion(){
        return new WeaponToUI(this);
    }
    
    @Override
    public float useIt(){
        if(uses>0){
            uses--;
            return power();
        }
        else{
            return 1.0f;
        }
    }
    
    WeaponToUI getUIVersion(){
        return new WeaponToUI(this);
    }
    
    public Weapon copy(){
        return new Weapon(this);
    }
    
     public String toString(){
        return "Nombre: "+this.name+" Tipo: "+this.getType()+"("+power()+") Usos: "+this.getUses()+"  ";
    }
}
