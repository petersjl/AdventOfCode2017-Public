require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt")))
        puts "The resulting order is: #{solution}"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(input)
    return input.split(",").map {|ins| [ins[0]].concat(ins[1..-1].split("/"))}
end

def solve_puzzle(input)
    input = parse_input(input)
    programs = "abcdefghijklmnop".split("")
    run_instructions(input, programs)
    return programs.join("")
end

def spin(programs, count)
    for i in 0...(count.to_i)
        programs.unshift(programs.pop())
    end
end

def exchange(programs, a, b)
    a = a.to_i
    b = b.to_i
    hold = programs[a]
    programs[a] = programs[b]
    programs[b] = hold
end

def partner(programs, a, b)
    ia = programs.find_index(a)
    ib = programs.find_index(b)
    exchange(programs, ia, ib)
end

def run_instructions(instructions, programs)
    for instruction in instructions do
        case instruction[0]
        when "s"
            spin(programs, instruction[1])
        when "x"
            exchange(programs, instruction[1], instruction[2])
        when "p"
            partner(programs, instruction[1], instruction[2])
        end
    end
end

def run_tests()
    programs = "abcde".split("")
    spin(programs, 3)
    assert_equal("cdeab".split(""), programs)

    programs = "abcde".split("")
    exchange(programs, "1", "3")
    assert_equal("adcbe".split(""), programs)

    programs = "abcde".split("")
    partner(programs, "a", "d")
    assert_equal("dbcae".split(""), programs)

    programs = "abcde".split("")
    instructions = parse_input("s1,x3/4,p3/b")
    run_instructions(instructions,programs)
    assert_equal("baedc".split(""), programs)
    puts "All tests passed"
end

main()