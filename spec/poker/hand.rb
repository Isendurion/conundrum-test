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
    combination_value > hand.combination_value
  end

  def <(hand)
    combination_value < hand.combination_value
  end

  def combination_value
    if first_card_rank == 'A' && sequential_rank? && all_the_same_suit?
      hand_categories[:royal_flush]
    elsif !(self.cards.first.rank == 'A') && sequential_rank? && all_the_same_suit?
      hand_categories[:straight_flush]
    elsif to_h.has_value?(4)
      hand_categories[:four_of_a_kind]
    elsif combination_match?(uniq_cards_pattern: [2, 3])
      hand_categories[:full_house]
    elsif all_the_same_suit? && !(sequential_rank?)
      hand_categories[:flush]
    elsif sequential_rank? && !(all_the_same_suit?)
      hand_categories[:straight]
    elsif combination_match?(uniq_cards_pattern: [1, 1, 3])
      hand_categories[:three_of_kind]
    elsif combination_match?(uniq_cards_pattern: [1, 2, 2])
      hand_categories[:two_pairs]
    elsif combination_match?(uniq_cards_pattern: [1, 1, 1, 2])
      hand_categories[:one_pair]
    else
      hand_categories[:high_card]
    end
  end

  def to_h
    result = {}
    sort_card_values.each do |occurrence|
      result[occurrence].nil? ? result[occurrence] = 1 : result[occurrence] += 1
    end
    result
  end

  def sort_card_values
    @cards.map(&:value).sort
  end

  def sum_cards_value
    sort_card_values.inject{|sum, value| sum + value}
  end

  private
  def first_card_rank
    @cards.first.rank
  end
  def all_the_same_suit?
    @cards.map(&:suit).uniq.length == 1
  end

  def sequential_rank?
    value_ary = sort_card_values
    value_ary.map!.with_index do |value, index|
      value == value_ary.last ? true : value+1 == value_ary[index+1]
      end
    value_ary.all?
  end

  def combination_match?(uniq_cards_pattern:)
    to_h.values.sort == uniq_cards_pattern
  end
end
