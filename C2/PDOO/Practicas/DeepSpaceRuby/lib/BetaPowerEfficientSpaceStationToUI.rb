
require_relative 'PowerEfficientSpaceStationToUI'

module Deepspace

# 24.5.17 - Translation from Java
# @author Profesor
  
class BetaPowerEfficientSpaceStationToUI < PowerEfficientSpaceStationToUI

    def initialize (s)
        super(s)
    end
    
    #Override
    def name
      return super + " (beta)"
    end

end # class

end # module
