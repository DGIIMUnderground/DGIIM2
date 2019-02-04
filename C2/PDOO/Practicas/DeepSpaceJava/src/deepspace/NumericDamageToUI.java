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
public class NumericDamageToUI extends DamageToUI{
    private int nWeapons;

    NumericDamageToUI(NumericDamage d) {
        super(d);
        nWeapons=d.getNWeapons();
    }

    public int getNWeapons() {
        return nWeapons;
    } 
    
    @Override
    public String getWeaponInfo() {
        return ""+nWeapons;
    }
}
