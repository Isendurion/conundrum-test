class Card
  attr_accessor :value

  CARD_NAMES = %w(2C 3C 4C 5C 6C 7C 8C 9C TC JC QC KC AC
                  2D 3D 4D 5D 6D 7D 8D 9D TD JD QD KD AD
                  2H 3H 4H 5H 6H 7H 8H 9H TH JH QH KH AH
                  2S 3S 4S 5S 6S 7S 8S 9S TS JS QS KS AS)
  NON_NUMERIC_RANKS = %w(T J Q K A)

  def initialize(name)
    if CARD_NAMES.include?(name)
      @name = name
    else
      raise PokerError::InvalidCardError
    end
    
    @rank = name[0]

    if NON_NUMERIC_RANKS.include?(@rank)
      set_value
    else
      @value = @rank.to_i
    end
  end

  def >(card)
    value > card.value
  end

  def <(card)
    value < card.value
  end

  private
  def set_value
    if @rank == 'T'
      @value = 10
    elsif @rank == 'J'
      @value = 11
    elsif @rank == 'Q'
      @value = 12
    elsif @rank == 'K'
      @value = 13
    elsif @rank == 'A'
      @value = 14
    end
  end
end
