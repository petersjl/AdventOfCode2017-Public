require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"))
    return input.chars.map() { |char| char.to_i }
end

def solve_puzzle()
    input = parse_input()
    sum = 0
    for i in 1...input.length do
        if input[i - 1] == input[i] then sum += input[i] end
    end
    if input.first == input.last then sum += input.first end
    puts "Sum is #{sum}"
end

main()