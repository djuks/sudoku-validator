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
    data = [get_rows, get_columns, get_square]
    result = nil

    data.each do |value|
      if data.map{|v| is_valid(v)}.include?(false)
        result = 'Sudoku is invalid.'
      elsif zero_check(value) == false && is_valid(value)
        result = 'Sudoku is valid but incomplete.'
      else
        result = 'Sudoku is valid.'
      end
    end

    result
  end

  private

  def zero_check(data)
    result = nil
    data.each do |row|
      if row.include?('0')
        result = false
        break
      else
        result = true
      end
    end

    result
  end

  def is_valid(data)
    result = nil
    data.each do |row|
      if duplication_check(row.tr('0', '').chars)
        result = true
      else
        result = false
        break
      end
    end

    result
  end

  def duplication_check(arr)
    if arr.count == arr.uniq.count
      true
    else
      false
    end
  end

  def get_rows
    lines = @puzzle_string.delete("^0-9\n").lines.delete_if { |x| x == "\n" }
    rows = []
    lines.each do |line|
      rows << line.chomp!
    end

    rows
  end

  def get_columns
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

  def get_square
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
