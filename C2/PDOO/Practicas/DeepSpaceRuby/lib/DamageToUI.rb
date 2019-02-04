
module Deepspace

#  2.3.17 - Translation from Java
# 24.5.17 - Adaptation to P4  
# @author Profesor
    
class DamageToUI
  
  private_class_method :new
  
  attr_reader :nShields
  
  def initialize (d) 
    @nShields=d.nShields
  end
    
  public
  
  def getWeaponInfo() 
    raise "ERROR: This method has not been implemented yet!"
  end
    
  def to_s
    out = "Weapons: " + getWeaponInfo() + ", Shields: #{@nShields}"
  end
  
end # class

end # module
