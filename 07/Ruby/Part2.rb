require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"), true)
    nodes = {}
    for line in input do
        parts = line.split(" -> ")
        parts[0][/(\w+) \((\d+)\)/]
        if nodes.has_key?($1)
            node = nodes[$1]
        else
            node = TreeNode.new($1)
            nodes[$1] = node
        end
        node.weight = $2.to_i
        if parts.size == 2
            children = parts[1].split(", ")
            for child in children do
                if nodes.has_key?(child)
                    child_node = nodes[child]
                else
                    child_node = TreeNode.new(child)
                    nodes[child] = child_node
                end
                node.children << child_node
                child_node.parent = node
            end
        end
    end
    bottom = nodes.shift[1]
    while bottom.parent != nil do bottom = bottom.parent end
    return bottom
end

def solve_puzzle()
    input = parse_input()
    puts "The defective weight should be #{get_needed_weight(input)}"
end

def get_needed_weight(node)
    # If there are no children, return [my weight, 0]
    if node.children.size == 0 then return [node.weight, 0] end
    # Recursively call for all children
    child_pairs = node.children.map { |child| get_needed_weight(child) }
    # If any returned only a number, pass it through
    if found = child_pairs.find { |child_pair| child_pair.class == Integer} then return found end
    # Put weight pairs together for comparison
    child_totals = child_pairs.map { |child_pair| child_pair[0] + child_pair[1]}
    # If all are equal, return [my weight, weight of children]
    if not child_totals.any? { |total| total != child_totals[0] } then return [node.weight, child_totals[0] * child_totals.size] end
    # Find if the odd value
    if child_totals[1...child_totals.size].include?(child_totals[0])
        odd_index = for i in 1... child_totals.size do
            break i if child_totals[i] != child_totals[0]
        end
        common_index = 0
    else
        odd_index = 0
        common_index = 1
    end
    odd_pair = child_pairs[odd_index]
    common_total = child_totals[common_index]
    # Return the common sum minus the child sum of the odd tower, thus giving what the tower should weigh
    return common_total - odd_pair[1]
end

class TreeNode
    attr_accessor :name, :weight, :parent, :children
    def initialize(name)
        @name = name
        @children = []
    end

    def to_s()
        @name
    end
end

main()