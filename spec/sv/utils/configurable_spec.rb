# frozen_string_literal: true

describe Sv::Utils::Configurable, :'utils/configurable' do
  it { expect(described_class).to be_const_defined(:Command) }

  # class methods
  it do
    expect(described_class).to respond_to(:new).with(1).arguments
    expect(described_class).to respond_to(:new).with(2).arguments
  end
end

describe Sv::Utils::Configurable, :'utils/configurable' do
  let(:subject) { described_class.new({}) }

  # instance methods
  it do
    expect(subject).to respond_to(:params).with(0).arguments
    expect(subject).to respond_to(:identifier).with(0).arguments
  end

  # attribute readers
  it do
    expect(subject).to respond_to(:config).with(0).arguments
    expect(subject).to respond_to(:options).with(0).arguments
  end
end

describe Sv::Utils::Configurable, :'utils/configurable' do
  let(:subject) { described_class.new({}) }

  context '#identifier' do
    it do
      expect(subject.identifier).to be_a(String)
      expect(subject.identifier).to eq('configurable')
    end
  end
end
