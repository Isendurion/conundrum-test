class PokerTable

  def initialize(line)
    if line.split.uniq == line.split
      @line = line
    else
      raise PokerError::DuplicatedCardError
    end

    divide_line
    @left_hand = create_hand(@left_line)
    @right_hand = create_hand(@right_line)
  end

  def strongest_hand
    if hand_combination_tie
      if straight_flush_tie?
        if cards_value(@left_hand.cards) > cards_value(@right_hand.cards)
          'left'
        elsif cards_value(@left_hand.cards) < cards_value(@right_hand.cards)
          'right'
        else
          'tie'
        end
      elsif four_of_a_kind_tie?
        hand_to_hash(@left_hand).key(4) > hand_to_hash(@right_hand).key(4) ? 'left' : 'right'
      elsif full_house_tie?
        hand_to_hash(@left_hand).key(3) > hand_to_hash(@right_hand).key(3) ? 'left' : 'right'
      elsif flush_tie?
        if @left_hand.cards.map(&:value).sort.reverse[0] > @right_hand.cards.map(&:value).sort.reverse[0]
          'left'
        elsif @left_hand.cards.map(&:value).sort.reverse[0] < @right_hand.cards.map(&:value).sort.reverse[0]
          'right'
        else
          if @left_hand.cards.map(&:value).sort.reverse[1] > @right_hand.cards.map(&:value).sort.reverse[1]
            'left'
          elsif @left_hand.cards.map(&:value).sort.reverse[1] < @right_hand.cards.map(&:value).sort.reverse[1]
            'right'
          else
            if @left_hand.cards.map(&:value).sort.reverse[2] > @right_hand.cards.map(&:value).sort.reverse[2]
              'left'
            elsif @left_hand.cards.map(&:value).sort.reverse[2] < @right_hand.cards.map(&:value).sort.reverse[2]
              'right'
            else
              if @left_hand.cards.map(&:value).sort.reverse[3] > @right_hand.cards.map(&:value).sort.reverse[3]
                'left'
              elsif @left_hand.cards.map(&:value).sort.reverse[3] < @right_hand.cards.map(&:value).sort.reverse[3]
                'right'
              else
                if @left_hand.cards.map(&:value).sort.reverse[4] > @right_hand.cards.map(&:value).sort.reverse[4]
                  'left'
                elsif @left_hand.cards.map(&:value).sort.reverse[4] < @right_hand.cards.map(&:value).sort.reverse[4]
                  'right'
                else
                  'tie'
                end
              end
            end
          end
        end
      elsif straight_tie?
        if cards_value(@left_hand.cards) > cards_value(@right_hand.cards)
          'left'
        elsif cards_value(@left_hand.cards) < cards_value(@right_hand.cards)
          'right'
        else
          'tie'
        end
      elsif three_of_kind_tie?
        hand_to_hash(@left_hand).key(3) > hand_to_hash(@right_hand).key(3) ? 'left' : 'right'
      elsif two_pairs_tie?
        if hand_to_hash(@left_hand).select{|_, value| value == 2}.keys[0] > hand_to_hash(@right_hand).select{|_, value| value == 2}.keys[0]
          'left'
        elsif hand_to_hash(@left_hand).select{|_, value| value == 2}.keys[0] < hand_to_hash(@right_hand).select{|_, value| value == 2}.keys[0]
          'right'
        else
          if hand_to_hash(@left_hand).select{|_, value| value == 2}.keys[1] > hand_to_hash(@right_hand).select{|_, value| value == 2}.keys[1]
            'left'
          elsif hand_to_hash(@left_hand).select{|_, value| value == 2}.keys[1] < hand_to_hash(@right_hand).select{|_, value| value == 2}.keys[1]
            'right'
          else
            if cards_value(@left_hand.cards) > cards_value(@right_hand.cards)
              'left'
            elsif cards_value(@left_hand.cards) < cards_value(@right_hand.cards)
              'right'
            else
              'tie'
            end
          end
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
      cards_value(@left_hand.cards) > cards_value(@right_hand.cards) ?  'left' : 'right'
    end
  end

  private
  def straight_flush_tie?
    @left_hand.combination_value(@left_hand.cards) == 8
  end

  def four_of_a_kind_tie?
    @left_hand.combination_value(@left_hand.cards) == 7
  end

  def full_house_tie?
    @left_hand.combination_value(@left_hand.cards) == 6
  end

  def flush_tie?
    @left_hand.combination_value(@left_hand.cards) == 5
end

  def straight_tie?
    @left_hand.combination_value(@left_hand.cards) == 4
  end

  def three_of_kind_tie?
    @left_hand.combination_value(@left_hand.cards) == 3
  end

  def two_pairs_tie?
    @left_hand.combination_value(@left_hand.cards) == 2
  end

  def hand_to_hash(hand)
    hand.count_equal_elements(hand.cards)
  end

  def divide_line
    @left_line = @line.split.each_slice(5).to_a[0]
    @right_line = @line.split.each_slice(5).to_a[1]
  end

  def hand_combination_tie
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
