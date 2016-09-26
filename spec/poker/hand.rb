class Hand
  attr_accessor :cards

  HAND_CATEGORIES = { royal_flush: 9, straight_flush: 8, four_of_a_kind: 7, full_house: 6, flush: 5,
                      straight: 4, three_of_kind: 3, two_pairs: 2, one_pair: 1, high_card: 0         }

  def initialize(cards)
    if cards.size != 5
      raise PokerError::InvalidNumberOfCardsError
    else
      @cards = cards
    end
  end

  def >(hand)
    combination_value(@cards) > combination_value(hand.cards)
  end

  def <(hand)
    combination_value(@cards) < combination_value(hand.cards)
  end

  def combination_value(cards)
    if cards.first.rank == 'A' && sequential_rank?(cards) && all_the_same_suit?(cards)
      HAND_CATEGORIES[:royal_flush]
    elsif !(cards.first.rank == 'A') && sequential_rank?(cards) && all_the_same_suit?(cards)
      HAND_CATEGORIES[:straight_flush]
    elsif four_of_a_kind?(cards)
      HAND_CATEGORIES[:four_of_a_kind]
    elsif combination_match?(cards, [2, 3])
      HAND_CATEGORIES[:full_house]
    elsif all_the_same_suit?(cards) && !(sequential_rank?(cards))
      HAND_CATEGORIES[:flush]
    elsif sequential_rank?(cards) && !(all_the_same_suit?(cards))
      HAND_CATEGORIES[:straight]
    elsif combination_match?(cards, [1, 1, 3])
      HAND_CATEGORIES[:three_of_kind]
    elsif combination_match?(cards, [1, 2, 2])
      HAND_CATEGORIES[:two_pairs]
    elsif combination_match?(cards, [1, 1, 1, 2])
      HAND_CATEGORIES[:one_pair]
    else
      HAND_CATEGORIES[:high_card]
    end
  end

  def count_equal_elements(cards)
    result = {}
    reverse_sort(cards).each do |occurrence|
      result[occurrence].nil? ? result[occurrence] = 1 : result[occurrence] += 1
    end
    result
  end

  private
  def all_the_same_suit?(cards)
    cards.map(&:suit).uniq.length == 1
  end

  def sequential_rank?(cards)
    result = []
    value_ary = sort_cart_values(cards).sort
    value_ary.each_with_index do |value, index|
      if value == value_ary.first
        next
      else
        result << (value_ary[index-1]+1 == value_ary[index])
      end
    end
    result.all?
  end

  def four_of_a_kind?(cards)
    count_equal_elements(cards).map{|_, value| value == 4}.any?
  end

  def combination_match?(cards, ary)
    count_equal_elements(cards).map{|_, value| value}.sort == ary
  end

  def sort_cart_values(cards)
    cards.map(&:value).sort
  end

  def reverse_sort(cards)
    sort_cart_values(cards).reverse
  end
end
