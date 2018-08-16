# frozen_string_literal: true

describe Sv::Utils::Control, :'utils/control' do
  let(:subject) { described_class.new({}) }

  # class methods
  it do
    expect(described_class).to respond_to(:new).with(1).arguments
    expect(described_class).to respond_to(:new).with(2).arguments
  end
end

describe Sv::Utils::Control, :'utils/control' do
  let(:subject) { described_class.new({}) }

  context '#identifier' do
    it { expect(subject.identifier).to eq('control') }
  end
end

describe Sv::Utils::Control, :'utils/control' do
  let(:subject) { described_class.new({}) }

  context '#params' do
    let(:config) { { 'control' => { 'paths' => ['/etc/sv', '/service'] } } }
    let(:subject) { described_class.new(config) }

    it { expect(subject.params).to be_a(Hash) }
  end

  context '#config' do
    it { expect(subject.config).to be_a(Hash) }
  end

  context '#actions' do
    it { expect(subject.actions).to be_a(Hash) }
  end

  context '#actions.keys.sort' do
    it { expect(subject.actions.keys.sort).to eq([:disable, :enable]) }
  end

  context '#call' do
    # @todo
  end
end
