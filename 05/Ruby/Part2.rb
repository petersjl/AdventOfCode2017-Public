require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"), true)
    return input.map { |line| line.to_i}
end

def solve_puzzle()
    input = parse_input()
    count = 0
    index = 0
    while index < input.length
        jump_to = input[index]
        if jump_to < 3 then input[index] += 1 else input[index] -= 1 end
        index += jump_to
        count += 1
    end
    puts "Leave instructions at step #{count}"
end

main()