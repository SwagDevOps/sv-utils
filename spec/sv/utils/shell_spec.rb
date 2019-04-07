# frozen_string_literal: true

describe Sv::Utils::Shell, :'utils/shell' do
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:Result) }
  it { expect(described_class).to be_const_defined(:Error) }
  it { expect(described_class).to be_const_defined(:ExitStatusError) }
end

# class methods
describe Sv::Utils::Shell, :'utils/shell' do
  it do
    expect(described_class).to respond_to(:new).with(1).arguments
    expect(described_class).to respond_to(:new).with(2).arguments
  end
end

# intsance methods
describe Sv::Utils::Shell, :'utils/shell' do
  let(:subject) { described_class.new({}, {}) }

  it do
    expect(subject).to respond_to(:sh).with(1).arguments
    expect(subject).to respond_to(:sh).with(2).arguments

    expect(subject).to respond_to(:verbose?).with(0).arguments
  end
end

# testing output
describe Sv::Utils::Shell, :'utils/shell' do
  let(:subject) { described_class.new(config) }
  let(:command) { ['true'] }

  context '#sh' do
    let(:config) { { 'shell' => { 'verbose' => true } } }

    specify do
      silence_stream($stderr) do
        expect { subject.sh(*command) }.to output(/true$/).to_stderr
        expect { subject.sh(*command) }.to_not output.to_stdout
      end
    end
  end

  context '#sh' do
    let(:config) { { 'shell' => { 'verbose' => false } } }

    specify do
      silence_stream($stderr) do
        expect { subject.sh(*command) }.to_not output.to_stderr
        expect { subject.sh(*command) }.to_not output.to_stdout
      end
    end
  end
end
