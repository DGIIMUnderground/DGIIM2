
module Deepspace;
  
class WeaponToUI 

  # MIGUEL: por que  name  no forma parte de esta clase ?
  
    attr_reader :type, :power, :uses
    
    def initialize(w) 
        @type=w.type();
        @power=w.power();
        @uses=w.uses();
    end  
    
    def to_s
      return "Type: #{@type}, Power: #{@power}, Uses: #{@uses}"
    end
    
end # class

end # module
