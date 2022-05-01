class Block
    
    def self.start_block
        Block.new(0, { "Brian" => 100 }, 'start')
    end
    
    attr_reader :index, :data, :prev_hash, :block_hash, :timestamp
    
    def initialize(index, data, prev_hash)
        @index = index
        @data = data.freeze
        @prev_hash = prev_hash
        @timestamp = Time.now
        @block_hash = compute_hash
    end

    def compute_hash
        (index.to_s + data.to_s + prev_hash.to_s + timestamp.to_s).hash
    end
end