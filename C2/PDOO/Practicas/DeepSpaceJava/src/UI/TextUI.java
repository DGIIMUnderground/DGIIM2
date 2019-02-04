
package UI;

import controller.ControllerText;
import deepspace.CombatResult;
import deepspace.DamageToUI;
import deepspace.EnemyToUI;
import deepspace.GameState;
import deepspace.GameUniverseToUI;
import deepspace.HangarToUI;
import deepspace.LootToUI;
import deepspace.ShieldToUI;
import deepspace.SpaceStationToUI;
import deepspace.WeaponToUI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class TextUI {
  
  private static final TextUI test = new TextUI ();
  private ControllerText controller;
  private GameUniverseToUI gameUI;
  private GameState state;
  private final Scanner in = new Scanner (System.in);  

  private final String mainSeparator = "\n ******* ******* ******* ******* ******* ******* ******* \n";
  private final String separator = "\n ------- ------- ------- ------- ------- ------- ------- \n";

  private TextUI () {}
  
  public static TextUI getInstance () {
    return test;
  }
  
  public void setController (ControllerText aController) {
      controller = aController;
  }
  
  public void updateView () {
    gameUI = controller.getUIversion();
    state = controller.getState();      
  }
  
  public void play () {
    Command command;

    do {   // Until   Exit
      command = Command.GOBACK;
      do {   // Until   Combat   or   Exit
        System.out.println (showStation (gameUI.getCurrentStation()));
        switch (state) {
            case INIT :
              command = getCommandInit ();
              break;
            case BEFORECOMBAT :
              command = getCommandBeforeCombat ();
              break;
        }
        command = processCommand (command);
      } while (command != Command.COMBAT && command != Command.EXIT);
      if (command == Command.COMBAT) {
          CombatResult result = controller.combat();
          switch (result) {
              case ENEMYWINS :
                pause ("\n Has PERDIDO el combate. Cumple tu castigo. ");
                break;
              case STATIONESCAPES :
                pause ("\n Has logrado escapar. Eres una Gallina Espacial.");
                break;
              case STATIONWINS :
                pause ("\n Has GANADO el combate. Disfruta de tu botín.");
                if (controller.haveAWinner()) {
                    pause ("\n\n **** **** ****  HAS GANADO LA PARTIDA  **** **** ****\n");
                    System.exit (0);
                }
                break;
          }
          do {   // Until a valid next turn
              System.out.println (showStation (gameUI.getCurrentStation()));
              command = getCommandAfterCombat ();
              command = processCommand (command);
          } while (command != Command.NEXTTURNALLOWED && command != Command.EXIT);
      }
    } while (command != Command.EXIT);
  }
  
  private Command getCommandInit() {
      Command commands[] = { 
          Command.MOUNTWEAPONS, Command.MOUNTSHIELDS, 
          Command.COMBAT, Command.EXIT
      };
      return manageMenu ("Bienvenido  " + gameUI.getCurrentStation().getName() + 
              ",  es tu primera vez.\n Organiza tu Armamento para el Combate.\n --- Opciones disponibles", commands);
  }
  
  private Command getCommandBeforeCombat() {
      Command commands[] = { Command.COMBAT, Command.EXIT };
      return manageMenu (gameUI.getCurrentStation().getName() + ",  estás en un punto de no retorno.\n Solo te queda Combatir.", commands);
}

  private Command getCommandAfterCombat () {
    Command commands[] = { 
          Command.MOUNTWEAPONS, Command.MOUNTSHIELDS, 
          Command.DISCARDWEAPONS, Command.DISCARDSHIELDS,
          Command.DISCARDWEAPONSINHANGAR, Command.DISCARDSHIELDSINHANGAR,
          Command.DISCARDHANGAR, 
          Command.SHOWENEMY, Command.NEXTTURN, Command.EXIT
      };
      return manageMenu (gameUI.getCurrentStation().getName() + ",  puedes Reorganizar tu Armamento antes de pasar de turno.\n Opciones disponibles", commands);
  }
  
  private Command processCommand (Command command) {
    switch (command) {
      case EXIT :
        break;
      case SHOWSTATION :
        System.out.println (showStation (gameUI.getCurrentStation()));
        break;
      case SHOWENEMY :
        System.out.println (showEnemy (gameUI.getCurrentEnemy()));
        break;
      case MOUNTWEAPONS :
        mountDiscardFromHangar (ControllerText.Operation.MOUNT, ControllerText.Element.WEAPON);
        break;
      case MOUNTSHIELDS :
        mountDiscardFromHangar (ControllerText.Operation.MOUNT, ControllerText.Element.SHIELD);
        break;
      case DISCARDWEAPONSINHANGAR :
        mountDiscardFromHangar (ControllerText.Operation.DISCARD, ControllerText.Element.WEAPON);
        break;
      case DISCARDSHIELDSINHANGAR :
        mountDiscardFromHangar (ControllerText.Operation.DISCARD, ControllerText.Element.SHIELD);
        break;
      case DISCARDHANGAR :
        controller.discardHangar();
        pause ("\n ******* Hangar Completo Descartado ******* ");
        break;
      case DISCARDWEAPONS :
        discardMountedElements (ControllerText.Element.WEAPON);
        break;
      case DISCARDSHIELDS :
        discardMountedElements (ControllerText.Element.SHIELD);
        break;
      case COMBAT :
        break;
      case NEXTTURN :
        if (controller.nextTurn()) {
            command = Command.NEXTTURNALLOWED;
        } else {
            pause ("\n No pudes avanzar de turno. No has cumplido tu Castigo Completamente");
        }
    }
    return command;
  }
  
  private void pause (String s) {
      System.out.print (mainSeparator);
      System.out.print (mainSeparator);
      System.out.println (s);
      System.out.print (mainSeparator);
      System.out.print (mainSeparator);
      System.out.print ("\n (pulsa  ENTER  para continuar) ");
      in.nextLine();
  }
  private String showStation (SpaceStationToUI station) {
    String out = "";

    out += mainSeparator + "\n";
    out += " ***** Información de la  Estación Espacial Actual *****\n";
    out += "       -------------------------------------------\n";
    out += "Nombre ............ : " + station.getName() + "\n";
    out += "Potencia de fuego . : " + station.getAmmoPower() + "\n";
    out += "Potencia de defensa : " + station.getShieldPower() + "\n";
    out += "Medallas .......... : " + station.getnMedals() + "\n";
    out += "Armas montadas : \n";
    String tmp = showWeapons (station.getWeapons(), false);
    if ("".equals(tmp))
        out += "   Ninguna \n";
    else
        out += tmp;
    out += "Potenciadores de Escudos montados : \n";
    tmp = showShields (station.getShieldBoosters(), false);
    if ("".equals(tmp))
        out += "   Ninguno \n";
    else
        out += tmp;
    out += showHangar (station.getHangar());
    out += "Castigo pendiente: ";
    out += showDamage (station.getPendingDamage());
    return out;
  }
  
  private String showWeapons (ArrayList<WeaponToUI> someWeapons, boolean menu) {
    String out = "";

    int i = 0;
    for (WeaponToUI aWeapon : someWeapons) {
        out += showWeapon (aWeapon, (menu ? (String.format ("%3d",i) + " : ") : " - "));
        i++;
    }
    return out;
  }
  
  private String showWeapon (WeaponToUI aWeapon, String tab) {
    return (tab + aWeapon.getType() + " - Potencia: " + aWeapon.getPower() + " - Usos: " + aWeapon.getUses() + "\n");
  }

  private String showShields (ArrayList<ShieldToUI> someShields, boolean menu) {
    String out = "";
    
    int i = 0;
    for (ShieldToUI aShield : someShields) {
        out += showShield (aShield, (menu ? (String.format ("%3d",i) + " : ") : " - "));
        i++;
    }
    return out;
  }
  
  private String showShield (ShieldToUI aShield, String tab) {
      return (tab + "Escudo - Potencia: " + aShield.getBoost() + " - Usos: " + aShield.getUses() + "\n");
  }
  
  private String showHangar (HangarToUI aHangar) {
    String out = "";
    if (aHangar != null) {
        int slots = aHangar.getMaxElements();
        out += "Dispone de un Hangar con " + slots;
        if (slots == 1) {
            out += " lugar \n";
        } else {
            out += " lugares \n";
        }
        out += showWeapons (aHangar.getWeapons(), false);
        out += showShields (aHangar.getShieldBoosters(), false);
    } else out = "No tiene ningún Hangar\n";
    return out;
  }
  
  private String showEnemy (EnemyToUI anEnemy) {
    String out = "";
    out += separator + "\n";
    out += " *** Información del Enemigo actual ***\n";
    out += "     ------------------------------\n";
    out += "Nombre ............ : " + anEnemy.getName() + "\n";
    out += "Potencia de fuego . : " + anEnemy.getAmmoPower() + "\n";
    out += "Potencia de defensa : " + anEnemy.getShieldPower() + "\n";
    out += "Botín : \n";
    out += showLoot (anEnemy.getLoot());
    out += "Pérdidas : \n";
    out += showDamage (anEnemy.getDamage());
    return out;
  }
  
  private String showLoot (LootToUI aLoot) {
      String out = "";
      out += " - Armas ..... : " + aLoot.getnWeapons() + "\n";
      out += " - Escudos ... : " + aLoot.getnShields() + "\n";
      out += " - Hangares .. : " + aLoot.getnHangars() + "\n";
      out += " - Suministros : " + aLoot.getnSupplies() + "\n";
      out += " - Medallas .. : " + aLoot.getnMedals() + "\n";
      return out;
  }
  
  private String showDamage (DamageToUI aDamage) {
      String out = "";
      if (aDamage != null) {
        out += "\n - Armas . : " + aDamage.getWeaponInfo() + "\n";
        out += " - Escudos : " + aDamage.getNShields() + "\n";
      } else {
        out = "Ninguno\n";
      }
      return out;
  }
  
  private void mountDiscardFromHangar (ControllerText.Operation operation, ControllerText.Element element) {
      int howMany;
      int option = Command.GOBACK.menu;
      
      do {   // Choice and mount weapons or shields until go back
          howMany = showHangarToMountDiscard (operation, element); 
          option = getChoice (howMany);
          controller.mountDiscardFromHangar(operation,element,option);
      } while (option != Command.GOBACK.menu);
  }
  
  private int showHangarToMountDiscard (ControllerText.Operation operation, ControllerText.Element element) {
      int option = Command.GOBACK.menu;
      
      System.out.println (separator);
      System.out.println ("Elige un " + element.text + " para " + operation.text);
      System.out.println ("\n" + String.format ("%3d",Command.GOBACK.menu) + " : " + Command.GOBACK.text + "\n");
      HangarToUI hangar = gameUI.getCurrentStation().getHangar();
      if (hangar != null) {
        switch (element) {
            case WEAPON :
                for (WeaponToUI weapon : hangar.getWeapons()) {
                    option++;
                    System.out.print (showWeapon (weapon, String.format ("%3d",option) + " : "));
                }
                break;
            case SHIELD :
                for (ShieldToUI shield : hangar.getShieldBoosters()) {
                    option++;
                    System.out.print (showShield (shield, String.format ("%3d",option) + " : "));
                }
                break;
        }
      }
      return option;
  }
  
  private void discardMountedElements (ControllerText.Element element) {
      int howMany = 0;
      int option = Command.GOBACK.menu;
      
      do {   // Choice and discard weapons or shields until go back
        System.out.println (separator);
        System.out.println ("Elige un " + element.text + " para Descartar");
        System.out.println ("\n" + String.format ("%3d",Command.GOBACK.menu) + " : " + Command.GOBACK.text + "\n");
        switch (element) {
            case WEAPON :
                System.out.println (showWeapons (gameUI.getCurrentStation().getWeapons(), true));
                howMany = gameUI.getCurrentStation().getWeapons().size();
                break;
            case SHIELD :
                System.out.println (showShields (gameUI.getCurrentStation().getShieldBoosters(), true));
                howMany = gameUI.getCurrentStation().getShieldBoosters().size();
                break;
        }
        option = getChoice (howMany);
        controller.discardMountedElements(element,option);
    } while (option != Command.GOBACK.menu);
  }
  
  public ArrayList<String> getPlayerNames (int numberOfPlayers) {
    ArrayList<String> names = new ArrayList();
    
    for (int i = 1; i <= numberOfPlayers; i++) {
      System.out.print ("Escribe el nombre del jugador " + i + ": ");
      names.add (in.nextLine());
    }
    return names;
  }

  private int getChoice (int howMany) {
    boolean validInput;
    String capture;
    int option;
    
    validInput = true;
    option = Command.GOBACK.menu;
    System.out.print ("\n Elige: ");
    capture = in.nextLine();
    try {
      option = Integer.valueOf(capture);
      if (option < Command.GOBACK.menu || option > howMany) { // no se ha escrito un entero en el rango permitido
        validInput = false;
      }
    } catch (NumberFormatException e) { // no se ha escrito un entero
      validInput = false;
    }
    if (! validInput) {
      inputErrorMessage ();
      return -2;   // Muestra de nuevo el menu y pide otra entrada
    }
    return option;
  }
  
  private void inputErrorMessage () {
    System.out.println ("\n\n ¡¡¡ E R R O R !!! \n\n Selección errónea. Inténtalo de nuevo.\n\n");    
  }
  
  
  private Command manageMenu (String message, Command[] menu) {
    HashMap <Integer, Command> menuCheck = new HashMap(); // Para comprobar que se hace una selección válida
    boolean validInput;
    String capture;
    int option;
    
    for (Command c : menu) {
      menuCheck.put (c.menu, c);
    }
    do { // Until a valid selection
      validInput = true;
      option = Command.GOBACK.menu;
      System.out.println (separator);
      System.out.println ("**** " + message + " ****\n");
      for (Command c : menu) { 
        System.out.println (String.format ("%3d",c.menu) + " : " + c.text + "\n");
      } 
      System.out.print ("\n Elige una opción: ");
      capture = in.nextLine();
      try {
        option = Integer.valueOf(capture);
        if (! menuCheck.containsKey(option)) { // It's not a valid integer
          validInput = false;
        }
      } catch (NumberFormatException e) { // It's not an integer
        validInput = false;
      }
      if (!validInput) {
        inputErrorMessage ();
      }
    } while (! validInput);
    return (menuCheck.get (option));    
  }
}
