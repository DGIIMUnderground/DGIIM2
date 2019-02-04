
#@author Pedro Pablo Ruiz Huertas y Juan Antonio Villegas Recio

#encoding:utf-8

require_relative "ShieldToUI"

module Deepspace
  class ShieldBooster
   attr_reader :boost, :uses, :name
   
   public
   
   def initialize(n, b, u)
      @name = n
      @boost = b
      @uses = u
   end
    
   def self.newCopy(s)
     new(s.name, s.boost, s.uses)
   end
   
   def getUIversion
     return ShieldToUI.new(self)
   end
   
   def useIt()
     if @uses > 0
       @uses = @uses - 1
       return @boost
     else
       return 1.0
     end
   end
   
   def to_s
     return "Nombre: #{@name}  Aumento: #{@boost}  Usos: #{@uses}\n"
   end
   
   
  end
end
