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
class GameStateController {
    private GameState state;
    
    GameStateController() {
        state=GameState.CANNOTPLAY;        
    }

    public GameState getState() {
        return state;
    }
    
    public GameState next(int turn,int nPlayers) {
        switch (state) {
            case CANNOTPLAY: 
                state=GameState.INIT;
                break;
            case INIT: 
                state=GameState.AFTERCOMBAT;
                break;                
            case BEFORECOMBAT: 
                state=GameState.AFTERCOMBAT;
                break;
            case AFTERCOMBAT: 
                if (turn>=nPlayers)
                    state=GameState.BEFORECOMBAT;
                else
                    state=GameState.INIT;
                break;                
        }
        return state;
    }
}
