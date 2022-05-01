require_relative '../../block_chain/block.rb'

RSpec.describe Block do
    describe "#new" do
        let(:index) { 1 }
        let(:data) { { name: 'Brian' } }
        let(:prev_hash) { '123456789' }

        it "takes an index, some data, and a previous hash" do 
            expect { described_class.new(index, data, prev_hash) }.to_not raise_error
            expect { described_class.new }.to raise_error(ArgumentError)
        end

        it 'records the time it was created' do
            expect(Time).to receive(:now)
            described_class.new(index, data, prev_hash)
        end

        it 'computes a hash for the block' do
            expect_any_instance_of(described_class).to receive(:compute_hash)

            block = described_class.new(index, data, prev_hash)
        end

        let(:block) { described_class.new(index, data, prev_hash) }

        it 'freezes the data' do
            expect { block.data['new'] = 'new_data' }.to raise_error(FrozenError)
        end
    end

    let(:subject) { described_class.new(5, { 'brian': 100, 'Lucy': 500 }, '123456789') }
    let(:computed_hash) { 
        (subject.index.to_s + subject.data.to_s + subject.prev_hash + subject.timestamp.to_s).hash
    }

    describe '#index' do
        it 'provides the index for the block' do
            expect(subject.index).to be(5)
        end

        it 'does not allow you to change the index' do
            expect { subject.index = 6 }.to raise_error(NoMethodError)
        end
    end

    describe '#data' do
        it 'reads the data for the block' do    
            expect(subject.data).to eq({ 'brian': 100, 'Lucy': 500 })
        end

        it 'does not allow you to change the data' do
            expect { subject.data = 'bad_data' }.to raise_error(NoMethodError)
        end
    end

    describe '#prev_hash' do
        it 'reads the prev_hash for the block' do    
            expect(subject.prev_hash).to eq('123456789')
        end

        it 'does not allow you to change the prev_hash' do
            expect { subject.prev_hash = 'bad_hash' }.to raise_error(NoMethodError)
        end
    end

    describe '#block_hash' do
        it 'reads the hash for the block' do    

            expect(subject.block_hash).to eq(computed_hash)
        end

        it 'does not allow you to change the hash' do
            expect { subject.block_hash = 'bad_data' }.to raise_error(NoMethodError)
        end
    end

    describe '#timestamp' do
        it 'reads the timestamp for the block' do    
            expect(subject.timestamp).to be_an_instance_of(Time)
        end

        it 'does not allow you to change the data' do
            expect { subject.timestamp = 'bad_time' }.to raise_error(NoMethodError)
        end
    end

    describe '#compute_hash' do
        it 'computes a hash for the block based on its index, data, previous hash, and timestamp' do
            computed_hash = (subject.index.to_s + subject.data.to_s + subject.prev_hash + subject.timestamp.to_s).hash

            expect(subject.block_hash).to eq(computed_hash)
        end

        it 'does not call "#hash" on the instance of Block' do
            expect(subject).to_not receive(:hash)

            subject.compute_hash
        end
    end

    describe 'Block.start_block' do
        let(:start_block) { described_class.start_block }

        it 'generates a starting block with an index of 0' do
            expect(start_block.index).to be(0)
        end

        it 'has initial data' do
            expect(start_block.data).to_not be_nil
        end

        it 'has a previous hash of "start"' do
            expect(start_block.prev_hash).to eq('start')
        end
    end
end