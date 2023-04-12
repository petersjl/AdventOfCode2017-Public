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
    puts "The base of the tree is #{input}"
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