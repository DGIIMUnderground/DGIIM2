

package deepspace;

import java.util.ArrayList;

/**
 *
 * @author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio
 */
public class GameUniverse {
    private int WIN=10;
    private int currentStationIndex;
    private int turns;
    private GameStateController gamestate;
    private EnemyStarShip currentEnemy;
    private Dice dice;
    private SpaceStation currentStation;
    private ArrayList<SpaceStation> SpaceStations=new ArrayList<>();
    private boolean haveSpaceCity;
    
    public GameUniverse(){
        this.turns=0;
        this.dice=new Dice();
        gamestate=new GameStateController();
        haveSpaceCity=false;
    }
    
    public boolean haveAWinner(){
        if(currentStation.getNMedals()==WIN){
            return true;
        }
        else return false;
    }
    
    public void init(ArrayList<String> names){
      GameState state=gamestate.getState();
      if(state==GameState.CANNOTPLAY){
        turns=0;
        CardDealer dealer=CardDealer.getInstance();
        for(int i=0; i< names.size(); i++){
          SuppliesPackage supplies=dealer.nextSuppliesPackage();
          SpaceStation station=new SpaceStation(names.get(i),supplies);
          int nh=dice.initWithNHangars();
          int nw=dice.initWithNWeapons();
          int ns=dice.initWithNShields();
          Loot l=new Loot(0,nw,ns,ns,nh);
          station.setLoot(l);
          SpaceStations.add(station);
        }
        currentStationIndex=dice.whoStarts(names.size());
        currentStation=SpaceStations.get(currentStationIndex);
        currentEnemy=dealer.nextEnemy();
        gamestate.next(turns,names.size());
        }
    }
    
    public CombatResult combat(){
      GameState state=gamestate.getState();
      if(state==GameState.BEFORECOMBAT || state==GameState.INIT)
        return combatGo(currentStation,currentEnemy);
      else
        return CombatResult.NOCOMBAT;
    }
    
    CombatResult combatGo(SpaceStation station, EnemyStarShip enemy){
        GameCharacter ch=dice.firstShot();
        boolean enemyWins;
        float fire;
        ShotResult result;
        CombatResult combatResult;
      if(ch==GameCharacter.ENEMYSTARSHIP){
          fire=enemy.fire();
          result=station.receiveShot(fire);
            if(result==ShotResult.RESIST){
              fire=station.fire();
              result=enemy.receiveShot(fire);
              enemyWins=(result==ShotResult.RESIST);
            }
            else
              enemyWins=true;
        }
      else{
          fire=station.fire();
          result=enemy.receiveShot(fire);
          enemyWins=(result==ShotResult.RESIST);
      }
      if (enemyWins){
        float s=station.getSpeed();
        boolean moves=dice.spaceStationMoves(s);
        if(!moves){
          Damage damage=enemy.getDamage();
          station.setPendingDamage(damage);
          combatResult=CombatResult.ENEMYWINS;
        }
        else{
          station.move();
          combatResult=CombatResult.STATIONESCAPES;
        }
      }
      else{
        Loot aLoot=enemy.getLoot();
        Transformation transformation=station.setLoot(aLoot);
        if(transformation==Transformation.GETEFFICIENT){
            makeStationEfficient();
            combatResult=CombatResult.STATIONWINSANDCONVERTS;
        }
        else{
            if(transformation==Transformation.SPACECITY){
                createSpaceCity();
                combatResult=CombatResult.STATIONWINSANDCONVERTS;
            }
            else
                combatResult=CombatResult.STATIONWINS;
        }
      }
      gamestate.next(turns, SpaceStations.size());
      return combatResult;
    }
    
    public void createSpaceCity(){
        if (!haveSpaceCity){
            ArrayList<SpaceStation> vec=new ArrayList<>();
            for (int i=0; i<SpaceStations.size(); i++){
                if(i!=currentStationIndex)
                    vec.add(SpaceStations.get(i));
            }
            
            currentStation=new SpaceCity(currentStation,vec);
            SpaceStations.remove(currentStationIndex);
            SpaceStations.add(currentStationIndex, currentStation);
            haveSpaceCity=true;
            
        }
    }
    
    public void discardHangar(){
        if(gamestate.getState()==GameState.INIT || gamestate.getState()==GameState.AFTERCOMBAT)
            currentStation.discardHangar();
    }
    
    public void discardShieldBooster(int i){
        if(gamestate.getState()==GameState.INIT || gamestate.getState()==GameState.AFTERCOMBAT)
            currentStation.discardShieldBooster(i);
    }
    
    public void discardShieldBoosterInHangar(int i){
        if(gamestate.getState()==GameState.INIT || gamestate.getState()==GameState.AFTERCOMBAT)
            currentStation.discardShieldBoosterInHangar(i);
    }
    
    public void discardWeapon(int i){
        if(gamestate.getState()==GameState.INIT || gamestate.getState()==GameState.AFTERCOMBAT)
            currentStation.discardWeapon(i);
    }
    
    public void discardWeaponInHangar(int i){
        if(gamestate.getState()==GameState.INIT || gamestate.getState()==GameState.AFTERCOMBAT)
            currentStation.discardWeaponInHangar(i);
    }
    
    public GameState getState(){
        return this.gamestate.getState();
    }
    
    public GameUniverseToUI getUIversion(){
        return new GameUniverseToUI(this.currentStation, this.currentEnemy);
    }
    
    public void makeStationEfficient(){
        currentStation=new PowerEfficientSpaceStation(currentStation);
        if(dice.extraEfficiency()){
            currentStation=new BetaPowerEfficientSpaceStation(currentStation);
        }
        SpaceStations.remove(currentStationIndex);
        SpaceStations.add(currentStationIndex, currentStation);
    }
    
    public void mountShieldBooster(int i){
        if(gamestate.getState()==GameState.INIT || gamestate.getState()==GameState.AFTERCOMBAT)
            this.currentStation.mountShieldBooster(i);
    }
    
    public void mountWeapon(int i){
        if(gamestate.getState()==GameState.INIT || gamestate.getState()==GameState.AFTERCOMBAT)
            this.currentStation.mountWeapon(i);
    }
    
    public boolean nextTurn(){
        boolean stationState=currentStation.validState();;
        GameState state=gamestate.getState();
        if(state==GameState.AFTERCOMBAT){
          if(stationState){
            currentStationIndex=(currentStationIndex+1)%SpaceStations.size();
            currentStation=SpaceStations.get(currentStationIndex);
            turns++;
            currentStation.cleanUpMountedItems();
            CardDealer dealer=CardDealer.getInstance();
            currentEnemy=dealer.nextEnemy();
            gamestate.next(turns, SpaceStations.size());
            return true;
          }
          return false;
        }
        return false;
    }
    
    public ShieldBooster dameUnEscudoPrueba(){
        //HAS PUESTO EL CONTRUCTOR DEL TOUI PUBLICO
        return new ShieldBooster("ESCUDACO",3,4);
    }
    
    public Weapon dameUnArmaPrueba(){
        //HAS PUESTO EL CONTRUCTOR DEL TOUI PUBLICO
        return new Weapon("ARMACA",WeaponType.PLASMA,5);
    }
    
    public Hangar dameUnHangarPrueba(){
        Hangar h= new Hangar(8);
        h.addShieldBooster(new ShieldBooster("Escudo",5,4));
        h.addShieldBooster(new ShieldBooster("Escudo",3,5));
        h.addShieldBooster(new ShieldBooster("Escudo",5,7));
        h.addShieldBooster(new ShieldBooster("Escudo",0,5));
        h.addWeapon(new Weapon("Arma",deepspace.WeaponType.LASER,5));
        h.addWeapon(new Weapon("Arma",deepspace.WeaponType.MISSILE,4));
        h.addWeapon(new Weapon("Arma",deepspace.WeaponType.PLASMA,3));
        h.addWeapon(new Weapon("Arma",deepspace.WeaponType.LASER,5));
        return h;
    }
    
    public NumericDamage dameUnNumericDamagePrueba(){
        return new NumericDamage(3,9);
    }
    
    public SpecificDamage dameUnSpecificDamagePrueba(){
        ArrayList<WeaponType> weapons=new ArrayList();
        weapons.add(WeaponType.LASER);
        weapons.add(WeaponType.MISSILE);
        weapons.add(WeaponType.PLASMA);
        weapons.add(WeaponType.LASER);
        weapons.add(WeaponType.LASER);
        weapons.add(WeaponType.MISSILE);
        weapons.add(WeaponType.PLASMA);
        weapons.add(WeaponType.LASER); 
        weapons.add(WeaponType.LASER);
        weapons.add(WeaponType.MISSILE);
        weapons.add(WeaponType.PLASMA);
        weapons.add(WeaponType.LASER);
        return new SpecificDamage(weapons,6);
        
    }
    
    public EnemyStarShip dameUnEnemyStarShipPrueba(){
        return currentEnemy;
    }
    
    public SpaceStation dameUnSpaceStationPrueba(){
        int nh=3;
        int nw=dice.initWithNWeapons();
        int ns=dice.initWithNShields();
        Loot l=new Loot(0,nw,ns,ns,nh);
        currentStation.setLoot(l);
        return currentStation;
    }
    
    public Loot dameUnLootPrueba(){
        int nh=3;
        int nw=dice.initWithNWeapons();
        int ns=dice.initWithNShields();
        Loot l=new Loot(0,nw,ns,ns,nh);
        return l;
    }
    
    @Override
    public String toString(){
        String res;
        res="El universo del juego tiene: \n*Indice de la estacion espacial actual= "+currentStationIndex+
                "\n*"+turns+" turnos, \n*las estaciones espaciales del universo son:"+SpaceStations.toString()+"  \n*El enemigo actual es: "
                +currentEnemy.toString() + ",\nel estado del dado es: " +dice.toString();
        return res;
    }
}
