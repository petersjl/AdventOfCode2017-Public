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
    return parse_group(input[1...(input.length - 1)])
end

def parse_group(str)
    group = []
    return group if str.length == 0

    i = 0
    while i < str.length
        if str[i] == '{'
            start = i + 1
            i = find_end(str, start)
            group << parse_group(str[start...i])
            i += 2
        else
            start = i + 1
            i = collect_garbage(str, start)
            group << str[start...i]
            i += 2
        end
    end
    return group
end

def find_end(str, start = 0)
    i = start
    openbrackets = 0
    while i < str.length do
        case str[i]
        when "}"
            if openbrackets != 0
                openbrackets -= 1
            else
                return i
            end
        when "{"
            openbrackets += 1
        when "<"
            i = collect_garbage(str, i + 1)
        when "!"
            i += 1
        end
        i += 1
    end
    return nil
end

def collect_garbage(str, start = 0)
    i = start
    openbrackets = 0
    while i < str.length do
        if str[i] == ">" then return i
        elsif str[i] == "!" then i += 1
        end
        i += 1
    end
    return nil
end

def solve_puzzle()
    input = parse_input()
    score = count_character_groups(input)
    puts "Total characters: #{score}"
end

def count_character_groups(group)
    if group.is_a?(String) then return count_characters(group) end
    sum = 0
    for child in group do
        sum += count_character_groups(child)
    end
    return sum
end

def count_characters(str)
    sum = 0
    i = 0
    while i < str.length do
        if str[i] == "!"
            i += 2
        else
            sum += 1
            i += 1
        end
    end
    return sum
end

def run_tests()
    assert_equal(0, count_character_groups(parse_group("<>")))
    assert_equal(17, count_character_groups(parse_group("<random characters>")))
    assert_equal(3, count_character_groups(parse_group("<<<<>")))
    assert_equal(2, count_character_groups(parse_group("<{!>}>")))
    assert_equal(0, count_character_groups(parse_group("<!!>")))
    assert_equal(0, count_character_groups(parse_group("<!!!>>")))
    assert_equal(10, count_character_groups(parse_group('<{o"i!a,<{i<a>')))
    puts "All tests passed"
end

main()