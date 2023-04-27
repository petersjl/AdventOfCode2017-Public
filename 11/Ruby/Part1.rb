require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        puts "The child is #{solve_puzzle()} steps away"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(str)
    return str.split(",")
end

def solve_puzzle(input = nil)
    if not input then input = Utils.read(File.join(File.dirname(__FILE__), "../input.txt")) end
    input = parse_input(input)
    pos = find_pos(input)
    return hex_distance(pos)
end

def find_pos(directions)
    x = 0
    y = 0
    for direction in directions do
        case direction
        when "n"
            y += 1
        when "s"
            y -= 1
        when "ne"
            x += 1
        when "sw"
            x -= 1
        when "nw"
           x -= 1
           y += 1
        when "se"
            x += 1
            y -= 1
        else
            raise "Invalid direction in input"
        end 
    end
    return [x,y]
end

def hex_distance(pos)
    if pos[0] >= 0
        lower = [0,0]
        upper = pos
    else
        lower = pos
        upper = [0,0]
    end

    distance = 0
    if upper[1] > lower[1]
        distance = upper[0] - lower[0] + upper[1] - lower[1]
    elsif lower[0] + lower[1] > upper[0] + upper[1]
        distance = lower[1] - upper[1]
    else
        distance = upper[0] - lower[0]
    end
    return distance
end

def run_tests()
    assert_equal(3, solve_puzzle("ne,ne,ne"))
    assert_equal(0, solve_puzzle("ne,ne,sw,sw"))
    assert_equal(2, solve_puzzle("ne,ne,s,s"))
    assert_equal(3, solve_puzzle("se,sw,se,sw,sw"))
    puts "All tests passed"
end

main(false)