# Varun's Connect Four

## Instructions
- `bundle install` - Requires colorize and rspec gems.
- `ruby lib/connect_four.rb`
- Follow game Instructions

## Time Spent
- I spent about 1.5 hr trying to solve the core of the problem. That involved coming up with an algorithm for `Board#drop_chip` and `Board#game_over?` methods.
- I spent another 30-40 min working on 'ConnectFour#Play' method.
- Another 1 hr or so was spent for making the game pretty and error handling

## Key Decisions and Time Complexity
- `Board#drop_chip` - Constant Time - When user drops a chip in particular column, `next_open_row` array gets updated. `next_open_row` keeps track of next open slot in each column. This makes my `#drop_chip` method constant time because all you are doing is looking up the column number in an array when you drop a chip.

- `Board#game_draw?` - Linear Time - Since this method relies on `next_open_row` array, it's linear time. It just checking to make sure that all elements on `next_open_row` are set to '-1', meaning no more empty slots on the board. Since `next_open_row`'s length is same as number of columns, all you have to do is iterate through an array once, making this method a linear time.

- `Board#game_over?` - Linear Time - Since I know the number of adjacent chips I need to win, I am only checking (3 * (2 * (# of adjacent chips - 1)) + (# of adjacent chips - 1) positions in worst case (row, left diagonal, right diagonal, bottom of the column). I also optimized my algorithm to check minimum number of positions by starting from the position where chip was dropped and moving outwards from that point on. It stops moving in particular direction as soon as the position is not on the board, position is empty, or it contains a chip of opposite color. It also stops checking as soon as it has found a winning condition. I am also checking if the game is draw, but as previously mentioned, that algorithm takes linear time. So, overall, my `#game_over?` method takes a linear time.

## Overall thoughts
- Building this game was lot of fun! It was pretty straight forward. Giving users the ability to choose grid size and number of adjacent chips to win added a bit of a challenge, but nothing too complicated. I ended up using colorize and Unicode characters for chips to make the board look bit nicer. 
