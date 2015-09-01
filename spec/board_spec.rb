require 'spec_helper'
require 'tictactoe_core/board'

describe TictactoeCore::Board do
  context 'default size' do
    it 'has a default size when no size specified' do
      board = described_class.new
      expect(board.size).to eq(3)
    end

    it 'has a default size when invalid size specified' do
      board = described_class.new(nil, nil)
      expect(board.size).to eq(3)
    end

    it 'can be initialized with given moves' do
      board = make_one_move_board
      expect(board.mark_at(0)).to eq(:x)
    end

    it 'two boards are equal if have same moves' do
      board_one = make_one_move_board
      board_two = make_one_move_board

      expect(board_one).to eq(board_two)
    end

    it 'making move has no affect on the original board used to make it' do
      board = make_one_move_board

      expect { board.add_move(2, :o) }.to_not change { board }
    end

    it 'when adding move, it returns a new board with added move' do
      board = described_class.new
      expect(board.add_move(0, :x)).to eq(described_class.new([:x, nil, nil,
                                                    nil, nil, nil,
                                                    nil, nil, nil]))
    end

    it 'knows if move is valid' do
      board = described_class.new
      expect(board.valid?(0)).to be(true)
    end

    it 'knows that occupied position is not valid' do
      board = make_one_move_board
      expect(board.valid?(0)).to be(false)
    end

    it 'knows that position outside the board is not valid' do
      board = described_class.new
      expect(board.valid?(10)).to be(false)
    end

    it 'knows when it is not full' do
      board = make_one_move_board
      expect(board.full?).to be(false)
    end

    it 'knows when its full' do
      board = make_draw_board
      expect(board.full?).to be(true)
    end

    it 'knows available positions' do
      board = make_one_move_board
      expect(board.available).to match_array([1, 2, 3, 4, 5, 6, 7, 8])
    end

    it 'knows if there is a win on a row' do
      board = make_win_board
      expect(board.winner_line).to_not be(nil)
    end

    it 'knows if there is a win on a diagonal' do
      board = described_class.new([:x, nil, nil, 
                        nil,  :x, nil, 
                        nil, nil, :x])
      expect(board.winner_line).to_not be(nil)
    end

    it 'knows if there is a win on a column' do
      board = described_class.new([nil, nil, :x, 
                        nil, nil, :x, 
                        nil, nil, :x])
      expect(board.winner_line).to_not be(nil)
    end

    it 'returns state split by rows' do
      board = make_one_move_board
      expect(board.state_by_rows).to eq([[:x, 1, 2], [3, 4, 5], [6, 7, 8]])
    end

    it 'returns the mark for the same player line' do
      board = make_win_board
      expect(board.winner_mark).to eq(:x)
    end

    def make_draw_board
      described_class.new([:x, :x, :o, 
                :o, :x, :x, 
                :x, :o, :o])
    end

    def make_win_board
      described_class.new([:x, :x, :x, 
                :o, :o, nil, 
                nil, nil, nil])
    end

    def make_one_move_board
      described_class.new([:x, nil, nil, 
                nil, nil, nil, 
                nil, nil, nil])
    end
  end

  context '4 by 4 size' do
    it 'adding move returns board of the same size' do
      board = described_class.new(nil, 4)
      new_board = board.add_move(0, :x)

      expect(new_board.available.length).to eq(15)
    end

    it 'knows that position outside the board is not valid' do
      board = described_class.new
      expect(board.valid?(16)).to be(false)
    end

    it 'knows if there is no win' do
      board = described_class.new([:x, :x, :x, nil,
                         :o, :o, :o, nil, 
                        nil, nil, nil, nil,
                        nil, nil, nil, nil], 4)
      expect(board.winner_line).to be(nil)
    end

    it 'knows if there is a win on a row' do
      board = make_win_board

      expect(board.winner_line).to eq([0, 1, 2, 3])
    end

    it 'knows if there is a win on a diagonal' do
      board = described_class.new([:x, nil, nil, nil, 
                        nil,  :x, nil, nil, 
                        nil, nil, :x, nil,
                        nil, nil, nil, :x], 4)
      expect(board.winner_line).to eq([0, 5, 10, 15])
    end

    it 'knows if there is a win on a column' do
      board = described_class.new([nil, nil, :x, nil,
                        nil, nil, :x, nil,
                        nil, nil, :x, nil,
                        nil, nil, :x, nil], 4)
      expect(board.winner_line).to eq([2, 6, 10, 14])
    end

    def make_empty_board
      described_class.new([nil, nil, nil, nil, 
                 nil, nil, nil, nil, 
                 nil, nil, nil, nil,
                 nil, nil, nil, nil,], 4)
    end
    
    def make_draw_board
      described_class.new([:x, :x, :o, :o,
                 :o, :x, :x, :o,
                 :o, :x, :o, :x,
                 :x, :o, :o, :x], 4)
    end

    def make_win_board
      described_class.new([:x, :x, :x, :x,
                 :o, :o, :o, nil, 
                nil, nil, nil, nil,
                nil, nil, nil, nil], 4)
    end

    def make_one_move_board
      described_class.new([:x, nil, nil, nil, 
                nil, nil, nil, nil, 
                nil, nil, nil, nil,
                nil, nil, nil, nil,], 4)
    end
  end
end
