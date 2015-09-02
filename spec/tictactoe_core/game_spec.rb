require 'tictactoe_core/game'
require 'tictactoe_core/board'

describe TictactoeCore::Game do
  let(:ui)       { FakeUi.new }
  let(:board_class) { TictactoeCore::Board }
  let(:board)    { board_class.new }
  let(:player_x) { FakePlayer.new(:x) }
  let(:player_o) { FakePlayer.new(:o) }

  it 'is not over at the start' do
    game = described_class.new(board, ui, player_x, player_o)

    expect(game.over?).to be(false)
  end

  it 'is over if won' do
    board = board_class.new([:x, :x, :x, 
                       :o, :o, nil, 
                       nil, nil, nil])
    game = described_class.new(board, ui, player_x, player_o)

    expect(game.over?).to be(true)
  end

  it 'is over when drawn' do
    board = board_class.new([:x, :x, :o, 
                             :o, :x, :x, 
                             :x, :o, :o])
    game = described_class.new(board, ui, player_x, player_o)

    expect(game.over?).to be(true)
  end

  it 'adds player moves to the board' do
    game = described_class.new(board, ui, *setup_players([0], []))

    game.play_turn

    expect(game.board.mark_at(0)).to eq(:x)
  end

  it 'switches player turns' do
    game = described_class.new(board, ui, *setup_players([0], [1]))

    2.times { game.play_turn }

    expect(game.board.mark_at(0)).to eq(:x)
    expect(game.board.mark_at(1)).to eq(:o)
  end

  it 'gets Ui to display the board' do
    game = described_class.new(board, ui, *setup_players([0], []))

    game.play_turn

    expect(ui.board_display_count).to eq(1)
  end

  it 'gets Ui to inform on invalid move' do
    game = described_class.new(board, ui, *setup_players(['a', 0], []))

    game.play_turn

    expect(ui.invalid_option_count).to eq(1)
  end

  it 'plays till win' do
    game = setup_for_win

    game.play

    expect(game.over?).to be(true)
  end

  it 'plays till draw' do
    game = setup_for_draw

    game.play

    expect(game.over?).to be(true)
  end

  it 'gets ui to display board one extra time after it is over' do
    game = described_class.new(board, ui, *setup_players([0, 1, 2], [3, 4]))

    game.play

    expect(ui.board_display_count).to eq(6)
  end

  it 'gets Ui to display game over at the end' do
    game = setup_for_draw

    game.play

    expect(ui.game_over_count).to eq(1)
  end

  it 'gets Ui to display winner at the end of the won game' do
    game = setup_for_win

    game.play

    expect(ui.winner_display_count).to eq(1)
  end

  it 'gets Ui to announce draw when drawn' do
    game = setup_for_draw

    game.play

    expect(ui.draw_display_count).to eq(1)
  end

  def setup_for_win
    described_class.new(board, ui, *setup_players([0, 1, 2], [3, 4]))
  end

  def setup_for_draw
    described_class.new(board, ui, *setup_players([0, 1, 4, 5, 6], [2, 3, 7, 8]))
  end

  def setup_players(x_moves, o_moves)
    [FakePlayer.new(:x, x_moves), FakePlayer.new(:o, o_moves)]
  end

  class FakePlayer
    attr_reader :moves, :mark
    def initialize(mark, moves = [])
      @mark = mark
      @moves = moves
    end

    def pick_position(board)
      moves.shift
    end
  end

  class FakeUi
    attr_reader :board_display_count,
                :winner_display_count,
                :draw_display_count,
                :game_over_count,
                :invalid_option_count
    def initialize
      @board_display_count = 0
      @winner_display_count = 0
      @draw_display_count = 0
      @game_over_count = 0
      @invalid_option_count = 0
    end

    def display_board(board)
      @board_display_count += 1
    end

    def display_winner(winner)
      @winner_display_count += 1
    end

    def display_draw
      @draw_display_count += 1
    end

    def display_game_over
      @game_over_count += 1
    end

    def notify_of_invalid_option
      @invalid_option_count += 1
    end
  end
end
