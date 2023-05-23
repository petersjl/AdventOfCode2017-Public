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
    return run_to_num(2017, input)
end

def run_to_num(count, skip)
    arr = [0]
    current_num = 1
    index = 0
    while current_num <= count
        index = ((index + skip) % arr.length) + 1
        arr.insert(index, current_num)
        current_num += 1
    end
    return arr[index + 1]
end

def run_tests()
    assert_equal(638, run_to_num(2017, 3))
    puts "All tests passed"
end

main()