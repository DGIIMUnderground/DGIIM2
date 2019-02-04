
module Deepspace

# 9.3.17 - Translation from Java
# @author Profesor
  
class LootToUI
  attr_reader :nSupplies, :nWeapons, :nShields, :nHangars, :nMedals, :efficient, :spaceCity

  def initialize(l)
    @nSupplies=l.nSupplies
    @nWeapons=l.nWeapons
    @nShields=l.nShields
    @nHangars=l.nHangars
    @nMedals=l.nMedals
    @efficient=l.efficient
    @spaceCity=l.spaceCity
  end
  
  def to_s
    return "Supplies: #{@nSupplies}, Weapons: #{@nWeapons}, Shields: #{@nShields}, Hangars: #{@nHangars}, Medals: #{@nHangars}, Get Efficient: #{@efficient}, Space City: #{@spaceCity}"
  end

end # class
    
end # module
