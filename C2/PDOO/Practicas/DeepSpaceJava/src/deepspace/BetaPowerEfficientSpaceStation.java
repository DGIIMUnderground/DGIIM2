

package deepspace;

/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class BetaPowerEfficientSpaceStation extends PowerEfficientSpaceStation{
    
    private Dice dice;
    private static float EXTRAEFFICIENCY=1.2f;
    
    public BetaPowerEfficientSpaceStation(SpaceStation station){
        super(station);
        dice=new Dice();
    }
    
    @Override
    public float fire(){
        if(dice.extraEfficiency())
            return super.fire()*EXTRAEFFICIENCY;
        else
            return super.fire();
    }
    
    @Override
    public String toString(){
        return "BETA "+super.toString();
    }
    
}
