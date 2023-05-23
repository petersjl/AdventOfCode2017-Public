require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt")))
        puts "The number after the last insert is #{solution}"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(input)
    return input.to_i
end

def solve_puzzle(input)
    input = parse_input(input)
    return run_to_num(50000000, input)
end

def run_to_num(count, skip)
    len = 1
    current_num = 1
    index = 0
    prev = 0
    hold = nil
    while current_num <= count
        index = ((index + skip) % len) + 1 # move to skip plus pone
        len += 1 # fake adding to list
        if index == 1 # save the current num if we're at index 1
            hold = current_num
        end
        current_num += 1 # increase the number we "inserted"
    end
    return hold
end

def run_tests()
    assert_equal(638, run_to_num(100, 3))
    puts "All tests passed"
end

main()