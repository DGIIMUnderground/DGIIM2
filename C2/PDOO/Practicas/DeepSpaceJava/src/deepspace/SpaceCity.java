
package deepspace;

import java.util.ArrayList;

/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class SpaceCity extends SpaceStation{
    private SpaceStation base;
    private ArrayList<SpaceStation> collaborators=new ArrayList<>();
    
    SpaceCity(SpaceStation b, ArrayList<SpaceStation> col){
        super(b);
        this.base=b;
        this.collaborators=col;
    }
    
    @Override
    public float fire(){
        float factor=base.fire();
        for(int i=0; i<collaborators.size(); i++){
            factor=factor+collaborators.get(i).fire();
        }
        return factor;
    }
    
    public ArrayList<SpaceStation> getCollaborators(){
        return collaborators;
    }
    
    @Override
    public float protection(){
        float factor=base.protection();
        for(int i=0; i<collaborators.size(); i++){
            factor=factor+collaborators.get(i).protection();
        }
        return factor;
    }
    
    @Override
    public Transformation setLoot(Loot loot){
        base.setLoot(loot);
        return Transformation.NOTRANSFORM;
    }
    
    @Override
    public String toString(){
        String cad="CIUDAD ESPACIAL:\nESTACION BASE:"+base.toString()+"\nCOLABORADORES:";
        for(int i=0; i<collaborators.size(); i++){
            cad+=collaborators.get(i).toString();
        }
        return cad;
    }
}
