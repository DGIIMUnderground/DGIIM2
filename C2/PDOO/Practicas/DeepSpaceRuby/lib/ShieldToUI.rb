
module Deepspace;

class ShieldToUI 
  
  attr_reader :boost, :uses

  def initialize (s)
    @boost=s.boost
    @uses=s.uses
  end
  
  def to_s
    return "Boost: #{@boost}, Uses: #{@uses}"
  end
    
end # class

end # module
