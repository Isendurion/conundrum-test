class Hand
  def initialize(cards)
    if cards.size != 5
      raise PokerError::InvalidNumberOfCardsError
    else
      @cards = cards
    end
  end

  def > card
    true
  end

  def <  card
    true
  end
end
