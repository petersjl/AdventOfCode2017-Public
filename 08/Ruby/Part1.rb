require_relative "./../../Utils/RubyUtils"

def main()
    start_time = Time.now
    solve_puzzle()
    end_time = Time.now
    puts "Ran in #{end_time - start_time} seconds"
end

def parse_input(test = false)
    input = Utils.read(File.join(File.dirname(__FILE__), test ? "../testinput.txt" : "../input.txt"),true)
    return input.map do |line|
        parts = line.split(" if ")
        iparts = parts[0].split()
        cparts = parts[1].split()
        ins = Instruction.new(iparts[0],iparts[1],iparts[2].to_i)
        con = Conditional.new(cparts[0],cparts[1],cparts[2].to_i)
        [ins,con]
    end
end

def solve_puzzle()
    input = parse_input()
    registers = {}
    for pair in input do
        ins, con = pair
        if con.eval((registers[con.reg] or 0))
            registers[ins.reg] = ins.eval((registers[ins.reg] or 0))
        end
    end
    greatest = -1*10**10
    for key, val in registers
        if val > greatest
            greatest = val
        end
    end
    puts "The largest register is #{greatest}"
end

class Instruction
    attr_accessor :reg, :method, :value

    def initialize(reg, method, value)
        @reg = reg
        @method = method
        @value = value
    end

    def eval(reg_val)
        if @method == "inc"
            return reg_val + @value
        else
            return reg_val - @value
        end
    end
end

class Conditional
    attr_accessor :reg, :method, :value

    def initialize(reg, method, value)
        @reg = reg
        @method = method
        @value = value
    end

    def eval(reg_val)
        return reg_val.send(@method.to_sym, @value)
    end
end

main()