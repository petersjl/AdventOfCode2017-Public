class Utils
    def Utils.read(name, split=false)
        File.open(name) { |f| split ? f.readlines.map(&:chomp) : f.read }
    end
end

class String
    def String.chars() self.split('') end
end