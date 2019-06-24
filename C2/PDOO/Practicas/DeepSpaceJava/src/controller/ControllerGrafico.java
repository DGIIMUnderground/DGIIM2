/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import View.DeepSpaceView;
import deepspace.CombatResult;
import deepspace.GameState;
import deepspace.GameUniverse;
import deepspace.GameUniverseToUI;
import deepspace.SpaceStationToUI;
import deepspace.EnemyToUI;
import java.util.ArrayList;
import java.util.Collections;

/**
 *
 * @author profe (y alumnos por desgracia)
 */
public class ControllerGrafico {
    private static final ControllerGrafico instance = new ControllerGrafico();

    public static final int WEAPON = 0x1;
    public static final int SHIELD = 0x2;
    public static final int HANGAR = 0x4;
    private GameUniverse game;
    private DeepSpaceView view;

    private ControllerGrafico () {}

    public static ControllerGrafico getInstance () {
      return instance;
    }

    public void setModelView (GameUniverse aGame, DeepSpaceView aView) {
      game = aGame;
      view = aView;
    }

    public void start() {
        game.init(view.readNamePlayers());
        view.updateView();
        view.showView();
    }

    public void finish (int i) {
        if (view.confirmExitMessage()) {
          System.exit(i);
        }
    }

    public boolean nextTurn () {
      boolean nextTurnAllowed = game.nextTurn();
      if (!nextTurnAllowed) {
        view.nextTurnNotAllowedMessage();
      }
      return nextTurnAllowed;
    }

    public void combat () {
        CombatResult result = game.combat();
        switch (result) {
            case ENEMYWINS :
              view.lostCombatMessage();
              break;
            case STATIONESCAPES :
              view.escapeMessage();
              break;
            case STATIONWINS :
              view.wonCombatMessage();
              if (game.haveAWinner()) {
                  view.wonGameMessage();
                  System.exit (0);
              }
              break;
            case STATIONWINSANDCONVERTS  :
              view.wonCombatAndConvertMessage();
              if (game.haveAWinner()) {
                  view.wonGameMessage();
                  System.exit (0);
              }
              break;
            case NOCOMBAT :
              view.noCombatMessage();
              break;
        }
    }

    public GameState getState() {
      return game.getState();
    }

    public GameUniverseToUI getUIversion() {
      return game.getUIversion();
    }

    private void invertArray (ArrayList<Integer> array) {
      int i, n;

      n = array.size();
      for (i = 0; i < n/2; i++)
        Collections.swap(array, i, n-i-1);
    }

    public void mount (ArrayList<Integer> weapons, ArrayList<Integer> shields) {
      invertArray (weapons);
      invertArray (shields);

      for (int i : weapons) {
        game.mountWeapon(i);
      }
      for (int i : shields) {
        game.mountShieldBooster(i);
      }
    }

    public void discard (int places, ArrayList<Integer> weapons, ArrayList<Integer> shields) {
      invertArray(weapons);
      invertArray(shields);

      if ((places & WEAPON) == WEAPON) {
        for (int i : weapons) {
          game.discardWeapon(i);
        }
      } else if ((places & SHIELD) == SHIELD) {
        for (int i : shields) {
          game.discardShieldBooster(i);
        }
      } else if((places & HANGAR) == HANGAR) {
        for (int i : weapons) {
          game.discardWeaponInHangar(i);
        }
        for (int i : shields) {
          game.discardShieldBoosterInHangar(i);
        }
      }
    }

    public void discardHangar () {
        game.discardHangar();
        view.updateView();
    }

    public void mountCombatElements(ArrayList<Integer> v) {
       int w = game.getUIversion().getCurrentStation().getHangar().getShieldBoosters().size();
       for(int i=v.size()-1; i>=0; i--){
           if(i < w )
              game.mountShieldBooster(i);
           else
              game.mountWeapon(i-w);
       }
       view.updateView();
   }

   public void discardCombatElements(ArrayList<Integer> vh, ArrayList<Integer> vw, ArrayList<Integer> vs){
      if(vh.size()!=0){ //El hangar, aunque lo descartemos, no está nulo, está vacío. Entonces el vh, el vector de posiciones en el hangar, llega vacío
       int w = game.getUIversion().getCurrentStation().getHangar().getShieldBoosters().size();
       for(int i=vh.size()-1; i>=0; i--){
           if(i < w )
              game.discardShieldBoosterInHangar(i);
           else
              game.discardWeaponInHangar(i-w);
       }
      }

       for(int i=vw.size()-1; i>=0; i--)
              game.discardWeapon(i);

       for(int i=vs.size()-1; i>=0; i--)
              game.discardShieldBooster(i);


       view.updateView();
       }

   public SpaceStationToUI currentStation(){
      return game.getUIversion().getCurrentStation();
   }

   public EnemyToUI currentEnemy(){
      return game.getUIversion().getCurrentEnemy();
   }
}
