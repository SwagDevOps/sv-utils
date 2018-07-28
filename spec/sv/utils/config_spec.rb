# frozen_string_literal: true

describe Sv::Utils::Config, :'utils/config' do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(0).arguments
    expect(described_class).to respond_to(:new).with(1).arguments
    # alias
    expect(described_class.method(:yaml?)).to eq(described_class.method(:yml?))
  end
end

describe Sv::Utils::Config, :'utils/config' do
  context '.yaml?' do
    {
      'fake.yml' => true,
      'fake.yaml' => true,
      __FILE__ => false,
      'yml' => false,
      'yaml' => false,
      '.yml' => false,
      '.yaml' => false,
      Pathname.new('fake.yml') => true,
      :'fake.yml' => true,
    }.each do |k, v|
      it k.inspect do
        expect(described_class.__send__(:yaml?, k)).to be(v)
      end
    end
  end
end
