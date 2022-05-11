require 'digest' # https://ruby-doc.org/stdlib-2.5.1/libdoc/digest/rdoc/Digest.html

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
        @nonce = 0
        @block_hash = nil
    end

    def compute_hash
        Digest::SHA256.digest(index.to_s + data.to_s + prev_hash.to_s + timestamp.to_s + nonce.to_s)
    end

    def prove_work(difficulty)
        solved = false
        target = "0" * difficulty
        until solved
            current_hash = compute_hash
            length = current_hash.to_s.length
            hash_end = current_hash.to_s.slice(length - difficulty, length)
            if hash_end == target
                solved = true
                self.block_hash = current_hash
            else
                self.nonce += 1
            end
        end

        self
    end

    private

    attr_accessor :nonce
    attr_writer :block_hash
end