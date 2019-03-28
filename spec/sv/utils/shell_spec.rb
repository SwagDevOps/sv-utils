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
