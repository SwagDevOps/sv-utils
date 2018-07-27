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

  context '#identifier' do
    it { expect(subject.identifier).to eq('service') }
  end
end

describe Sv::Utils::Service, :'utils/service' do
  let(:command) { nil }
  let(:config) { { 'service' => { 'command' => command } } }
  let(:service) { ['sleep', 'infinity'] } # service command
  let(:subject) { described_class.new(service, config) }

  context '#params' do
    it 'command (from config) SHOULD be casted to array' do
      expect(subject.params).to eq(
        user: :root,
        command: []
      )
    end
  end

  context '#to_a' do
    it { expect(subject.to_a).to eq(service) }
  end

  context '#to_s' do
    it { expect(subject.to_s).to eq('sleep infinity 2>&1') }
  end
end

describe Sv::Utils::Service, :'utils/service' do
  let(:command) { ['/usr/bin/env', '--'] }
  let(:config) { { 'service' => { 'command' => command } } }
  let(:service) { ['sleep', 'infinity'] } # service command
  let(:subject) { described_class.new(service, config) }

  context '#config' do
    it { expect(subject.config).to eq config[subject.identifier] }
  end

  context '#params' do
    it do
      expect(subject.params).to eq(
        user: :root,
        command: command
      )
    end
  end

  context '#to_a' do
    it { expect(subject.to_a).to eq(command + service) }
  end

  context '#to_s' do
    it { expect(subject.to_s).to eq('/usr/bin/env -- sleep infinity 2>&1') }
  end
end
