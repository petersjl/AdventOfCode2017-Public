require_relative "./../../Utils/RubyUtils"
require 'test/unit/assertions'
include Test::Unit::Assertions

def main(test = false)
    start_time = Time.now
    if test
        run_tests()
    else
        solve_puzzle()
    end
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"))
    return input
end

def solve_puzzle()
    input = parse_input()

    puts "The hash is #{generate_hash(input)}"
end

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

def run_tests()
    assert_equal([64], to_dense([65,27,9,1,4,3,40,50,91,7,6,0,2,5,68,22]))
    assert_equal([64,64], to_dense([65,27,9,1,4,3,40,50,91,7,6,0,2,5,68,22,65,27,9,1,4,3,40,50,91,7,6,0,2,5,68,22]))
    assert_equal("4007ff", to_hex([64, 7, 255]))
    assert_equal("a2582a3a0e66e6e86e3812dcb672a272", generate_hash(""))
    assert_equal("33efeb34ea91902bb2f59c9920caa6cd", generate_hash("AoC 2017"))
    assert_equal("3efbe78a8d82f29979031a4aa0b16a9d", generate_hash("1,2,3"))
    assert_equal("63960835bcdc130f0b66d7ff4f6a5a8e", generate_hash("1,2,4"))
    puts "All tests passed"
end

main(false)