
require_relative 'SpaceStationToUI'

module Deepspace

# 24.5.17 - Translation from Java
# @author Profesor
  
class SpaceCityToUI < SpaceStationToUI 
  
  attr_reader :collaborators
  
  def initialize (city) 
    super(city)
    @collaborators=Array.new
    for c in city.collaborators do 
      @collaborators << SpaceStationToUI.new(c)
    end
  end
  
  #Override
  def name () 
    return super + " (CIUDAD ESPACIAL)"
  end
  
  #Override
  def to_s
    out = super
    out += "\n ------- My Collaborators are:"
    for c in @collaborators do
      out += "\n --- Collaborator --- \n"
      out += c.to_s
    end
    out += "\n ------- No More Collaborators \n"
    return out
  end

end # class

end # module
