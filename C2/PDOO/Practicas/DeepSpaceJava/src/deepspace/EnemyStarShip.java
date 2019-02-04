
package deepspace;

/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class EnemyStarShip implements Copyable <EnemyStarShip>, SpaceFighter {
    private float ammoPower;
    private String name;
    private float shieldPower;
    private Damage damage;
    private Loot loot;
    
    EnemyStarShip(String n, float a, float s, Loot l, Damage d){
        this.ammoPower=a;
        this.name=n;
        this.shieldPower=s;
        this.loot=l;
        this.damage=d;
    }
    
    EnemyStarShip(EnemyStarShip s){
        this.ammoPower=s.ammoPower;
        this.name=s.name;
        this.shieldPower=s.shieldPower;
        this.loot=s.loot;
        this.damage=s.damage;
    }
    
    public String getName() {
        return this.name;
    }

    public float getAmmoPower() {
        return this.ammoPower;
    }

    public float getShieldPower() {
        return this.shieldPower;
    }

    public Loot getLoot() {
        return this.loot;
    }

    public Damage getDamage() {
        return this.damage;
    }
    
    
    public EnemyToUI getUIversion(){
        return new EnemyToUI(this);
    }
    
    @Override
    public float fire(){
        return this.ammoPower;
    }
    
    @Override
    public float protection(){
        return this.shieldPower;
    }
    
    @Override
    public ShotResult receiveShot(float shot){
        if(this.shieldPower<shot)
            return ShotResult.DONOTRESIST;
        else return ShotResult.RESIST;
    }
    
    @Override
    public String toString(){
        String mensaje="El nombre de esta nave enemiga es:"+name+
                        ",\nel poder del arma de esa nave enemiga es:"+ammoPower+
                        ",\nel poder del escudo es: "+shieldPower+
                        ",\nel botin que contiene es:"+loot.toString()+
                        ",\ny el daño es:"+damage.toString();
        return mensaje;
    }
    
    @Override
    public EnemyStarShip copy(){
        return new EnemyStarShip(this);
    }
}
