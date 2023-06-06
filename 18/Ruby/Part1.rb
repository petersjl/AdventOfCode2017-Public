require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt"), true))
        puts "The last sent signal is #{solution}"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(input)
    return input.map { |line| line.split}
end

def solve_puzzle(input)
    instructions = parse_input(input)
    registers = Hash.new(0)
    last_sent = nil
    index = 0
    while true
        current = instructions[index]
        case current[0]
        when "snd"
            last_sent = registers[current[1]]
        when "set"
            registers[current[1]] = Integer(current[2], exception: false) ? current[2].to_i : registers[current[2]]
        when "add"
            registers[current[1]] += Integer(current[2], exception: false) ? current[2].to_i : registers[current[2]]
        when "mul"
            registers[current[1]] *= Integer(current[2], exception: false) ? current[2].to_i : registers[current[2]]
        when "mod"
            registers[current[1]] %= Integer(current[2], exception: false) ? current[2].to_i : registers[current[2]]
        when "rcv"
            break if registers[current[1]] != 0
        when "jgz"
            if registers[current[1]] > 0
                index += Integer(current[2], exception: false) ? current[2].to_i : registers[current[2]]
                next
            end
        else
            raise "Invalid instruction #{current[0]} found in input"
        end
        index += 1
    end
    return last_sent
end

def run_tests()
    assert_equal(4, solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../testInput1.txt"), true)))
    puts "All tests passed"
end

main()