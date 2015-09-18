require 'board'

describe Board do
  subject(:board) { Board.new(6, 7, 4) }

  describe "#drop_chip" do
    it "drops a chip at the right position" do
      board.drop_chip(3, Chip.new(:black))
      board.drop_chip(3, Chip.new(:white))
      expect(board[4, 3].color).to be(:white)
    end
  end

  describe "#game_over?" do
    before(:each) do
      board.drop_chip(0, Chip.new(:black))
      board.drop_chip(1, Chip.new(:white))
      board.drop_chip(2, Chip.new(:black))
      board.drop_chip(3, Chip.new(:black))
      board.drop_chip(5, Chip.new(:black))
    end

    it "returns false if game is not over" do
      board.drop_chip(4, Chip.new(:white))
      expect(board.game_over?([5, 4])).to be(false)
    end

    it "returns true if game is over" do
      board.drop_chip(4, Chip.new(:black))
      expect(board.game_over?([5, 4])).to be(true)
    end
  end


end
