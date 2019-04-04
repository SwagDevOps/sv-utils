# frozen_string_literal: true

describe Sv::Utils::Shell::Command, :'utils/shell/command' do
  it { expect(described_class).to respond_to(:new).with(1).arguments }
end

describe Sv::Utils::Shell::Command, :'utils/shell/command' do
  let(:command) { ['ls', '-lA', '/some/path/with some speces'] }
  let(:subject) { described_class.new(command) }

  it { expect(subject).to eq(command) }

  context '#to_s' do
    it { expect(subject.to_s).to eq('ls -lA /some/path/with\\ some\\ speces') }
  end
end
