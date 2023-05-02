require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt"), true))
        puts "Can get through unseen by waiting #{solution} picoseconds"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(input)
    scanners = {}
    for line in input do
        parts = line.split(": ")
        scanners[parts[0].to_i] = Scanner.new(parts[0].to_i, parts[1].to_i)
    end
    return scanners
end

def solve_puzzle(input)
    scanners = parse_input(input)
    max = 0
    for s in scanners.keys do
        if s > max then max = s end
    end

    scanners.each do |depth, scanner|
        for i in 0...depth do scanner.step end
    end

    delay = 0
    while true do
        pass = true
        scanners.each_value {|s| if s.is_at_0? then pass = false; break end}
        break if pass
        delay += 1
        scanners.each_value { |s| s.step}
    end

    return delay
end

class Scanner
    def initialize(depth, range)
        @depth = depth
        @range = range
        @index = 0
        @increasing = true
    end

    def is_at_0?()
        return @index == 0
    end

    def get_severity()
        return @depth * @range
    end

    def step()
        if @increasing
            step_up()
        else
            step_down()
        end
    end

    private

    def step_up()
        @index += 1
        if @index >= @range
            @index -= 2
            @increasing = false
        end
    end

    def step_down()
        @index -= 1
        if @index < 0
            @index += 2
            @increasing = true
        end
    end
end

def run_tests()
    assert_equal(10, solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../testinput1.txt"), true)))
    puts "All tests passed"
end

main()