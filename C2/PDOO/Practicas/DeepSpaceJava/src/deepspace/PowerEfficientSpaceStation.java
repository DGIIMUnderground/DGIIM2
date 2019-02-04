

package deepspace;

/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class PowerEfficientSpaceStation extends SpaceStation{
    
    private static float EFFICIENCYFACTOR=1.10f;
    
    PowerEfficientSpaceStation(SpaceStation station){
        super(station);
    }
    @Override
    public float fire(){
        return super.fire()*EFFICIENCYFACTOR;
    }
    
    @Override
    public float protection(){
        return super.protection()*EFFICIENCYFACTOR;
    }
    
    @Override
    public Transformation setLoot(Loot loot){
        super.setLoot(loot);
        if (loot.getEfficient())
            return Transformation.GETEFFICIENT;
        else
            return Transformation.NOTRANSFORM;
    }

    @Override
    public String toString() {
        return "POWER EFFICIENT SPACE STATION:\n"+super.toString();
    }
}
