/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package deepspace;

/**
 *
 * @author Profesor
 */
public class GameUniverseToUI {
    SpaceStationToUI currentStation;
    EnemyToUI currentEnemy;
    
    GameUniverseToUI(SpaceStation station,EnemyStarShip enemy) {
        currentStation = station.getUIversion();
        currentEnemy= enemy.getUIversion();
    }

    public SpaceStationToUI getCurrentStation() {
        return currentStation;
    }

    public EnemyToUI getCurrentEnemy() {
        return currentEnemy;
    }
    
    
}
