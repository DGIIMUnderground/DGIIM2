package deepspace;



/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public enum WeaponType {
    LASER(2.0f), MISSILE(3.0f), PLASMA(4.0f);
    
    private float Power;
    
    WeaponType (float power){
        this.Power=power;
    }
    
    float getPower(){
          return Power;
    }
    
}
