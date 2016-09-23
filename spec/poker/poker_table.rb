class PokerTable

  def initialize(line)
    if line.split.uniq == line.split
      @line = line
    else
      raise PokerError::DuplicatedCardError
    end

    divide_line
  end

  def divide_line
    @left_hand = @line.split.each_slice(5).to_a[0]
    @right_hand = @line.split.each_slice(5).to_a[1]
  end

  private
  def create_hand(card_codes)
    Hand.new(get_cards(card_codes))
  end

  def get_cards(card_codes)
    card_codes.map do |card_code|
      Card.new(card_code)
    end
  end
end
