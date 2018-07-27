# frozen_string_literal: true

describe Sv::Utils::Service, :'utils/service' do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(2).arguments
    expect(described_class).to respond_to(:new).with(3).arguments
  end
end

describe Sv::Utils::Service, :'utils/service' do
  let(:subject) { described_class.new([], {}) }
end
