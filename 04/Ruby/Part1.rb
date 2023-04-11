require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"), true)
    return input.map{|line| line.split()}
end

def solve_puzzle()
    input = parse_input()
    count = 0
    for line in input do
        count += 1 if check_line(line)
    end
    puts "There are #{count} valid passphrases"
end

def check_line(line)
    for i in 0...line.length
        for j in (i+1)...line.length
            return false if line[i] == line[j]
        end
    end
    return true
end

main()