#encoding:utf-8

require 'singleton'

require_relative 'Command'

module UI



class TextUI
  
  include Singleton
  
  @@mainSeparator = "\n ******* ******* ******* ******* ******* ******* ******* \n"
  @@separator = "\n ------- ------- ------- ------- ------- ------- ------- \n"
  
  DS=Deepspace
      
  def initialize()
    @controller = nil
    @gameUI = nil
    @state = nil
    
  end
  
  public
  
  def setController (aController)
    @controller = aController
  end
  
  def updateView()
    @gameUI = @controller.getUIversion()
    @state = @controller.getState()
  end
      
  def play(numberOfPlayers) 
    begin   # Until   Exit
      command = Command::GOBACK
      begin    # Until   Combat   or   Exit
        puts showStation(@gameUI.currentStation())
        case @state 
          when DS::GameState::INIT then
            command = getCommandInit()
          when DS::GameState::BEFORECOMBAT then
            command = getCommandBeforeCombat()
        end
        command = processCommand(command)
      end while(command != Command::COMBAT && command != Command::EXIT)
      if(command == Command::COMBAT) then
          result = @controller.combat()
          case result 
            when DS::CombatResult::ENEMYWINS 
              pause("\n Has PERDIDO el combate. Cumple tu castigo.")
            when DS::CombatResult::STATIONESCAPES 
              pause("\n Has logrado escapar. Eres una Gallina Espacial.")
            when DS::CombatResult::STATIONWINS 
              pause("\n Has GANADO el combate. Disfruta de tu botín.")
            when DS::CombatResult::STATIONWINSANDCONVERTS
              if @gameUI.currentEnemy.loot.efficient
                pause("\n Has GANADO el combate y tu estación ahora es más eficiente. Disfruta de tu botín")
              else
                pause("\n Has GANADO el combate y tu estación se ha convertido en una ciudad espacial. Disfruta de tu botín")
              end
          
          
              if(@controller.haveAWinner()) then
                pause("\n\n **** **** ****  HAS GANADO LA PARTIDA  **** **** ****\n")
                exit(0)
              end
          end
          begin    # Until a valid next turn
              puts showStation(@gameUI.currentStation)
              command = getCommandAfterCombat()
              command = processCommand(command)
          end while(command != Command::NEXTTURNALLOWED && command != Command::EXIT)
      end # if COMBAT
    end while(command != Command::EXIT)
  end
  
  def getPlayerNames(numberOfPlayers)
    names = Array.new
    
    for i in 1..numberOfPlayers do
      print "Escribe el nombre del jugador " + i.to_s + ": "
      names << gets.chomp
    end
    return names
  end  
  
  private
  
  def manageMenu(message, menu) 
    menuCheck = Hash.new   # Para comprobar que se hace una selección válida

    for c in menu do
      menuCheck [c.menu] = c
    end
    begin # Until a valid selection
      validInput = true
      option = Command::GOBACK.menu;
      puts @@separator
      puts "**** " + message + " ****\n"
      for c in menu do 
        puts '%3d' % [c.menu] + " : " + c.text + "\n"
      end
      print "\n Elige una opción: "
      capture = gets.chomp
      begin
        option = Integer(capture)
        if(! menuCheck.has_key?(option)) then # It's not a valid integer
          validInput = false;
        end
      rescue Exception => e
        validInput = false;
      end
      if(!validInput) then
        inputErrorMessage()
      end
    end while(! validInput)
    return(menuCheck[option])    
  end
  
  def getCommandInit() 
    commands = [Command::MOUNTWEAPONS, Command::MOUNTSHIELDS, Command::COMBAT, Command::EXIT]
    return manageMenu("Bienvenido  " + @gameUI.currentStation.name + \
             ",  es tu primera vez.\n Organiza tu Armamento para el Combate.\n --- Opciones disponibles", \
             commands)
  end
  
  def getCommandBeforeCombat() 
    commands = [Command::COMBAT, Command::EXIT]
    return manageMenu(@gameUI.currentStation.name + \
            ",  estás en un punto de no retorno.\n Solo te queda Combatir.", commands)
  end

  def getCommandAfterCombat()
    commands = [ \
          Command::MOUNTWEAPONS, Command::MOUNTSHIELDS, 
          Command::DISCARDWEAPONS, Command::DISCARDSHIELDS,
          Command::DISCARDWEAPONSINHANGAR, Command::DISCARDSHIELDSINHANGAR,
          Command::DISCARDHANGAR, 
          Command::SHOWENEMY, Command::NEXTTURN, Command::EXIT ]
      
      return manageMenu(@gameUI.currentStation.name + \
              ",  puedes Reorganizar tu Armamento antes de pasar de turno.\n Opciones disponibles", \
              commands)
  end
  
  def processCommand(command) 
    case command
      when Command::EXIT 
        puts "Hasta la próxima"
      when Command::SHOWSTATION 
        puts showStation(@gameUI.currentStation)
      when Command::SHOWENEMY
        puts showEnemy(@gameUI.currentEnemy)
      when Command::MOUNTWEAPONS 
        mountDiscardFromHangar(Controller::Operation::MOUNT, Controller::Element::WEAPON)
      when Command::MOUNTSHIELDS 
        mountDiscardFromHangar(Controller::Operation::MOUNT, Controller::Element::SHIELD)
      when Command::DISCARDWEAPONSINHANGAR 
        mountDiscardFromHangar(Controller::Operation::DISCARD, Controller::Element::WEAPON)
      when Command::DISCARDSHIELDSINHANGAR 
        mountDiscardFromHangar(Controller::Operation::DISCARD, Controller::Element::SHIELD)
      when Command::DISCARDHANGAR 
        @controller.discardHangar()
        pause("\n ******* Hangar Completo Descartado ******* ")
      when Command::DISCARDWEAPONS 
        discardMountedElements(Controller::Element::WEAPON)
      when Command::DISCARDSHIELDS 
        discardMountedElements(Controller::Element::SHIELD);
      when Command::COMBAT 
        puts "Combatiendo"
      when Command::NEXTTURN 
        if(@controller.nextTurn()) then
            command = Command::NEXTTURNALLOWED
        else 
            pause("\n No pudes avanzar de turno. No has cumplido tu Castigo Completamente")
        end
    end
    return command
  end
  
  def pause(s) 
      print @@mainSeparator
      print @@mainSeparator
      puts s
      print @@mainSeparator
      print @@mainSeparator
      print "\n(pulsa  ENTER  para continuar) "
      gets
  end
  
  def showStation(station) 
    out = "";

    out += @@mainSeparator + "\n"
    out += " ***** Información de la  Estación Espacial Actual *****\n"
    out += "       -------------------------------------------\n"
    out += "Nombre ............ : " + station.name + "\n"
    out += "Potencia de fuego . : " + station.ammoPower.to_s + "\n"
    out += "Potencia de defensa : " + station.shieldPower.to_s + "\n"
    out += "Medallas .......... : " + station.nMedals.to_s + "\n"
    out += "Armas montadas : \n"
    tmp = showWeapons(station.weapons, false)
    if("".eql?(tmp)) then
        out += "   Ninguna \n"
    else
        out += tmp
    end
    out += "Potenciadores de Escudos montados : \n"
    tmp = showShields(station.shieldBoosters(), false)
    if("".eql?(tmp))
        out += "   Ninguno \n"
    else
        out += tmp
    end
    out += showHangar(station.hangar)
    out += "Castigo pendiente : "
    out += showDamage(station.pendingDamage)
    return out
  end
  
  def showWeapons(someWeapons, menu) 
    out = "";

    i = 0;
    for aWeapon in someWeapons do
      out += showWeapon(aWeapon,(menu ?(format("%3d",i) + " : ") : " - "))
      i+=1
    end
    return out
  end
  
  def showWeapon(aWeapon, tab) 
    return(tab + aWeapon.type.to_s + " - Potencia: " + aWeapon.power.to_s + " - Usos: " + aWeapon.uses.to_s + "\n")
  end

  def showShields(someShields, menu) 
    out = ""
    
    i = 0
    for aShield in someShields do
      out += showShield(aShield,(menu ?('%3d' % [i]) + " : " : " - "))
      i+=1
    end
    return out
  end
  
  def showShield(aShield, tab) 
      return(tab + "Escudo - Potencia: " + aShield.boost.to_s + " - Usos: " + aShield.uses.to_s + "\n");
  end
  
  def showHangar(aHangar) 
    String out = "";
    if(aHangar != nil) then
        slots = aHangar.maxElements
        out += "Dispone de un Hangar con " + slots.to_s
        out +=(slots == 1 ? " lugar \n" : " lugares \n")
        out += showWeapons(aHangar.weapons, false)
        out += showShields(aHangar.shieldBoosters, false)
    else
      out = "No tiene ningún Hangar\n"
    end
    return out
  end
  
  def showEnemy(anEnemy) 
    out = ""
    out += @@separator + "\n"
    out += " *** Información del Enemigo actual ***\n"
    out += "     ------------------------------\n"
    out += "Nombre ............ : " + anEnemy.name + "\n"
    out += "Potencia de fuego . : " + anEnemy.ammoPower.to_s + "\n"
    out += "Potencia de defensa : " + anEnemy.shieldPower.to_s + "\n"
    out += "Botín : \n"
    out += showLoot(anEnemy.loot)
    out += "Pérdidas : \n"
    out += showDamage(anEnemy.damage)
    return out
  end
  
  def showLoot(aLoot) 
      out = ""
      out += " - Armas ..... : " + aLoot.nWeapons.to_s + "\n"
      out += " - Escudos ... : " + aLoot.nShields.to_s + "\n"
      out += " - Hangares .. : " + aLoot.nHangars.to_s + "\n"
      out += " - Suministros : " + aLoot.nSupplies.to_s + "\n"
      out += " - Medallas .. : " + aLoot.nMedals.to_s + "\n"
      return out
  end
  
  def showDamage(aDamage)
      if (aDamage != nil) then
        out = "\n"
        out += " - Armas . : " + aDamage.getWeaponInfo() + "\n"
        out += " - Escudos : " + aDamage.nShields.to_s + "\n"
      else
        out = "Ninguno\n"
      end
      return out
  end
  
  def mountDiscardFromHangar(operation, element) 
      option = Command::GOBACK.menu
      
      begin    # Choice and mount weapons or shields until go back
          howMany = showHangarToMountDiscard(operation, element)
          option = getChoice(howMany)
          @controller.mountDiscardFromHangar(operation, element, option)
      end while(option != Command::GOBACK.menu)
  end
  
  def showHangarToMountDiscard(operation, element) 
      option = Command::GOBACK.menu
      
      puts @@separator
      puts "Elige un " + element.text + " para " + operation.text
      puts "\n" + format("%3d",Command::GOBACK.menu) + " : " + Command::GOBACK.text + "\n"
      hangar = @gameUI.currentStation.hangar
      if(hangar != nil) then
        case(element) 
            when Controller::Element::WEAPON 
                for weapon in hangar.weapons do
                    option+=1
                    print showWeapon(weapon, format("%3d",option) + " : ")
                end
            when Controller::Element::SHIELD 
                for shield in hangar.shieldBoosters do
                    option+=1
                    print showShield(shield, format("%3d",option) + " : ")
                end
        end
      end
      return option
  end
  
  def discardMountedElements(element) 
      howMany = 0
      option = Command::GOBACK.menu
      
      begin   # Choice and discard weapons or shields until go back
        puts @@separator
        puts "Elige un " + element.text + " para Descartar"
        puts "\n" + format("%3d",Command::GOBACK.menu) + " : " + Command::GOBACK.text + "\n"
        case element
            when Controller::Element::WEAPON 
                puts showWeapons(@gameUI.currentStation.weapons, true)
                howMany = @gameUI.currentStation.weapons.size();
            when Controller::Element::SHIELD 
                puts showShields(@gameUI.currentStation.shieldBoosters, true)
                howMany = @gameUI.currentStation.shieldBoosters.size()
        end
        option = getChoice(howMany)
        @controller.discardMountedElements(element, option)
    end while(option != Command::GOBACK.menu)
  end
  
  def getChoice(howMany) 
    validInput = true
    option = Command::GOBACK.menu
    print("\n Elige: ")
    capture = gets.chomp
    begin
      option = Integer(capture)
      if(option < Command::GOBACK.menu || option > howMany) then  # no se ha escrito un entero en el rango permitido
        validInput = false
      end
    rescue Exception => e   # no se ha escrito un entero
      validInput = false;
    end
    if(! validInput) then
      inputErrorMessage()
      return -2;   # Muestra de nuevo el menu y pide otra entrada
    end
    return option;
  end
  
  def inputErrorMessage()
    puts "\n\n ¡¡¡ E R R O R !!! \n\n Selección errónea. Inténtalo de nuevo.\n\n"
  end
  
  

  end # class
  
end # module
