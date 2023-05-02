require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt"), true))
        puts "The group with 0 contains #{solution} programs"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(input)
    hash = {}
    input.map do |line|
        parts = line.split(" <-> ")
        ns = parts[1].split(",").map do |s| s.to_i end
        hash[parts[0].to_i] = ns
    end
    return hash
end

def solve_puzzle(input)
    input = parse_input(input)
    return find_group(input, 0).length()
end

def find_group(programs, id)
    queue = []
    seen = Set.new()
    queue.push(id)
    seen.add(id)
    while not queue.empty? do
        current_id = queue.shift()
        current_programs = programs[current_id]
        for program in current_programs do
            if seen.include?(program) then next end
            queue << program
            seen.add(program)
        end
    end
    return seen.to_a()
end

def run_tests()
    assert_equal(6, solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../testinput1.txt"), true)))
    assert_equal(4, solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../testinput2.txt"), true)))
    puts "All tests passed"
end

main()