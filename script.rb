# frozen_string_literal: true

module TicTacToe
  LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
  PLAYER_ONE = 1
  PLAYER_TWO = 2

  # instantiate class
  class Game
    def initialize
      @board = Array.new(9)
      @row_positions = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
      @current_player_id = 1
      @win_lines = LINES
      print_board(nil, nil)
      print "\nPlayer one starts, choose your position: "
      @player_choice = gets.chomp
      puts
    end

    def start_game
      rows = row_position_number
      first_round(@current_player_id, rows)
    end

    def first_round(player, rows)
      if !'123456789'.include?(@player_choice)
        not_available(@player_choice)
      else
        print_board(player, rows)
        win_lines
        switch_player
      end
    end

    def remaining_rounds
      if @board.include?(@player_choice) || !'123456789'.include?(@player_choice)
        not_available(@player_choice)
      else
        rows = row_position_number
        print_board(@current_player_id, rows)
        win_lines
        return player_winner(@current_player_id) if player_won?

        return draw if free_positions.empty?

        switch_player
      end
    end

    def play_game
      if @current_player_id == 2
        print "\nPlayer two, choose your position: "
      else
        print "\nPlayer one, choose your position: "
      end
      @player_choice = gets.chomp
      puts
      remaining_rounds
    end

    def switch_player
      if @current_player_id == PLAYER_ONE
        @current_player_id = PLAYER_TWO
      else
        @current_player_id = PLAYER_ONE
      end
      play_game
    end

    def player_choice(player, choice)
      @row_positions[choice[0]][choice[1]] = 'X' if player == 1
      @row_positions[choice[0]][choice[1]] = 'O' if player == 2
    end

    def win_lines
      @win_lines.each_with_index do |line, i|
        if line.include?(@player_choice.to_i) && @current_player_id == 1
          line.each_with_index do |position, j|
            @win_lines[i][j] = 'X' if position == @player_choice.to_i
          end
        elsif line.include?(@player_choice.to_i) && @current_player_id == 2
          line.each_with_index do |position, j|
            @win_lines[i][j] = 'O' if position == @player_choice.to_i
          end
        end
      end
    end

    def player_won?
      @win_lines.any? do |line|
        line.all? { |position| position == 'X' } ||
          line.all? { |position| position == 'O' }
      end
    end

    def player_winner(player_winner)
      player_name = 'Player1' if player_winner == 1
      player_name = 'Player2' if player_winner == 2
      "Congratulations #{player_name}. You're the winner!"
    end

    def draw
      "\nIt's a draw! Play it again."
    end

    def not_available(choice)
      print_board(nil, nil)
      print "\nPosition #{choice} not available. Pick a position available above: "
      @player_choice = gets.chomp
      puts
      remaining_rounds
    end

    def row_position_number
      @board.pop
      @board.unshift(@player_choice)
      if @player_choice.to_i < 4
        [0, @player_choice.to_i - 1]
      elsif @player_choice.to_i < 7
        [1, @player_choice.to_i - 4]
      else
        [2, @player_choice.to_i - 7]
      end
    end

    def free_positions
      (0..8).select { |position| @board[position].nil? }
    end

    def print_board(player, choice)
      col_separator = ' | '
      row_separator = '--+---+--'
      player_choice(player, choice) if player
      rows = []
      @row_positions.each_index do |i|
        rows.push(col_separator + @row_positions[i][1].to_s + col_separator)
        puts @row_positions[i][0].to_s + rows[i] + @row_positions[i][2].to_s
        puts row_separator if i != 2
      end
    end
  end
end

include TicTacToe

play = Game.new
puts play.start_game
