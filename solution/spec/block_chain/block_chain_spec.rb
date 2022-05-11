require_relative '../../block_chain/block_chain.rb'

RSpec.describe BlockChain do
    let(:subject) { described_class.new }
    let(:start_block) { double('start_block', index: 0, prev_hash: 'start', data: {}, block_hash: 9876543210) }
    let(:block1) { double('block1', index: 1, prev_hash: 9876543210, data: {block: 1}, block_hash: 9876543211) }
    let(:block2) { double('block2', index: 2, prev_hash: 9876543211, data: {block: 2}, block_hash: 9876543212) }

    before(:each) do
        allow(Block).to receive(:start_block).and_return(start_block)
        allow(start_block).to receive(:compute_hash).and_return(9876543210)
        allow(block1).to receive(:compute_hash).and_return(9876543211)
        allow(block2).to receive(:compute_hash).and_return(9876543212)
        allow(block1).to receive(:prove_work).and_return(block1)
        allow(block2).to receive(:prove_work).and_return(block2)
    end
    
    describe '.new' do
        it 'initializes an array to hold the chain of blocks' do
            expect(subject.chain).to be_an_instance_of(Array)
        end

        it 'places a starting block as the first element of the chain' do
            expect(subject.chain.length).to be(1)
        end
    end

    describe '#last_block' do
        it 'returns the last block in the chain' do
            subject.chain << block1
            subject.chain << block2
            expect(subject.last_block).to be(block2)
        end
    end

    describe '#build_block' do
        before(:each) do
            subject.chain << block1
            subject.chain << block2
        end

        let(:data) { { data: 'block' } }
        let(:new_block) { subject.build_block(data) }

        it 'returns a block with the next index' do
            expect(new_block.index).to be(3)
        end

        it 'returns a block with the given data' do
            expect(new_block.data).to eq(data)
        end

        it 'returns a block with a prev_hash equal to the last block in the chain' do
            expect(new_block.prev_hash).to eq(subject.chain.last.block_hash)
        end
    end

    describe '#add_block' do
        it 'adds a block to the end of the chain' do
            subject.add_block(block1)

            expect(subject.chain.last).to be(block1)
        end

        let(:prover_block) { double("prover_block") }

        it 'has the block provide proof of work before appending it to the chain' do
            expect(prover_block).to receive(:prove_work).with(subject.difficulty).and_return(1000)
            subject.add_block(prover_block)
        end
    end

    describe '#next_index' do
        it 'produces the next index: 1 + the last block\'s index' do
            expect(subject.next_index).to eq(1)
            subject.add_block(block1)
            expect(subject.next_index).to eq(2)
        end
    end

    describe '#validate_chain' do
        before(:each) do
            subject.chain << block1
            subject.chain << block2
        end

        context 'when the chain is valid' do
            it 'returns true' do
                expect(subject.validate_chain).to be true
            end
        end

        context 'when the chain is invalid' do
            let(:bad_block1) { double('bad_block1', index: 3, prev_hash: 100000000, data: {block: 'bad'}, block_hash: 9876543213, compute_hash: 9876543213) }
            let(:bad_block2) { double('bad_block2', index: 3, prev_hash: 9876543212,  data: {block: 'bad'}, block_hash: 9876543213, compute_hash: 100000000) }
            
            it 'returns false for chains with a block referencing the wrong previous hash' do
                subject.chain << bad_block1

                expect(subject.validate_chain).to be false
            end
            
            it 'returns false for chains with a block with a mismatched block_hash and computed hash' do
                subject.chain << bad_block2

                expect(subject.validate_chain).to be false
            end
        end
    end
end