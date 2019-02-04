#encoding:utf-8

require_relative 'GameState'

module Deepspace

# 7.4.17 - Translation from Java
# @author Profesor
    
class GameStateController 

    attr_reader :state
    
    def initialize () 
        @state=GameState::CANNOTPLAY;        
    end

    
    def next(turn,nPlayers) 
        case @state
            when GameState::CANNOTPLAY
                @state=GameState::INIT
            when GameState::INIT
                @state=GameState::AFTERCOMBAT
            when GameState::BEFORECOMBAT
                @state=GameState::AFTERCOMBAT
            when GameState::AFTERCOMBAT
                if (turn>=nPlayers)
                    @state=GameState::BEFORECOMBAT
                else
                    @state=GameState::INIT
                end
        end
        return @state;
    end
end # class

end # module

if $0 == __FILE__ then
  gsc = Deepspace::GameStateController.new()
  puts gsc.state
  20.times {
    i = rand(5)+1
    puts "Turno " + i.to_s + " de 5 jugadores"
    puts gsc.next(i,5)
  }
end
