/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package main;

import View.DeepSpaceView;
import controller.ControllerGrafico;
import deepspace.GameUniverse;
import View.GUI.MainWindow;

/**
 *
 * @author ana
 */
public class PlayWithGUI {
    
    public static void main(String[] args) {
    GameUniverse model = new GameUniverse();
    DeepSpaceView view = MainWindow.getInstance();
    ControllerGrafico controller = ControllerGrafico.getInstance();
    controller.setModelView(model,view);
    controller.start();
    }
}
