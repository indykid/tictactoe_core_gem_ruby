module TictactoeCore
  class Board
    DEFAULT_SIZE = 3
    MAX_SIZE     = 4
    attr_reader :available, :size

    def initialize(moves = nil, size = nil)
      @size = parse_size(size)
      @moves = moves || Array.new(@size**2)
      @available = available_positions
      @win_positions = rows+columns+diagonals
    end

    def parse_size(size)
      size.to_i == MAX_SIZE ? MAX_SIZE : DEFAULT_SIZE
    end

    def add_move(position, mark)
      new_moves = moves.dup
      new_moves[position] = mark
      Board.new(new_moves, size)
    end

    def mark_at(position)
      moves[position]
    end

    def valid?(position)
      available.include?(position)
    end

    def full?
      moves.count(nil) == 0
    end

    def winner_line
      win_positions.find do |line|
        occupied?(line[0]) && winner?(line) 
      end
    end

    def winner?(line)
      line.each_index do |i|
        if line[i + 1]
          return false if moves[line[i]] != moves[line[i+1]]
        end
      end
      true
    end

    def occupied?(position)
      moves[position] != nil
    end

    def state_by_rows
      moves.map.with_index do |move, i|
        move || i
      end
      .each_slice(size).to_a
    end

    def winner_mark
      line = winner_line
      moves[line.first] if line
    end

    def ==(board)
      self.moves == board.moves
    end

    private

    attr_reader :win_positions

    def available_positions
      moves.each_index.reduce([]) do |available, position|
        available << position unless moves[position]
        available
      end
    end

    def get_marks(positions)
      positions.map { |position| moves[position] }
    end

    def update_moves(position, mark)
      moves[position] = mark
    end

    def update_available(position)
      available.delete(position)
    end

    def full_line?(marks)
      marks.each do |mark|
        return false if mark.nil?
      end
      true
    end

    def same_mark?(marks)
      marks.count(marks.first) == size
    end

    def rows
      @rows ||= moves.each_index.each_slice(size).to_a
    end

    def columns
      rows.transpose
    end

    def diagonals
      [first_diagonal, second_diagonal]
    end

    def first_diagonal
      rows.each_with_index.reduce([]) do |diagonal, (row, i)|
        diagonal << row[i]
      diagonal
      end
    end

    def second_diagonal
      rows.each_with_index.reduce([]) do |diagonal, (row, i)|
        diagonal << row.reverse[i]
      diagonal
      end
    end

    def set_win_positions
      case size
      when DEFAULT_SIZE
        [
          [0, 1, 2],
          [3, 4, 5],
          [6, 7, 8],
          [0, 3, 6],
          [1, 4, 7],
          [2, 5, 8],
          [0, 4, 8],
          [2, 4, 6]
        ]
      when MAX_SIZE
        [
          [2, 6, 10, 14],
          [3, 7, 11, 15],
          [0, 5, 10, 15],
          [3, 6, 9, 12],
          [0, 4, 8, 12],
          [1, 5, 9, 13],
          [0, 1, 2, 3],
          [4, 5, 6, 7],
          [8, 9, 10, 11],
          [12, 13, 14, 15]
        ]
      end
    end

    protected
    
    attr_reader :moves
  end
end
