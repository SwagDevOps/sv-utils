# frozen_string_literal: true

describe Sv::Utils::Config, :'utils/config' do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(0).arguments
    expect(described_class).to respond_to(:new).with(1).arguments

    expect(described_class).to respond_to(:filename).with(0).arguments
    expect(described_class).to respond_to(:filepath).with(0).arguments
  end

  it { expect(subject).to be_a(Hash) }

  it do
    expect(subject).to respond_to(:file).with(0).arguments
    expect(subject).to respond_to(:to_path).with(0).arguments
  end
end

describe Sv::Utils::Config, :'utils/config' do
  context '#to_path' do
    it { expect(subject.to_path).to be_a(String) }
    it { expect(subject.to_path).to eq(described_class.filepath) }
  end

  context '#file' do
    it { expect(subject.file).to be_a(Pathname) }
  end

  context '#keys.sort' do
    it { expect(subject.keys).to eq(%w[loggerd service control]) }
  end
end
