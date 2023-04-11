require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"))
    return input.to_i()
end

def solve_puzzle()
    input = parse_input()
    power = find_power(input)
    middles = get_middles(power)
    smallest_diff = 10 ** 100
    for i in middles
        diff = (input - i).abs()
        smallest_diff = diff if diff < smallest_diff
    end
    puts "The shortest path is #{smallest_diff + (power / 2)}"
end

def find_power(num)
    i = 1
    while i**2 < num do i += 2 end
    return i
end

def get_middles(power)
    start_val = (power - 2) ** 2 + 1
    middles = []
    current = start_val + (power / 2) - 1
    middles << current
    for i in 1..3 do
        current += power - 1
        middles << current
    end
    return middles
end

main()