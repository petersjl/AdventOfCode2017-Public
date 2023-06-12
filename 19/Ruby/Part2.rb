require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt"), true))
        puts "The packet traveled #{solution} steps"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(input)
    return input.map{|line| 
        line.split("").map{|char| 
            char == " " ? nil : char }}
end

def solve_puzzle(input)
    map = parse_input(input)
    row = 0
    col = map[0].find_index{|char| char}
    direction = :down
    step_count = 1
    loop do
        result = move_to_next_spot(row, col, direction, map)
        break unless result
        step_count += 1
        row = result[0]
        col = result[1]
        direction = result[2]
    end
    return step_count
end

def move_to_next_spot(row, col, direction, map)
    # Try to go straight
    case direction
    when :up
        if check_spot(row - 1, col, map)
            return [row - 1, col, direction]
        end
    when :down
        if check_spot(row + 1, col, map)
            return [row + 1, col, direction]
        end
    when :left
        if check_spot(row, col - 1, map)
            return [row, col - 1, direction]
        end
    when :right
        if check_spot(row, col + 1, map)
            return [row, col + 1, direction]
        end
    end

    # Try to turn
    case direction
    when :up, :down
        if check_spot(row, col - 1, map)
            return [row, col - 1, :left]
        elsif check_spot(row, col + 1, map)
            return [row, col + 1, :right]
        end
    when :left, :right
        if check_spot(row - 1, col, map)
            return [row - 1, col, :up]
        elsif check_spot(row + 1, col, map)
            return [row + 1, col, :down]
        end
    end
    return nil
end

def check_spot(row, col, map)
    return (row > 0 and row < map.length and col > 0 and col < map[0].length and map[row][col])
end

def run_tests()
    assert_equal(38, solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../testInput1.txt"), true)))
    puts "All tests passed"
end

main()