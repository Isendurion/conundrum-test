class Hand

  attr_accessor :cards, :hand_categories

  HAND_CATEGORIES = { royal_flush: 9, straight_flush: 8, four_of_a_kind: 7, full_house: 6, flush: 5,
                      straight: 4, three_of_kind: 3, two_pairs: 2, one_pair: 1, high_card: 0         }

  def initialize(cards)
    if cards.size != 5
      raise PokerError::InvalidNumberOfCardsError
    else
      @cards = cards
    end
    @hand_categories = HAND_CATEGORIES
  end

  def >(hand)
    combination_value(@cards) > combination_value(hand.cards)
  end

  def <(hand)
    combination_value(@cards) < combination_value(hand.cards)
  end

  def combination_value(cards)
    if first_card_rank(cards) == 'A' && sequential_rank?(cards) && all_the_same_suit?(cards)
      hand_categories[:royal_flush]
    elsif !(cards.first.rank == 'A') && sequential_rank?(cards) && all_the_same_suit?(cards)
      hand_categories[:straight_flush]
    elsif count_equal_elements(cards).has_value?(4)
      hand_categories[:four_of_a_kind]
    elsif combination_match?(cards, [2, 3])
      hand_categories[:full_house]
    elsif all_the_same_suit?(cards) && !(sequential_rank?(cards))
      hand_categories[:flush]
    elsif sequential_rank?(cards) && !(all_the_same_suit?(cards))
      hand_categories[:straight]
    elsif combination_match?(cards, [1, 1, 3])
      hand_categories[:three_of_kind]
    elsif combination_match?(cards, [1, 2, 2])
      hand_categories[:two_pairs]
    elsif combination_match?(cards, [1, 1, 1, 2])
      hand_categories[:one_pair]
    else
      hand_categories[:high_card]
    end
  end

  def count_equal_elements(cards)
    result = {}
    sort_card_values(cards).each do |occurrence|
      result[occurrence].nil? ? result[occurrence] = 1 : result[occurrence] += 1
    end
    result
  end

  private
  def first_card_rank(cards)
    cards.first.rank
  end
  def all_the_same_suit?(cards)
    cards.map(&:suit).uniq.length == 1
  end

  def sequential_rank?(cards)
    value_ary = sort_card_values(cards)
    value_ary.map!.with_index do |value, index|
      value == value_ary.last ? true : value+1 == value_ary[index+1]
      end
    value_ary.all?
  end

  def combination_match?(cards, pattern)
    count_equal_elements(cards).values.sort == pattern
  end

  def sort_card_values(cards)
    cards.map(&:value).sort
  end
end
