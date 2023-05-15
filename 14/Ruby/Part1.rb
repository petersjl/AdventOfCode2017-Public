require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solution = solve_puzzle(Utils.read(File.join(File.dirname(__FILE__), "../input.txt")))
        puts "#{solution} blocks are used"
    end
    end_time = Time.now
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def solve_puzzle(input)
    count = 0
    for i in 0..127 do
        hash = generate_hash(input + "-#{i}")
        row = generate_row(hash)
        count += row.count("1")
    end
    return count
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
    assert_equal(8108, solve_puzzle("flqrgnkx"))
    puts "All tests passed"
end

main()