package deepspace;



/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class ShieldBooster implements Copyable <ShieldBooster>, CombatElement {
    private String name;
    private float boost;
    private int uses;
    
    public ShieldBooster(String new_name, float new_boost, int new_uses){
        name=new_name;
        boost=new_boost;
        uses=new_uses;
    }
    
    public ShieldBooster(ShieldBooster s){
        this.name=s.name;
        this.boost=s.boost;
        this.uses=s.uses;
    }
    
    public float getBoost(){
        return boost;
    }
    
    @Override
    public int getUses(){
        return uses;
    }
    
    ShieldToUI getUIversion(){
        return new ShieldToUI(this);
    }
    
    @Override
    public float useIt(){
        if(uses>0){
            uses--;
            return boost;
        }
        return (float) 1.0;
    }
    
    public ShieldBooster copy(){
        return new ShieldBooster(this);
    }
    
    @Override
    public String toString(){
        return "Nombre: "+this.name+" Potencia: "+this.getBoost()+" Usos: "+this.getUses()+"  ";
    }
}
