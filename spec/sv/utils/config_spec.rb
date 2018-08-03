# frozen_string_literal: true

describe Sv::Utils::Config, :'utils/config' do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(0).arguments
    expect(described_class).to respond_to(:new).with(1).arguments

    expect(described_class).to respond_to(:filename).with(0).arguments
    expect(described_class).to respond_to(:filepath).with(0).arguments
  end
end
