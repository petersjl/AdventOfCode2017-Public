require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"), true)
    return input.map { |line| line.split().map { |val| val.to_i} }
end

def solve_puzzle()
    input = parse_input()
    sum = input.inject(0) { |sum, line| sum + find_diff(line) }
    
    puts "checksum is #{sum}"
end

def find_diff(line)
    min = line[0]
    max = line[0]
    for i in 1...line.length do
        if line[i] < min
            min = line[i]
        end
        if line[i] > max
            max = line[i]
        end
    end
    return max - min
end

main()