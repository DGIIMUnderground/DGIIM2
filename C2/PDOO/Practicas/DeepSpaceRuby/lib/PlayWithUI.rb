
require_relative 'GameUniverse'
require_relative 'TextUI'
require_relative 'Controller'

class PlayWithUI
  
  def self.main 
    game = Deepspace::GameUniverse.new
    tui = UI::TextUI.instance
    controller = Controller::ControllerText.new(game,tui)
    # You can play with multiple players
    # You can read from console how many players you want
        
    controller.start(2);   # Let's play whith 2 players
  end
end

PlayWithUI.main
