/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import UI.TextUI;
import controller.ControllerText;
import deepspace.GameUniverse;

/**
 *
 * @author Profe
 */
public class PlayWithUI {
    public static void main(String[] args) {
        GameUniverse game = new GameUniverse();
        TextUI tui = TextUI.getInstance();
        ControllerText controller = new ControllerText (game,tui);
        // You can play with multiple players
        // You can read from console how many players you want
        
        controller.start(2);   // Let's play with 2 players
    }
}
