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
    hand_values(@cards) > hand_values(hand.cards)
  end

  def <(hand)
    hand_values(@cards) < hand_values(hand.cards)
  end

  def ==(hand)
    hand_values(@cards) == hand_values(hand.cards)
  end

  def hand_values(cards)
    if cards.first.rank == 'A' && sequential_rank?(cards) && all_the_same_suit?(cards)
      HAND_CATEGORIES[:royal_flush]
    elsif !(cards.first.rank == 'A') && sequential_rank?(cards) && all_the_same_suit?(cards)
      HAND_CATEGORIES[:straight_flush]
    elsif four_of_a_kind?(cards)
      HAND_CATEGORIES[:four_of_a_kind]
    elsif full_house?(cards)
      HAND_CATEGORIES[:full_house]
    elsif all_the_same_suit?(cards) && !(sequential_rank?(cards))
      HAND_CATEGORIES[:flush]
    elsif sequential_rank?(cards) && !(all_the_same_suit?(cards))
      HAND_CATEGORIES[:straight]
    elsif three_of_a_kind?(cards)
      HAND_CATEGORIES[:three_of_kind]
    elsif two_pairs?(cards)
      HAND_CATEGORIES[:two_pairs]
    elsif one_pair?(cards)
      HAND_CATEGORIES[:one_pair]
    else
      HAND_CATEGORIES[:high_card]
    end
  end

  private
  def count_cards(cards)
    h = {}
    sort_from_the_highest(cards).each do |value|
      if h[value].nil?
        h[value] = 1
      else
        h[value] += 1
      end
    end
    h
  end

  def sort_from_the_highest(cards)
    cards.map{|card| card.value}.sort.reverse
  end

  def all_the_same_suit?(cards)
    cards.map{|card| card.suit}.uniq.length == 1
  end

  def sequential_rank?(cards)
    result = []
    value_ary = cards.map{|card| card.value}.sort
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
    count_cards(cards).map{|_, value| value == 4}.any?
  end

  def full_house?(cards)
    count_cards(cards).map{|_, value| value}.sort == [2, 3]
  end

  def three_of_a_kind?(cards)
    count_cards(cards).map{|_, value| value}.sort == [1, 1, 3]
  end

  def two_pairs?(cards)
    count_cards(cards).map{|_, value| value}.sort == [1, 2, 2]
  end

  def one_pair?(cards)
    count_cards(cards).map{|_, value| value}.sort == [1, 1, 1, 2]
  end
end
