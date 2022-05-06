require 'byebug'

class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    rows = get_rows
    columns = get_columns
    square = get_square
    # check for duplicated in each string
    # check for zeros
  end

  private

  def get_rows
    lines = @puzzle_string.delete("^0-9\n").lines.delete_if {|x| x == "\n" }
    rows = []
    lines.each do |line|
      rows << line.chomp!
    end

    rows
  end

  def get_columns
    lines = @puzzle_string.delete("^0-9\n").lines.delete_if {|x| x == "\n" }
    columns = []
    lines.each_with_index do |line, line_index|
      line.chomp.split('').each_with_index do |char, index|
        if line_index.zero?
          columns << char
        else
          columns[index] += char
        end
      end
    end
    columns
  end

  def get_square
    lines = @puzzle_string.delete("^0-9\n").lines.delete_if {|x| x == "\n" }
    squares = Array.new(9, '')
    lines.each_with_index do |line, line_index|
      line.chomp.scan(/.{3}/).each_with_index do |char, index|
        if line_index <= 2
          squares[index] += char
        elsif (3..5).include?(line_index)
          squares[index + 3] += char
        else
          squares[index + 6] += char
        end
      end
    end
    squares
  end
end
