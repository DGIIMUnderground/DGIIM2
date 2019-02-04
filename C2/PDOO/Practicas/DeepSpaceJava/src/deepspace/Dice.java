package deepspace;



import java.util.Random;
/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class Dice {
    private float NHANGARSPROB;
    private float NSHIELDSPROB;
    private float NWEAPONSPROB;
    private float FIRSTSHOTPROB;
    private float EXTRAEFFICIENCYPROB;
    private Random generator;
    
    Dice(){
        NHANGARSPROB=(float) 0.25;
        NSHIELDSPROB=(float) 0.25;
        NWEAPONSPROB=(float) 0.33;
        FIRSTSHOTPROB=(float) 0.5;
        EXTRAEFFICIENCYPROB=(float) 0.8;
        
        generator=new Random();
        
    }
    
    public boolean extraEfficiency(){
        float prob;
        prob=generator.nextFloat();
        
        return prob<EXTRAEFFICIENCYPROB;     
    }
    
    public int initWithNHangars(){
        float prob;
        prob = generator.nextFloat();
        
        if(prob<NHANGARSPROB){
            return 0;
        }
        else{
            return 1;
        }
    }
    
    public int initWithNWeapons(){
        float prob;
        prob=generator.nextFloat();
        
        if(prob<NWEAPONSPROB){
            return 1;
        }
        else{
                    if(prob<(2*NWEAPONSPROB)){
                        return 2;
                    }
                    else{
                        return 3;
                    }
        }
        
    }
    
    
    public int initWithNShields(){
        float prob;
        prob = generator.nextFloat();
        
        if(prob<NSHIELDSPROB){
            return 0;
        }
        else{
            return 1;
        }
    }
    
    public int whoStarts(int nPlayers){
        int player;
        player=generator.nextInt(nPlayers);
        return player;
    }
    
    GameCharacter firstShot(){
        float prob;
        prob=generator.nextFloat();
        if(prob<FIRSTSHOTPROB){
            return GameCharacter.SPACESTATION;
        }
        else{
            return GameCharacter.ENEMYSTARSHIP;
        }
    }
    
    boolean spaceStationMoves(float speed){
        float prob;
        prob=generator.nextFloat();
        return prob<speed;
        
    }
    
    public String toString(){
        String mensaje = "El numero de hangares inicial es "+this.initWithNHangars()+
                ", el numero de armas inicial es "+this.initWithNWeapons()+
                ", el numero de escudos inicial "+this.initWithNShields()+
                ", y dispara primero "+this.firstShot();
        return mensaje;
    }
}
