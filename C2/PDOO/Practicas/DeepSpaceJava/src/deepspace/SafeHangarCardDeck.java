/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package deepspace;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;

/**
 *
 * @author Profesor
 */

class SafeHangarCardDeck extends CardDeck<Hangar> {
    @Override
    public Hangar next() {
        Hangar h=(Hangar)(super.next());
        return new Hangar(h) ;
    }
}

