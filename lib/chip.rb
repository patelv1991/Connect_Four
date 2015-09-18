class Chip
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def empty?
    false
  end

  def symbols
    {
      white: "\u25C9 ".light_blue,
      black: "\u25C9 ".red
    }
  end

  def opposite_color
    return :white if color == :black
    :black
  end

  def render
    symbols[color]
  end

end
