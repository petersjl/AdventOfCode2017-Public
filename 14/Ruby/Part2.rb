require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt")))
        puts "There are #{solution} groups"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def solve_puzzle(input)
    map = []
    for i in 0..127 do
        hash = generate_hash(input + "-#{i}")
        map << generate_row(hash)
    end
    count, group_map = count_and_map_groups(map)
    return count
end

def count_and_map_groups(map)
    group_count = 0
    seen = Array.new(map.length) {|i| Array.new(map[0].length) {|j| nil}}
    main_row = 0
    main_col = 0
    while main_row < map.length do
        if map[main_row][main_col] == "1"
            group_count += 1
            trace_group(map, seen, main_row, main_col, group_count)
        else
            seen[main_row][main_col] = 0
        end
        while seen[main_row][main_col] do
            main_col += 1
            if main_col >= map[0].length
                main_col = 0
                main_row += 1
            end
            if main_row >= map.length then break end
        end
    end
    return [group_count, seen]
end

def trace_group(map, seen, row, col, group_number)
    queue = [[row, col]] # add our starting point
    seen[row][col] = group_number
    while queue.length > 0 do # while we have something left on the queue
        current = queue.shift # pop the first
        row = current[0]
        col = current[1]
        if row - 1 >= 0 and not seen[row - 1][col] # if the spot above is in bounds and hasn't been seen
            if map[row - 1][col] == "1" # if it is a used spot
                queue.push [row - 1, col] # put it on the queue
                seen[row - 1][col] = group_number # assign the group number to that spot
            else
                seen[row - 1][col] = 0 # else note that we have seen it
            end
        end
        # same for down
        if row + 1 < map.length and not seen[row + 1][col]
            if map[row + 1][col] == "1"
                queue.push [row + 1, col]
                seen[row + 1][col] = group_number
            else
                seen[row + 1][col] = 0
            end
        end
        # same for left
        if col - 1 >= 0 and not seen[row][col - 1]
            if map[row][col - 1] == "1"
                queue.push [row, col - 1]
                seen[row][col - 1] = group_number
            else
                seen[row][col - 1] = 0
            end
        end
        # same for right
        if col + 1 < map[0].length and not seen[row][col + 1]
            if map[row][col + 1] == "1"
                queue.push [row, col + 1]
                seen[row][col + 1] = group_number
            else
                seen[row][col + 1] = 0
            end
        end
    end
end

def generate_row(hash)
    decimal = []
    hash.chars.each {|c| decimal << c.to_i(16)}
    binary = ""
    decimal.each {|i| binary << i.to_s(2).rjust(4, "0")}
    return binary
end

# Hash Generation --------------------------------
def generate_hash(str)
    lengths = str.bytes
    lengths.concat([17, 31, 73, 47, 23])
    arr = Array.new(256) {|i| i}
    pos = 0
    skip = 0
    for i in 0...64 do
        for len in lengths do
            reverse(arr, pos, len)
            pos += len + skip
            skip += 1
        end
    end
    dense = to_dense(arr)
    return to_hex(dense)
end

def to_dense(sparse)
    dense = []
    for section in 0...(sparse.length / 16) do
        start = section * 16
        num = sparse[start]
        for i in (start + 1)..(start + 15) do
            num = num ^ sparse[i]
        end
        dense << num
    end
    return dense
end

def to_hex(arr)
    hex_arr = arr.map{|i| 
        str = i.to_s(16)
        if str.length < 2 then str = "0" + str end
        str
    }
    return hex_arr.join("")
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

# ----------------------------------------------------------------

def run_tests()
    assert_equal("0000", generate_row("0"))
    assert_equal("0001", generate_row("1"))
    assert_equal("1110", generate_row("e"))
    assert_equal("1111", generate_row("f"))
    assert_equal("1010000011000010000000010111", generate_row("a0c2017"))
    assert_equal("11010100", generate_row(generate_hash("flqrgnkx-0"))[0..7])

    test_map = [
        "01110",
        "10100",
        "10101",
        "01101",
        "10110"
    ]

    test_seen = Array.new(test_map.length) {|i| Array.new(test_map[0].length) {|j| nil}}

    expected_seen = [
        [0,3,3,3,0],
        [nil,0,3,0,nil],
        [nil,0,3,0,nil],
        [0,3,3,0,nil],
        [nil,0,3,3,0]
    ]

    trace_group(test_map, test_seen, 0, 2, 3)
    assert_equal(expected_seen, test_seen)

    count, actual_seen = count_and_map_groups(test_map)
    actual_seen.each do |line| puts line.join() end
    assert_equal(4, count)
    assert_equal(1242, solve_puzzle("flqrgnkx"))
    puts "All tests passed"
end

main()