# frozen_string_literal: true

describe Sv::Utils, :utils do
  let(:described_class) { Class.new { include Sv::Utils } }

  [
    :VERSION,
    :Bundleable,
    :Config,
    :Configurable,
    :Util,
    :SUID,
    :Shell,
    :DSL,
    :Service,
    :Loggerd,
    :CLI,
    :Control,
    :Concern,
    :Empty,
  ].each do |sym|
    it { expect(described_class).to be_const_defined(sym) }
  end
end
