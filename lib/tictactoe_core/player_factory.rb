require 'tictactoe_core/ai_negamax'
require 'tictactoe_core/player'

module TictactoeCore
  class PlayerFactory
    def self.make_players(players_code, ui)
      case players_code
      when 'hvh'
        player_x = make_human_player(:x, ui)
        player_o = make_human_player(:o, ui)
      when 'cvh'
        player_x = make_ai_player(:x, :o)
        player_o = make_human_player(:o, ui)
      when 'hvc'
        player_x = make_human_player(:x, ui)
        player_o = make_ai_player(:o, :x)
      when 'cvc'
        player_x = make_ai_player(:x, :o)
        player_o = make_ai_player(:o, :x)
      end
      [player_x, player_o]
    end

    def self.make_human_player(mark, ui)
      Player.new(mark, ui)
    end

    def self.make_ai_player(mark, opponent_mark)
      AiNegamax.new(mark, opponent_mark)
    end
  end
end
