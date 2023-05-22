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
    moves, subs = collect_instructions(input, programs)
    programs = run_rounds(programs, moves, subs, 1000000000)
    return programs.join("")
end

def run_rounds(programs, moves, subs, rounds)
    while rounds > 0
        if (rounds & 1) == 1
          # Apply the current 2**n dance
          programs = moves.map { |i| subs[programs[i]] }
        end
    
        # Double the number of dances each application will perform
        moves = moves.map { |i| moves[i] }
        subs = subs.transform_values { |v| subs[v] }
    
        rounds >>= 1
      end
    return programs
end

def run_moves(programs, moves)
    new_order = []
    for i in 0...programs.length do
        new_order << programs[moves[i]]
    end
    return new_order
end

def run_subs(programs, subs)
    new_order = []
    for i in 0...programs.length do
        new_order << subs[programs[i]]
    end
    return new_order
end

def collect_instructions(instructions, programs)
    moves = (0...(programs.size)).to_a
    subs = Hash[programs.map { |x| [x,x]}]

    for instruction in instructions do
        case instruction[0]
        when "s"
            moves.rotate!(-instruction[1].to_i)
        when "x"
            x = instruction[1].to_i
            y = instruction[2].to_i
            moves[x], moves[y] = moves[y], moves[x]
        when "p"
            subs.each do |k,v|
                subs[k] = instruction[1] if v == instruction[2]
                subs[k] = instruction[2] if v == instruction[1]
            end
        end
    end
    return [moves,subs]
end

def run_tests()


    programs = "abcde".split("")
    instructions = parse_input("s1,x3/4,pe/b")
    moves, subs = collect_instructions(instructions, programs)
    programs = run_moves(programs, moves)
    programs = run_subs(programs, subs)
    assert_equal("baedc".split(""), programs)

    programs = run_moves(programs, moves)
    programs = run_subs(programs, subs)
    assert_equal("ceadb".split(""), programs)
    puts "All tests passed"
end

main()