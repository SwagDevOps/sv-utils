# frozen_string_literal: true

describe Sv::Utils::Configurable::Command, :'utils/configurable/command' do
  let(:subject) { described_class.new({}) }

  it { expect(subject).to be_a(Sv::Utils::Configurable) }

  # instance methods
  it do
    expect(subject).to respond_to(:call).with(0).arguments
    expect(subject).to respond_to(:privileged?).with(0).arguments
    expect(subject).to respond_to(:params).with(0).arguments
    expect(subject).to respond_to(:to_a).with(0).arguments
  end
end

describe Sv::Utils::Configurable::Command, :'utils/configurable/command' do
  let(:subject) { described_class.new({}) }

  # @see Sv::Utils::SUID
  context '#suid' do
    it { expect(subject.__send__(:suid)).to be_a(Sv::Utils::SUID) }
  end
end

describe Sv::Utils::Configurable::Command, :'utils/configurable/command' do
  let(:command) { ['ls', '-A', '-l'] }
  let(:config) { { 'command' => { 'command' => command } } }
  let(:subject) { described_class.new(config) }

  context '#config' do
    it { expect(subject.config).to eq config[subject.identifier] }
  end

  context '#params.sort.to_h' do
    it do
      expect(subject.params.sort.to_h).to eq(
        command: command,
        group: 'root',
        user: :root
      )
    end
  end

  context '#to_a' do
    it { expect(subject.to_a).to eq(command) }
  end
end
