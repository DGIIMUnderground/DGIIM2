module Deepspace

# 30.3.17 - Translation from Java
# @author Profesor
  
class EnemyToUI 
  
  attr_reader :name, :ammoPower, :shieldPower, :loot, :damage
    
  def initialize(enemy) 
    @name=enemy.name
    @ammoPower=enemy.ammoPower
    @shieldPower=enemy.shieldPower
    @loot=enemy.loot.getUIversion()
    @damage = enemy.damage.getUIversion()
  end

  def to_s
    return "Name: #{@name}, " + \
        "Ammo Power: #{@ammoPower}, " + \
        "Shield Power: #{@shieldPower}\n" + \
        "\tLoot..: #{@loot}\n" + \
        "\tDamage: #{@damage}"
  end
    
end # class

end # module
