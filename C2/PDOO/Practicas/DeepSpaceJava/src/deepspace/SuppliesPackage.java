package deepspace;



/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class SuppliesPackage implements Copyable <SuppliesPackage> {
    private float ammoPower=0;
    private float fuelUnits=0;
    private float shieldPower=0;
    
    public SuppliesPackage(float new_ammoPower, float new_fuelUnits,
                           float new_shieldPower){
        ammoPower=new_ammoPower;
        fuelUnits=new_fuelUnits;
        shieldPower=new_shieldPower;
    }
    
    public SuppliesPackage(SuppliesPackage s){
        this.ammoPower=s.ammoPower;
        this.fuelUnits=s.fuelUnits;
        this.shieldPower=s.shieldPower;
    }
    
    public float getAmmoPower(){
        return ammoPower;
    }
    
    public float getFuelUnits(){
        return fuelUnits;
    }
    
    public float getShieldPower(){
        return shieldPower;
    }
    
    public String toString(){
        String mensaje;
        mensaje = "La potencia del arma obtenida es "+this.getAmmoPower()+
                " el potenciador del escudo obtenido es "+this.getShieldPower()+
                " y las unidades de combustible obtenidas son "+this.getFuelUnits();
        return mensaje;
    }
    
    public SuppliesPackage copy(){
        return new SuppliesPackage(this);
    }
}
