require 'tictactoe_core/player_factory'

describe TictactoeCore::PlayerFactory do
  let(:ui)           { double.as_null_object }
  let(:ai_class)     { TictactoeCore::AiNegamax }
  let(:player_class) { TictactoeCore::Player }

  it 'creates players with correct marks' do
    player_x, player_o = described_class.make_players('hvh', ui)

    expect(player_x.mark).to eq(:x)
    expect(player_o.mark).to eq(:o)
  end

  it 'returns human players for human vs human game' do
    player_x, player_o = described_class.make_players('hvh', ui)

    expect(player_x).to be_instance_of(player_class)
    expect(player_o).to be_instance_of(player_class)
  end

  it 'returns computer players for computer vs computer game' do
    player_x, player_o = described_class.make_players('cvc', ui)

    expect(player_x).to be_instance_of(ai_class)
    expect(player_o).to be_instance_of(ai_class)
  end

  it 'returns computer as x and human as o players for computer vs human game' do
    player_x, player_o = described_class.make_players('cvh', ui)

    expect(player_x).to be_instance_of(ai_class)
    expect(player_o).to be_instance_of(player_class)
  end

  it 'returns human as x and computer as o players for human vs computer game' do
    player_x, player_o = described_class.make_players('hvc', ui)

    expect(player_x).to be_instance_of(player_class)
    expect(player_o).to be_instance_of(ai_class)
  end
end
