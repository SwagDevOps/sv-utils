# frozen_string_literal: true

describe Sv::Utils::Configurable, :'utils/configurable' do
  it { expect(described_class).to be_const_defined(:Command) }
end
