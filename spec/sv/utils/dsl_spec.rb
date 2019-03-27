# frozen_string_literal: true

describe Sv::Utils::DSL, :'utils/dsl' do
  let(:described_class) { Class.new { include Sv::Utils::DSL } }

  it { expect(subject).to respond_to(:configure).with(0).arguments }
  it { expect(subject).to respond_to(:configure).with(1).arguments }
  it { expect(subject).to respond_to(:config).with(0).arguments }
  it { expect(subject).to respond_to(:service).with(1).arguments }
  it { expect(subject).to respond_to(:service).with(2).arguments }
  it { expect(subject).to respond_to(:loggerd).with(0).arguments }
  it { expect(subject).to respond_to(:loggerd).with(1).arguments }
  it { expect(subject).to respond_to(:sh).with(1).arguments }
  it { expect(subject).to respond_to(:sh).with(2).arguments }
  it { expect(subject).to respond_to(:change_user).with(1).arguments }
  it { expect(subject).to respond_to(:change_user).with(2).arguments }
end

describe Sv::Utils::DSL, :'utils/dsl' do
  let(:described_class) { Class.new { include Sv::Utils::DSL } }
  # let(:subject) do
  #   described_class.new.tap { |subject| subject.configure(__FILE__) }
  # end

  context '#config' do
    it { expect(subject.config).to be_a(Hash) }
    it { expect(subject.config).to be_a(Sv::Utils::Config) }
  end
end
