
module Controller

  class Option
    attr_reader :text
    def initialize(aText)
      @text = aText
    end
  end # class Option
  
  module Element
    WEAPON = Option.new("Arma")
    SHIELD = Option.new("Escudo")
    HANGAR = Option.new("Hangar")
  end # Element
  
  module Operation
    MOUNT = Option.new("Montar")
    DISCARD = Option.new("Descartar")
  end # Operation

class ControllerText
  
    attr_reader :model, :view
    
    def initialize (aModel, aView)
      @model = aModel
      @view = aView
      @view.setController(self)
    end
    
    public
  
    def start(numPlayers) 
        @model.init(@view.getPlayerNames(numPlayers))
        @view.updateView()
        @view.play(numPlayers)
    end

    def getUIversion() 
        return @model.getUIversion()
    end

    def getState() 
        return @model.state()
    end

    def combat() 
        result = @model.combat()
        @view.updateView()
        return result
    end

    def haveAWinner() 
        return @model.haveAWinner()
    end

    def discardHangar() 
        @model.discardHangar()
        @view.updateView()
    end

    def nextTurn() 
        result = @model.nextTurn()
        @view.updateView()
        return result
    end

    def mountWeapon(option) 
        @model.mountWeapon(option)
        @view.updateView()
    end
    
    def mountDiscardFromHangar(operation, element, option) 
          case element
              when Element::WEAPON 
                if(operation == Operation::MOUNT) then
                    @model.mountWeapon(option)
                else
                    @model.discardWeaponInHangar(option)
                end
              when Element::SHIELD 
                if(operation == Operation::MOUNT) then
                    @model.mountShieldBooster(option)
                else
                    @model.discardShieldBoosterInHangar(option)
                end
          end
        @view.updateView()
    end
    
    def discardMountedElements(element, option) 
        case element
            when Element::WEAPON 
              @model.discardWeapon(option)
            when Element::SHIELD
              @model.discardShieldBooster(option)
        end
        @view.updateView()
        
    end
    
end # class

end # module
