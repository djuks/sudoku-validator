# frozen_string_literal: true

require 'byebug'

class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    data = [rows, columns, squares]

    data.each do |value|
      if data.map { |v| valid?(v) }.include?(false)
        return 'Sudoku is invalid.'
      elsif zeros?(value) == false && valid?(value)
        return 'Sudoku is valid but incomplete.'
      else
        return 'Sudoku is valid.'
      end
    end
  end

  private

  def zeros?(data)
    data.each do |row|
      if row.include?('0')
        return false
      else
        return true
      end
    end
  end

  def valid?(data)
    result = nil
    data.each do |row|
      arr_row = row.tr('0', '').chars
      if arr_row.count == arr_row.uniq.count
        result = true
      else
        result = false
        break
      end
    end
    result
  end

  def rows
    lines = @puzzle_string.delete("^0-9\n").lines.delete_if { |x| x == "\n" }
    rows = []
    lines.each do |line|
      rows << line.chomp!
    end

    rows
  end

  def columns
    lines = @puzzle_string.delete("^0-9\n").lines.delete_if { |x| x == "\n" }
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

  def squares
    lines = @puzzle_string.delete("^0-9\n").lines.delete_if { |x| x == "\n" }
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
