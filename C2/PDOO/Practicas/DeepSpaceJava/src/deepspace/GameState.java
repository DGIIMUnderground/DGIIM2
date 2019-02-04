package deepspace;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Profesor
 */
public enum GameState {
    CANNOTPLAY, INIT,BEFORECOMBAT,AFTERCOMBAT
    /*  
    CANNOTPLAY:     the Gameuniverse has benn created but not initialized
    INIT:   the GameUniverse has been initialized and the current player has not combated. 
            Players can mount weapons and shielboosters, or combat
    BEFORECOMBAT:   players can only combat
    AFTERCOMBAT:    players can mount/discard weapons,shielboosters and hangars 
    */
}

//    INIT:   the GameUniverse has been initialized and the current player has not combated. 
//            Players can mount/discard weapons,shielboosters and hangars or combat
