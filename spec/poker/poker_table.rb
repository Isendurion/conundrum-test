class PokerTable

  def initialize(line)
    if line.split.uniq == line.split
      @line = line
    else
      raise PokerError::DuplicatedCardError
    end

    line_to_hands
  end

  def strongest_hand
    if combination_tie?
      if tie_type(:four_of_a_kind)
        number_of_same_values(4)
      elsif tie_type(:full_house) || tie_type(:three_of_kind)
        number_of_same_values(3)
      elsif tie_type(:flush)
        equal_at_position(position: 0, if_equal: equal_at_position(position: 1, if_equal: equal_at_position(position: 2, if_equal: equal_at_position(position: 3, if_equal: equal_at_position(position: 4, if_equal: 'tie')))))
      elsif tie_type(:two_pairs)
        compare_values(given_value: 2, position: 0, if_equal: compare_values(given_value: 2, position: 1, if_equal: 'tie'))
      else
        if @left_hand.to_h.key(2) > @right_hand.to_h.key(2)
          'left'
        elsif @right_hand.to_h.key(2) > @left_hand.to_h.key(2)
          'right'
        else
          compare_values(given_value: 1, position: 0, if_equal: compare_values(given_value: 1, position: 1, if_equal: compare_values(given_value: 1, position: 2, if_equal: 'tie')))
        end
      end
    else
      hand_value_check
    end
  end

  private
  def compare_values(given_value:, position:, if_equal:)
    if position_value(@left_hand, given_value, position) > position_value(@right_hand, given_value, position)
      'left'
    elsif position_value(@right_hand, given_value, position) > position_value(@left_hand, given_value, position)
      'right'
    else
      if_equal
    end
  end

  def position_value(hand, v, p)
    hand.to_h.select{|_, value| value == v}.keys[p]
  end

  def equal_at_position(position:, if_equal:)
    if @left_hand.sort_card_values.reverse[position] > @right_hand.sort_card_values.reverse[position]
      'left'
    elsif @right_hand.sort_card_values.reverse[position] > @left_hand.sort_card_values.reverse[position]
      'right'
    else
      if_equal
    end
  end

  def number_of_same_values(num)
    @left_hand.to_h.key(num) > @right_hand.to_h.key(num) ? 'left' : 'right'
  end

  def hand_value_check
    if @left_hand.sum_cards_value > @right_hand.sum_cards_value
      'left'
    elsif @right_hand.sum_cards_value > @left_hand.sum_cards_value
      'right'
    else
      'tie'
    end
  end

  def tie_type(combination)
    @left_hand.combination_value == @left_hand.hand_categories[combination]
  end

  def divide_line
    @left_line = @line.split.each_slice(5).to_a[0]
    @right_line = @line.split.each_slice(5).to_a[1]
  end

  def line_to_hands
    divide_line
    @left_hand = create_hand(@left_line)
    @right_hand = create_hand(@right_line)
  end

  def combination_tie?
    if @left_hand.combination_value != 0
      @left_hand.combination_value == @right_hand.combination_value
    else
      false
    end
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
