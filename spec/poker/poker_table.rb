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
        equal_at_index?(index: 0, if_not: equal_at_index?(index: 1, if_not: equal_at_index?(index: 2, if_not: equal_at_index?(index: 3, if_not: equal_at_index?(index: 4, if_not: 'tie')))))
      elsif tie_type(:two_pairs)
        if hand_to_hash(@left_hand).select{|_, value| value == 2}.keys[0] > hand_to_hash(@right_hand).select{|_, value| value == 2}.keys[0]
          'left'
        elsif hand_to_hash(@left_hand).select{|_, value| value == 2}.keys[0] < hand_to_hash(@right_hand).select{|_, value| value == 2}.keys[0]
          'right'
        else
          hand_to_hash(@left_hand).select{|_, value| value == 2}.keys[1] > hand_to_hash(@right_hand).select{|_, value| value == 2}.keys[1] ? 'left' : 'right'
        end
      else
        if hand_to_hash(@left_hand).key(2) > hand_to_hash(@right_hand).key(2)
          'left'
        elsif hand_to_hash(@left_hand).key(2) < hand_to_hash(@right_hand).key(2)
          'right'
        else
          if hand_to_hash(@left_hand).select{|_, value| value == 1}.keys[0] > hand_to_hash(@right_hand).select{|_, value| value == 1}.keys[0]
            'left'
          elsif hand_to_hash(@left_hand).select{|_, value| value == 1}.keys[0] < hand_to_hash(@right_hand).select{|_, value| value == 1}.keys[0]
            'right'
          else
            if hand_to_hash(@left_hand).select{|_, value| value == 1}.keys[1] > hand_to_hash(@right_hand).select{|_, value| value == 1}.keys[1]
              'left'
            elsif hand_to_hash(@left_hand).select{|_, value| value == 1}.keys[1] < hand_to_hash(@right_hand).select{|_, value| value == 1}.keys[1]
              'right'
            else
              if hand_to_hash(@left_hand).select{|_, value| value == 1}.keys[2] > hand_to_hash(@right_hand).select{|_, value| value == 1}.keys[2]
                'left'
              elsif hand_to_hash(@left_hand).select{|_, value| value == 1}.keys[2] < hand_to_hash(@right_hand).select{|_, value| value == 1}.keys[2]
                'right'
              else
                'tie'
              end
            end
          end
        end
      end
    else
      hand_value_check
    end
  end

  private
  def equal_at_index?(index:, if_not:)
    if @left_hand.cards.map(&:value).sort.reverse[index] > @right_hand.cards.map(&:value).sort.reverse[index]
      'left'
    elsif @left_hand.cards.map(&:value).sort.reverse[index] < @right_hand.cards.map(&:value).sort.reverse[index]
      'right'
    else
      if_not
    end
  end

  def number_of_same_values(num)
    hand_to_hash(@left_hand).key(num) > hand_to_hash(@right_hand).key(num) ? 'left' : 'right'
  end

  def hand_value_check
    if cards_value(@left_hand.cards) > cards_value(@right_hand.cards)
      'left'
    elsif cards_value(@left_hand.cards) < cards_value(@right_hand.cards)
      'right'
    else
      'tie'
    end
  end

  def tie_type(combination)
    @left_hand.combination_value(@left_hand.cards) == @left_hand.hand_categories[combination]
  end

  def hand_to_hash(hand)
    hand.count_equal_elements(hand.cards)
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
    if @left_hand.combination_value(@left_hand.cards) != 0
      @left_hand.combination_value(@left_hand.cards) == @right_hand.combination_value(@right_hand.cards)
    else
      false
    end
  end

  def cards_value(cards)
    cards.map(&:value).inject{|sum, value| sum + value}
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
