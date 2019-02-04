#encoding:utf-8

require_relative 'SpaceStationToUI'

module Deepspace;
  
  # 23.5.17 - Translation from Java
  # @author Profesor
  
class PowerEfficientSpaceStationToUI < SpaceStationToUI 
  def initialize (efficientStation) 
    super(efficientStation)
  end
  
  #Override
  def name
    out = super
    out += " (ESTACIÓN EFICIENTE)"
    return out
  end

end # class

end # module
