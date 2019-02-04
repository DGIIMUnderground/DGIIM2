
module Deepspace


# 5.4.17 - Translation from Java
# @author Profesor
  
class SpaceStationToUI
  
  attr_reader :name, :nMedals, :ammoPower, :fuelUnits, \
      :shieldPower, :shieldBoosters, :hangar, :weapons, \
      :pendingDamage
  
  def initialize (station)
    @weapons=Array.new()
    for w in station.weapons do
      @weapons << w.getUIversion()
    end
    
    @shieldBoosters=Array.new() 
    for sb in station.shieldBoosters do
      @shieldBoosters << sb.getUIversion()
    end
    
    @name=station.name
    @nMedals=station.nMedals
    
    @ammoPower=station.ammoPower
    @fuelUnits=station.fuelUnits
    @shieldPower=station.shieldPower
    
    h=station.hangar()
    if (h!=nil) then
      @hangar=h.getUIversion()
    else 
      @hangar=nil
    end
    
    #MIGUEL, en Java el pendingDamage no se incluye en la versión ToUI
    pd = station.pendingDamage
    if (pd != nil) then 
      @pendingDamage=pd.getUIversion()
    else
      @pendingDamage=nil
    end
  end
  
  def to_s
    out="Space Station - Name: #{name}\n"
    out+="\tnMedals: #{@nMedals}, Fuel units: #{@fuelUnits.round(2)}, Power: #{@ammoPower}, Shields: #{@shieldPower}\n"
    out+="\tWeapons: [#{@weapons.join(', ')}]\n"
    out+="\tShieldBooster: [#{@shieldBoosters.join(', ')}]\n"
    out+="\tHangars: #{@hangar}\n"
    out+="\tPendingDamage: #{@pendingDamage}\n" 
    out+="------- end of Space Station >> #{@name} << -------"
    return out
  end

end # class

end # module