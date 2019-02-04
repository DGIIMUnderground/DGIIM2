
require_relative 'DamageToUI'

module Deepspace

# 2.3.17 - Translation from Java
# @author Profesor
    
class NumericDamageToUI < DamageToUI
  
  public_class_method :new
  
  attr_reader :nWeapons
  
  def initialize (d)
    super(d)
    @nWeapons=d.nWeapons
  end
    
  public
  
  #Override
  def getWeaponInfo() 
    return @nWeapons.to_s
  end
  
end # class

end # module
