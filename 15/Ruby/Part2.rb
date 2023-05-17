require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt"), true))
        puts "In 5M checks there were #{solution} matches"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(input)
    parsed = input.map { |line| line.split()[4].to_i }
    return parsed
end

def solve_puzzle(input)
    input = parse_input(input)
    return run_iterations(input[0], input[1], 5000000)
end

def run_iterations(a, b, count, print_runs = false)
    match_count = 0
    iteration = 0
    if print_runs then puts "--Gen. A--  --Gen. B--  Check" end
    while iteration < count do
        a, b = generate_next_pair(a,b)
        is_match = check_equality(a,b)
        if is_match then match_count += 1 end
        iteration += 1
        if print_runs
            puts "#{a.to_s.rjust(10, " ")}  #{b.to_s.rjust(10, " ")}  #{is_match ? "O" : "X"}"
        else
            case iteration
            when count / 4
                puts "25% done"
            when count / 2
                puts "50% done"
            when count * 3/4
                puts "75% done"
            end
        end
    end
    return match_count
end

def check_equality(a, b)
    return (a & 65535) == (b & 65535) # & 65535 clears out all but the lowest 16 bits and then check equality
end

def generate_next_pair(a, b)
    loop do
        a = (a * 16807) % 2147483647
        break if a % 4 == 0
    end
    loop do
        b = (b * 48271) % 2147483647
        break if b % 8 == 0
    end
    return [a,b]
end

def run_tests()
    assert_equal(true, check_equality(245556042, 1431495498))
    assert_equal([1352636452, 1233683848], generate_next_pair(65, 8921))
    assert_equal(0, run_iterations(65, 8921, 5, true))
    assert_equal(309, run_iterations(65, 8921, 5000000))
    puts "All tests passed"
end

main()