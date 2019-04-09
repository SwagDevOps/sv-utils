# frozen_string_literal: true

describe Sv::Utils::Shell, :'utils/shell' do
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:Result) }
  it { expect(described_class).to be_const_defined(:Error) }
  it { expect(described_class).to be_const_defined(:ExitStatusError) }
end

# class methods
describe Sv::Utils::Shell, :'utils/shell' do
  it { expect(described_class).to respond_to(:new).with(1).arguments }
  it { expect(described_class).to respond_to(:new).with(2).arguments }
end

# inheritance + intsance methods
describe Sv::Utils::Shell, :'utils/shell' do
  let(:subject) { described_class.new({}, {}) }

  it { expect(subject).to be_a(Sv::Utils::Configurable) }
  it { expect(subject).to respond_to(:sh).with(1).arguments }
  it { expect(subject).to respond_to(:sh).with(2).arguments }
  it { expect(subject).to respond_to(:verbose?).with(0).arguments }
end

# testing output
describe Sv::Utils::Shell, :'utils/shell' do
  let(:subject) { described_class.new(config) }
  let(:command) { %w[bundle exec true] }

  context '#sh' do
    let(:config) { { 'shell' => { 'verbose' => true } } }

    specify do
      silence_stream($stderr) do
        -> { subject.sh(*command) }.tap do |sh|
          expect { sh.call }.to_not output.to_stdout
          expect { sh.call }.to output(/^bundle exec true$/).to_stderr
        end
      end
    end
  end

  context '#sh' do
    let(:config) { { 'shell' => { 'verbose' => false } } }

    specify do
      silence_stream($stderr) do
        -> { subject.sh(*command) }.tap do |sh|
          expect { sh.call }.to_not output.to_stdout
          expect { sh.call }.to_not output.to_stderr
        end
      end
    end
  end
end

# result
describe Sv::Utils::Shell, :'utils/shell' do
  let(:subject) { described_class.new(config) }
  let(:command) { %w[bundle exec true] }

  context '#sh' do
    let(:config) { { 'shell' => { 'verbose' => true } } }

    it do
      silence_stream($stderr) do
        expect(subject.sh(*command)).to be_a(Sv::Utils::Shell::Result)
      end
    end
  end
end

# error
describe Sv::Utils::Shell, :'utils/shell' do
  let(:config) { { 'shell' => { 'verbose' => false } } }
  let(:subject) { described_class.new(config) }

  context '#sh' do # testing exceptions
    let(:command) { %w[bundle exec false] } # exit 1

    specify do
      silence_stream($stderr) do
        -> { subject.sh(*command) }.tap do |sh|
          # rubocop:disable Metrics/LineLength
          expect { sh.call }.to raise_error(Sv::Utils::Shell::ExitStatusError)
          expect { sh.call }.to raise_error('"bundle exec false" exited with status: 1')
          # rubocop:enable Metrics/LineLength
        end
      end
    end
  end
end
