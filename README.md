# TictactoeCore

Provides the core logic for a game of TicTacToe

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tictactoe_core'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tictactoe_core

## Usage

This gem provides all components necessary for the game of tictactoe:
- Board
- Game
- Player (human)
- AiNegamax (computer player)
- PlayerFactory

You can require individual classes, for example:
`require "tictactoe_core/board"`

Or if you want to use everything, then following is sufficient:
`require "tictactoe_core"`


## Contributing

1. Fork it ( https://github.com/[my-github-username]/tictactoe_core/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
