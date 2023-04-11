require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput2.txt" : "../input.txt"), true)
    return input.map { |line| line.split().map { |val| val.to_i} }
end

def solve_puzzle()
    input = parse_input()
    sum = input.inject(0) { |sum, line| sum + find_divisibles(line) }
    
    puts "checksum is #{sum}"
end

def find_divisibles(line)
    for i in 0...(line.length - 1) do
        for j in (i + 1)...line.length do
            v1 = line[i]
            v2 = line[j]
            if v1 > v2
                return v1 / v2 if v1 % v2 == 0
            else
                return v2 / v1 if v2 % v1 == 0
            end
        end
    end
    raise StandardError, "Invalid input"
end

main()