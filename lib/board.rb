require_relative 'player'
require_relative 'errors/input_error'
require_relative 'errors/not_possible_to_win_error'
require_relative 'chip'
require_relative 'empty_square'
require 'colorize'
require 'byebug'

class Board
  attr_accessor :grid,  :column_count, :next_open_row
  attr_reader :chip_position

  def initialize(row_count, column_count, num_of_chips)
    @row_count, @column_count, @chips_in_row = row_count, column_count, num_of_chips
    @grid = Array.new(@row_count) { Array.new(@column_count) { EmptySquare.new } }
    @next_open_row = Array.new(@column_count) { @row_count - 1 }
  end

  def [](row, column)
    @grid[row][column]
  end

  def []=(row, column, chip)
    @grid[row][column] = chip
  end

  def drop_chip(column, chip)
    row = next_open_row[column]
    self[row, column] = chip if self[row, column].empty?
    next_open_row[column] = row - 1
    @chip_position = [row, column]
  end

  def game_over?(current_pos)
    return true if game_draw?
    row, col = current_pos
    current_player_color = self[row, col].color
    return true if check_row(current_player_color, current_pos)
    return true if check_col(current_player_color, current_pos)
    return true if check_left_diag(current_player_color, current_pos)
    return true if check_right_diag(current_player_color, current_pos)
    false
  end

  def game_draw?
    next_open_row.all? { |i| i == -1 }
  end

  def render
    render_column_numbers
    @grid.each_with_index do |row, r_idx|
      print_row = []
      row.each_with_index do |chip, c_idx|
        if (r_idx.odd? && c_idx.odd?) || (r_idx.even? && c_idx.even?)
          print_row << chip.render.colorize(:background => :black)
        else
          print_row << chip.render.colorize(:background => :white)
        end
      end
      puts "         " + print_row.join()
    end
  end

  private
    def render_column_numbers
      arr = (0...@column_count).to_a.select { |num| num % 2 == 0 }.map(&:to_s)
      c_label = []
      arr.map do |col|
        c_label << col + ((" ") * (4 - col.length))
      end
      puts "columns: " + c_label.join()
    end

    def on_board?(row, col)
      return false if row < 0 || col < 0 || row >= @row_count ||
                      col >= @column_count
      return true
    end

    def check_row(color, pos)
      row, col = pos
      count = 1
      diff = [[0, 1], [0, -1]]
      check_positions(color, pos, diff, count)
    end

    def check_col(color, pos)
      row, col = pos
      count = 1
      diff = [[1, 0]]
      check_positions(color, pos, diff, count)
    end

    def check_left_diag(color, pos)
      row, col = pos
      count = 1
      diff = [[-1, -1], [1, 1]]
      check_positions(color, pos, diff, count)
    end

    def check_right_diag(color, pos)
      row, col = pos
      count = 1
      diff = [[-1, 1], [1, -1]]
      check_positions(color, pos, diff, count)
    end


    def check_positions(color, pos, diff, count)
      current_pos = pos
      diff.each do |dy, dx|
        (@chips_in_row - 1).times do
          new_row, new_col = [current_pos[0] + dy, current_pos[1] + dx]
          if on_board?(new_row, new_col)
            if self[new_row, new_col].color == color
              count += 1
            end
            # prematurely breaks out of the loop if there is no next chip or next
            # chip is of opposite color
            break if next_chip_is_empty_or_opposite?(new_row, new_col, color)
          end
          # breaks out of the loop if new position is not on the board to avoid
          # unnecessary checking
          break unless on_board?(new_row, new_col)
          # resets the current position to previously checked position
          current_pos = [new_row, new_col]
          return true if count == @chips_in_row
        end
        # resets the current position to original position, where the chip was
        # dropped
        current_pos = pos
      end
      return true if count == @chips_in_row
      false
    end

    def next_chip_is_empty_or_opposite?(row, col, color)
      self[row, col].color.nil? || self[row, col].opposite_color == color
    end


    attr_accessor :row_count, :chips_in_row
end
