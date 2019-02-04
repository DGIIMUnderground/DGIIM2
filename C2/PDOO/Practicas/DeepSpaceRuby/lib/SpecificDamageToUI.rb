
require_relative 'DamageToUI'

module Deepspace

# 2.3.17 - Translation from Java
# @author Profesor
    
class SpecificDamageToUI < DamageToUI
  
  public_class_method :new
  
  attr_reader :weapons
  
  def initialize (d)
    super(d)
    @weapons=Array.new(d.weapons)
  end
    
  public
  
  def getWeaponInfo() 
      return "[" + @weapons.join(", ") + "]"
  end
  
end # class

end # module
