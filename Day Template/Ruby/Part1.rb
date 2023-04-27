require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        puts "#{solve_puzzle()}"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(str)
    return str
end

def solve_puzzle(input = nil)
    if not input then input = Utils.read(File.join(File.dirname(__FILE__), "../input.txt")) end
    input = parse_input(input)
    return input
end

def run_tests()
    assert_equal(1, 1)
    puts "All tests passed"
end

main(true)