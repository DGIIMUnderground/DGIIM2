/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package View;

import controller.Controller;
import deepspace.GameUniverse;
import java.util.ArrayList;

/**
 *
 * @author Profe
 */
public interface DeepSpaceView {
  public void updateView();
  public void showView();
  // Inputs
  public ArrayList<String> readNamePlayers();
  // Outputs
  public boolean confirmExitMessage();
  public void nextTurnNotAllowedMessage();
  public void lostCombatMessage();
  public void escapeMessage();
  public void wonCombatMessage();
  public void wonGameMessage();
  public void conversionMessage();
  public void noCombatMessage();
  public void wonCombatAndConvertMessage();
}
