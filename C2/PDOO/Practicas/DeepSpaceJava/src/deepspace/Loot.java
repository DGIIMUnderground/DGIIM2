package deepspace;



/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class Loot {
    private int nSupplies;
    private int nWeapons;
    private int nShields;
    private int nHangars;
    private int nMedals;
    private boolean getEfficient;
    private boolean spaceCity;
    
    public Loot(int nsu, int nw, int nsh, int nh, int nm){
        nSupplies=nsu;
        nWeapons=nw;
        nShields=nsh;
        nHangars=nh;
        nMedals=nm;
    }
    
    public Loot(int nsu, int nw, int nsh, int nh, int nm, boolean ef, boolean city){
        nSupplies=nsu;
        nWeapons=nw;
        nShields=nsh;
        nHangars=nh;
        nMedals=nm;
        getEfficient=ef;
        spaceCity=city;
    }
    
    public int getNSupplies(){
        return nSupplies;
    }
    
    public int getNWeapons(){
        return nWeapons;
    }
    
    public int getNShields(){
        return nShields;
    }
    
    public int getNHangars(){
        return nHangars;
    }  
    
    public int getNMedals(){
        return nMedals;
    }
    
    public boolean getEfficient(){
        return getEfficient;
    }
    
    public LootToUI getUIversion(){
        return new LootToUI(this);
    }
    
    public boolean spaceCity(){
        return spaceCity;
    }
    
    public String toString(){
        String mensaje = "El numero de hangares del botin es "+this.getNHangars()+
                ", el numero de armas del botin es "+this.getNWeapons()+
                ", el numero de escudos del botin es "+this.getNShields()+
                ", el numero de hangares del botin es "+this.getNHangars()+
                " y el numero de medallas del botin es "+this.getNMedals();
        return mensaje;
    }
    
}
