require_relative './block.rb'

class BlockChain

    attr_reader :chain, :difficulty
    
    def initialize
        @chain = [Block.start_block]
        @difficulty = 3
    end

    def last_block
        chain.last
    end

    def build_block(data)
        Block.new(next_index, data, last_block.block_hash)
    end

    def add_block(block)
        finished_block = block.prove_work(difficulty)
        chain.push(finished_block)
    end

    def mine(data)
        block = build_block(data)
        add_block(block)
    end
    
    def next_index
        last_block.index + 1
    end

    def validate_chain
        valid = true
        running_hash = chain.first.prev_hash

        chain.each do |block|
            break if !valid

            prev_hash_matches = running_hash == block.prev_hash
            running_hash = block.compute_hash
            current_hash_matches = block.block_hash == running_hash

            valid = prev_hash_matches && current_hash_matches
        end

        valid
    end
end