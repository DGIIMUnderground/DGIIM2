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
public class ShieldToUI {
    private float boost;
    private int uses;

    public ShieldToUI (ShieldBooster s) {
        boost=s.getBoost();
        uses=s.getUses();
    }    

    public float getBoost() {
        return boost;
    }

    public int getUses() {
        return uses;
    }
    
    
}
