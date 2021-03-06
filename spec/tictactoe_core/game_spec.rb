require 'tictactoe_core/game'
require 'tictactoe_core/board'

RSpec::Matchers.define :have_different_marks_at do |a, b|
  match do |actual|
    actual.mark_at(a) != actual.mark_at(b)
  end
end

describe TictactoeCore::Game do
  let(:ui)          { double('ui').as_null_object }
  let(:player_x)    { FakePlayer.new(:x) }
  let(:player_o)    { FakePlayer.new(:o) }
  let(:board_class) { TictactoeCore::Board }
  let(:board)       { board_class.new }

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

    expect(game.board).to have_different_marks_at(0, 1)
  end

  it 'gets Ui to inform on invalid move' do
    game = described_class.new(board, ui, *setup_players(['a', 0], []))

    game.play_turn

    expect(ui).to have_received(:notify_of_invalid_option)
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

  it 'gets Ui to display the board on each turn' do
    game = described_class.new(board, ui, *setup_players([0], []))

    game.play_turn

    expect(ui).to have_received(:display_board)
  end

  it 'gets Ui to clear screen after each turn' do
    game = described_class.new(board, ui, *setup_players([0], []))

    game.play_turn

    expect(ui).to have_received(:clear_screen).exactly(1).times
  end

  it 'gets ui to display board one extra time after it is over' do
    game = described_class.new(board, ui, *setup_players([0, 1, 2], [3, 4]))

    game.play

    expect(ui).to have_received(:display_board).exactly(6).times
  end

  it 'gets Ui to display game over at the end' do
    game = setup_for_draw

    game.play

    expect(ui).to have_received(:display_game_over)
  end

  it 'gets Ui to display winner at the end of the won game' do
    game = setup_for_win

    game.play

    expect(ui).to have_received(:display_winner)
  end

  it 'gets Ui to announce draw when drawn' do
    game = setup_for_draw

    game.play

    expect(ui).to have_received(:display_draw)
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
end
