
class Player
  def initialize
    @health = 20
    @turn = 1
    @already_in_first_step = false
  end
  
  def play_turn(warrior)
    if warrior.feel.wall?
      warrior.pivot!
      @turn -= 1
    elsif at_first_step_in_first_turn?(warrior) || @already_in_first_step
      go_forward(warrior)
    elsif !@already_in_first_step
      go_backward(warrior)
    end
    @health = warrior.health
    @turn += 1
  end
  
  def go_forward warrior
    if has_enemy_in_three_step?(warrior.look)
      warrior.shoot!
    elsif is_attacked?(warrior.health) && need_back?(warrior.health)
      warrior.walk!(:backward)
    elsif !is_attacked?(warrior.health) && need_health?(warrior.health) && warrior.feel.empty?
      warrior.rest!
    elsif warrior.feel.empty?
        warrior.walk!
    elsif warrior.feel.captive?
      warrior.rescue!
    else
      warrior.attack!
    end
  end
  
  def go_backward warrior
    if warrior.feel(:backward).empty?
      warrior.walk!(:backward)
    elsif warrior.feel(:backward).captive?
      warrior.rescue!(:backward)
    elsif warrior.feel(:backward).wall?
      @already_in_first_step = true
      go_forward warrior
    end
  end
  
  def need_health? health
    health < 20
  end
  
  def is_attacked? health
    health < @health
  end
  
  def at_first_step_in_first_turn? warrior
    if @turn == 1 && warrior.feel(:backward).wall?
      @already_in_first_step = true
      return true
    else
      return false
    end
  end

  def need_back? health
    health < 10
  end

  def has_enemy_in_three_step? spaces
    spaces.each do |space|
      return false if space.captive?
      return true if space.enemy?
    end
    false
  end
end
  