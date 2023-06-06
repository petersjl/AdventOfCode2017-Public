require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt"), true))
        puts "Program 1 sent #{solution} messages"
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
    program0 = Program.new(0, instructions)
    program1 = Program.new(1, instructions)
    loop do
        check0 = program0.run(program1)
        check1 = program1.run(program0)
        break if !(check0 || check1)
    end
    return program1.sent_count
end

class Program

    attr_accessor :sent
    
    def initialize(id, instructions)
        @id = id
        @registers = Hash.new(0)
        @registers["p"] = @id
        @instructions = instructions
        @index = 0
        @sent_count = 0
        @sent = []
        @waiting = false
    end

    def sent_count() return @sent_count end

    def has_next_value?() return @sent.count > 0 end

    def get_next_value() return @sent.shift() end

    def run(sender)
        if @waiting  and !sender.has_next_value?() then return false end
        @waiting = false

        while true
            current = @instructions[@index]
            case current[0]
            when "snd"
                @sent.push(ParseOrGet(current[1], @registers))
                @sent_count += 1
            when "set"
                @registers[current[1]] = ParseOrGet(current[2], @registers)
            when "add"
                @registers[current[1]] += ParseOrGet(current[2], @registers)
            when "mul"
                @registers[current[1]] *= ParseOrGet(current[2], @registers)
            when "mod"
                @registers[current[1]] %= ParseOrGet(current[2], @registers)
            when "rcv"
                if !sender.has_next_value?()
                    @waiting = true
                    break
                end
                @registers[current[1]] = sender.get_next_value()
            when "jgz"
                if ParseOrGet(current[1], @registers) > 0
                    @index += ParseOrGet(current[2], @registers)
                    next
                end
            else
                raise "Invalid instruction #{current[0]} found in input"
            end
            @index += 1
        end
        return true
    end
end

def ParseOrGet(val, dictionary)
    return Integer(val, exception: false) ? val.to_i : dictionary[val]
end

def run_tests()
    assert_equal(3, solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../testInput2.txt"), true)))
    puts "All tests passed"
end

main()