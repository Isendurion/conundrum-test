class PokerTable

  def initialize(line)
    if line.split.uniq == line.split
      @line = line
    else
      raise PokerError::DuplicatedCardError
    end

    divide_line
  end

  def strongest_hand
    if hand_combination_tie
      if rest_cards_value(@left_hand) > rest_cards_value(@right_hand)
        'left'
      elsif rest_cards_value(@left_hand) < rest_cards_value(@right_hand)
        'right'
      else
        'tie'
      end
    else
      create_hand(@left_hand) > create_hand(@right_hand) ? 'left' : 'right'
    end
  end

  private
  def divide_line
    @left_hand = @line.split.each_slice(5).to_a[0]
    @right_hand = @line.split.each_slice(5).to_a[1]
  end

  def hand_combination_tie
    create_hand(@left_hand) == create_hand(@right_hand)
  end

  def rest_cards_value(hand)
    get_cards(hand).map(&:value).inject{|sum, value| sum + value}
  end

  def create_hand(card_codes)
    Hand.new(get_cards(card_codes))
  end

  def get_cards(card_codes)
    card_codes.map do |card_code|
      Card.new(card_code)
    end
  end
end
