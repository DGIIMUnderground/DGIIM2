#encoding:utf-8

module Deepspace

# 2.3.17 - Translation from Java
# @author Profesor
    
class HangarToUI 
  attr_reader :maxElements, :weapons, :shieldBoosters
    
  def initialize(h) 
    @weapons=Array.new()
    @shieldBoosters=Array.new()
    @maxElements=h.maxElements
    
    for w in h.weapons do
      @weapons.push(w.getUIversion())
    end
    
    for s in h.shieldBoosters do
      @shieldBoosters.push(s.getUIversion())
    end
  end
  
  def to_s
    return "Max Elements: #{@maxElements}, Weapons: [#{@weapons.join(", ")}], Shields: [#{@shieldBoosters.join(", ")}]"
  end

end # class

end # module
