# frozen_string_literal: true

describe Sv::Utils::Shell, :'utils/shell' do
  it { expect(described_class).to be_const_defined(:Command) }
  it { expect(described_class).to be_const_defined(:Result) }
  it { expect(described_class).to be_const_defined(:Error) }
  it { expect(described_class).to be_const_defined(:ExitStatusError) }
end
