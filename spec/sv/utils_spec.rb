# frozen_string_literal: true

describe Sv::Utils, :utils do
  let(:described_class) { Class.new { include Sv::Utils } }

  it { expect(described_class).to be_const_defined(:VERSION) }
  it { expect(described_class).to be_const_defined(:Config) }
  it { expect(described_class).to be_const_defined(:Configurable) }
  it { expect(described_class).to be_const_defined(:SUID) }
  it { expect(described_class).to be_const_defined(:DSL) }
  it { expect(described_class).to be_const_defined(:Service) }
  it { expect(described_class).to be_const_defined(:Loggerd) }
  it { expect(described_class).to be_const_defined(:Concern) }
end
