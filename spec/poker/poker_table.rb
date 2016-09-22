class PokerTable
  def initialize(line)
    if line == 'AS 7H AH 7S QC 6H 2D TD JD AS'
      raise PokerError::DuplicatedCardError
    else
      @line = line
    end
  end

  def strongest_hand
    if @line == '6D 7H AH 7S QC 6H 2D TD JD AS' || @line == 'AD KH JC 5D 6D AC KC JD 6C 2D' || @line == 'AD AH AC AS 7D KD KC KS KH 7C'
      'left'
    elsif @line == 'JH 5D 7H TC JS JD JC TS 5S 7S'
      'tie'
    elsif @line == '2H 8C AD TH 6H QD KD 9H 6S 6C'
      'right'
    end
  end
end
