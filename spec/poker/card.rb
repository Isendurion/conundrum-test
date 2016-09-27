class Card
  attr_reader :name, :rank, :suit, :value

  CARD_NAMES = %w(2C 3C 4C 5C 6C 7C 8C 9C TC JC QC KC AC
                  2D 3D 4D 5D 6D 7D 8D 9D TD JD QD KD AD
                  2H 3H 4H 5H 6H 7H 8H 9H TH JH QH KH AH
                  2S 3S 4S 5S 6S 7S 8S 9S TS JS QS KS AS)
  NON_NUMERIC_RANKS = %w(T J Q K A)
  TO_NUMERIC_CONVERSION = { T: 10, J: 11, Q: 12, K: 13, A: 14 }

  def initialize(name)
    if CARD_NAMES.include?(name)
      @name = name
    else
      raise PokerError::InvalidCardError
    end
    
    @rank = name[0]
    @suit = name[1]

    if NON_NUMERIC_RANKS.include?(@rank)
      @value = convert_rank_to_numeric(@rank.to_sym, TO_NUMERIC_CONVERSION)
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
  def convert_rank_to_numeric(rank, conversion)
    conversion[rank]
  end
end
