require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"))
    return input.split(",").map {|s| s.to_i}
end

def solve_puzzle()
    is_test = false
    input = parse_input(is_test)
    arr = Array.new(is_test ? 5 : 256) {|i| i}
    pos = 0
    skip = 0
    for len in input do
        reverse(arr, pos, len)
        pos += len + skip
        skip += 1
    end

    puts "Product of first two numbers is #{arr[0] * arr[1]}"
end

def reverse(arr, pos, length)
    right = (pos + length - 1)
    while pos < right do
        effective_left = pos % arr.length
        effective_right = right % arr.length
        hold = arr[effective_left]
        arr[effective_left] = arr[effective_right]
        arr[effective_right] = hold
        pos += 1
        right -= 1
    end
end

main()