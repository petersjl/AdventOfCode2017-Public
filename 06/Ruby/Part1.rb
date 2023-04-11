require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"))
    return input.split.map{|s| s.to_i}
end

def solve_puzzle()
    input = parse_input()
    set = Set.new
    set.add(input.join(" "))
    count = 0
    while true do
        count += 1
        index = find_largest(input)
        distribute(input, index)
        break unless set.add?(input.join(" "))
    end

    puts "Finished in #{count} redistributions"
end

def find_largest(input)
    index = 0
    for i in 0...input.length do
        if input[i] > input[index] then index = i end
    end
    return index
end

def distribute(input, index)
    left = input[index]
    input[index] = 0
    index += 1
    while left > 0 do
        index = 0 if index == input.length
        input[index] += 1
        left -= 1
        index += 1
    end
end

main()