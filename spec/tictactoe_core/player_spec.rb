require 'tictactoe_core/player'
require 'tictactoe_core/board'

describe TictactoeCore::Player do
  it 'gets move from user' do
    ui = double(get_move_from_user: 0).as_null_object
    board = TictactoeCore::Board.new
    player = described_class.new(:x, ui)
    expect(player.pick_position(board)).to eq(0)
  end
end
