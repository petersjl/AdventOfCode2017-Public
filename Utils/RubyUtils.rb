class Utils
    def Utils.read(name, split=false)
        File.open(name) { |f| split ? f.readlines.map(&:chomp) : f.read }
    end
end

class Array

    # Find the first element in the array that causes the block to return true skipping {skip} elements.
    def find(skip = 0)
        for i in 0...self.length
            if yield(self[i])
                if skip == 0
                    return self[i]
                else
                    skip -= 1
                end
            end
        end
        return nil
    end
end

class Hash
    def increment(key, default)
        if self.has_key?(key)
            self[key] += 1
        else
            self[key] = default
        end
    end
end