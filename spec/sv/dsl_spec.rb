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
  it { expect(subject).to respond_to(:change_user).with(1).arguments }
  it { expect(subject).to respond_to(:change_user).with(2).arguments }
end
