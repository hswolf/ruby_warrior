class Player

  def initialize
    @health = 20
    @turn = 1
  end

  def play_turn(warrior)
    if at_first_step_in_first_turn?(warrior)
      go_forward(warrior)
    else
      go_backward(warrior)
    end
    @health = warrior.health
    @turn ++
  end

  def go_forward warrior
    if !is_attacked?(warrior.health) && need_health?(warrior.health) && warrior.feel.empty? 
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
    @turn == 1 && warrior.feel(:backward).wall?
  end
end
