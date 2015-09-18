require_relative 'board'
require_relative 'errors/col_already_full'

class ConnectFour

  attr_accessor :board

  def initialize
    display_instructions
    @players = build_players_arr
    puts ""
    puts "Board Information"
    @board = setup_board
  end

  def play
    loop do
      @current_player = @players.first
      display_board
      col = get_col_num
      @board.drop_chip(col, Chip.new(@current_player.color))
      if @board.game_over?(@board.chip_position)
        display_winner
        return
      end
      rotate_players
    end
  end

  private
    def display_instructions
      puts "-----------------------------"
      puts "| Welcome to Connect 'Four' |"
      puts "-----------------------------"
      puts "\nPlayer Information"
    end

    def display_board
      system('clear')
      puts "It's #{@current_player.name}'s turn!\n "
      @board.render
      print "\nEnter the column number (0 to #{@board.column_count - 1}): "
    end

    def rotate_players
      @players[0], @players[1] = @players[1], @players[0]
    end

    def get_col_num
      begin
        input = gets.chomp
        raise InputError unless input.match(/^\d+$/) && input.to_i >= 0 &&
                                input.to_i < @board.column_count
        raise ColAlreadyFull if @board.next_open_row[input.to_i] == -1
      rescue InputError
        print "Invalid input. Please try again: "
        retry
      rescue ColAlreadyFull
        print "That column is already full. Please try again: "
        retry
      end
      input.to_i
    end

    def display_winner
      system('clear')
      if @board.game_draw?
        puts "It's a draw!\n "
      else
        puts "#{@current_player.name} won!\n "
      end
      @board.render
    end

    def build_players_arr
      print "Enter first player's name: "
      player1 = Player.new(get_name, :white)

      print "Enter second player's name: "
      player2 = Player.new(get_name, :black)

      puts ""
      puts "#{player1.name}'s chips: #{Chip.new(player1.color).render}"
      puts "#{player2.name}'s chips: #{Chip.new(player2.color).render}"

      [player1, player2]
    end

    def get_name
      begin
        input = gets.chomp
        raise "Not enough chars entered" if input.nil?
      rescue => error
        print "Please enter at least one character: "
        retry
      end
      input
    end

    def setup_board
      row_count, column_count = get_grid_info_from_user
      num_of_chips = get_number_of_adjacent_chips_to_win
      Board.new(row_count, column_count, num_of_chips)
    end

    def get_grid_info_from_user
      print "Please enter the number of rows ( > 2): "
      rows = get_user_input(false).to_i

      print "Please enter the number of columns ( > 2): "
      columns = get_user_input(false).to_i
      @max_adjacent_chips = (rows > columns) ? rows : columns
      [rows, columns]
    end

    def get_number_of_adjacent_chips_to_win
      print "Please enter the number of adjacent chips to win: "
      get_user_input(true).to_i
    end

    def get_user_input(chips)
      begin
        input = gets.chomp
        raise InputError unless input.match(/^\d+$/) && input.to_i > 2
        if chips && (input.to_i > @max_adjacent_chips)
          raise NotPossibleToWinError
        end
      rescue InputError
        print "Invalid input. Please try again: "
        retry
      rescue NotPossibleToWinError
        puts "Number of adjacent chips are larger than either number of rows" +
             " or columns."
        print "Please try again: "
        retry
      end
      input
    end

    attr_reader :players
end

if __FILE__ == $PROGRAM_NAME
  system('clear')
  game = ConnectFour.new
  game.play
end
