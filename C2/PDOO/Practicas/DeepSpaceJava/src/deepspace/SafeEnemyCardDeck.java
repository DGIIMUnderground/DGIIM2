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
class SafeEnemyCardDeck extends CardDeck<EnemyStarShip> {
    @Override
    public EnemyStarShip next() {
        EnemyStarShip h=(EnemyStarShip)(super.next());
        return new EnemyStarShip(h) ;
    }
}
