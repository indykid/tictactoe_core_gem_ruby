module TictactoeCore
  class AiNegamax
    attr_reader :mark, :move_count

    def initialize(mark, opponent_mark)
      @mark = mark
      @opponent_mark = opponent_mark
      @move_count = 0
    end

    def pick_position(board)
      increase_move_count
      if big?(board) && initial_move?(board)
        random_move(board)
      else
        negamax_score(board, mark, 1, 1, -INFINITY, INFINITY).position
      end
    end

    def negamax_score(current_board, current_mark, point_of_view, depth, a, b)
      result = end_result(current_board)
      return adjusted_score(result, depth, point_of_view) if result

      best_position = nil

      current_board.available.each do |position|
        score = -negamax_score(
          current_board.add_move(position, current_mark),
          opponent_of(current_mark),
          -point_of_view,
          depth + 1,
          -b,
          -a).score

          return ScoredPosition.new(a, position) if a >= b

          if score > a
            a = score
            best_position = position
          end
      end

      ScoredPosition.new(a, best_position)
    end

    def end_result(board)
      winner = board.winner_mark
      if winner == mark
        :win
      elsif winner == opponent_of(mark)
        :loss
      elsif board.full?
        :draw
      end
    end

    private
    attr_reader :opponent_mark

    ScoredPosition = Struct.new(:score, :position)
    SCORES = { draw:  0,
      win:  10,
      loss: -10 }
    INFINITY = Float::INFINITY
    MIN_BOARD_SIZE = 3

    def opponent_of(given_mark)
      given_mark == mark ? opponent_mark : mark
    end

    def end_score(result)
      SCORES[result]
    end

    def adjusted_score(result, depth, point_of_view)
      score = end_score(result)
      ScoredPosition.new(point_of_view*score/depth) if score
    end

    def increase_move_count
      @move_count += 1
    end

    def big?(board)
      size_of(board) > MIN_BOARD_SIZE
    end

    def initial_move?(board)
      if mark == :x
        move_count < size_of(board)
      else
        move_count < size_of(board) - 1
      end
    end

    def size_of(board)
      board.size
    end

    def random_move(board)
      board.available.sample
    end
  end
end
