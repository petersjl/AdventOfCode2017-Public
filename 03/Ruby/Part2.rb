require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"))
    return input.to_i()
end

def solve_puzzle()
    input = parse_input()
    grid = SpiralGrid.new
    while grid.add_next() < input do end
    puts grid.latest()
end

class SpiralGrid
    def initialize()
        @grid = {0 => {0 => 1}}
        @latest = 1
        @count = 1
        @x = 0
        @y = 0
        @ring = 1
        @first_val = 1
        @corners = []
    end

    def latest() @latest; end
    def add_next()
        if @count == (@ring ** 2)
            @first_val = @ring ** 2 + 1
            @ring += 2
            @x += 1
            set_corners()
        else
            if @count < @corners[0] then @y += 1
            elsif @count < @corners[1] then @x -= 1
            elsif @count < @corners[2] then @y -= 1
            else @x += 1 end
        end
        @latest = generate_spot()
        @count += 1
        return @latest
    end

    def get(row, col) if @grid[row] then (@grid[row][col] or 0) else 0 end end

    def to_s()
        @grid.to_s
    end

    private def generate_spot()
        value = 0
        for i in -1..1
            for j in -1..1
                if i == 0 and j == 0 then next end
                row = @y + i
                col = @x + j
                value += get(row, col)
            end
        end
        row = @grid[@y]
        if not row
            @grid[@y] = {}
            row = @grid[@y]
        end
        row[@x] = value
        return value
    end

    private def set_corners()
        val = @first_val + @ring - 2
        @corners = []
        @corners << val
        for i in 1..3 do
            val += @ring - 1
            @corners << val
        end
    end
end

main()