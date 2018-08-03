# frozen_string_literal: true

describe Sv::Utils::Config, :'utils/config' do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(0).arguments
    expect(described_class).to respond_to(:new).with(1).arguments

    expect(described_class).to respond_to(:filename).with(0).arguments
    expect(described_class).to respond_to(:filepath).with(0).arguments
  end

  it { expect(subject).to be_a(Hash) }

  it do
    expect(subject).to respond_to(:file).with(0).arguments
    expect(subject).to respond_to(:to_path).with(0).arguments
  end
end

describe Sv::Utils::Config, :'utils/config' do
  context '#to_path' do
    it { expect(subject.to_path).to be_a(String) }
    it { expect(subject.to_path).to eq(described_class.filepath) }
  end

  context '#file' do
    it { expect(subject.file).to be_a(Pathname) }
  end

  context '#keys.sort' do
    it { expect(subject.keys).to eq(%w[loggerd service control]) }
  end
end

describe Sv::Utils::Config, :'utils/config' do
  include FileUtils

  let(:sample) { sham!(:configs).samples.fetch('unreadable') }
  before(:each) { chmod(0o200, sample) }
  after(:each) { chmod(0o644, sample) }

  context '#new' do
    it 'should raise' do
      expect { described_class.new(sample) }.to raise_error(Errno::EACCES)
    end
  end
end

describe Sv::Utils::Config, :'utils/config' do
  let(:sample) { sham!(:configs).samples.fetch('string') }

  context '#new' do
    it 'should raise' do
      expect { described_class.new(sample) }.to raise_error(Errno::EINVAL)
    end
  end
end

describe Sv::Utils::Config, :'utils/config' do
  let(:sample) { sham!(:configs).samples.fetch('invalid_syntax') }

  context '#new' do
    it 'should raise' do
      expect { described_class.new(sample) }.to raise_error(Psych::SyntaxError)
    end
  end
end

describe Sv::Utils::Config, :'utils/config' do
  let(:sample) { sham!(:configs).samples.fetch('invalid_logic') }

  context '#new' do
    it 'should raise' do
      expect { described_class.new(sample) }.to raise_error(Errno::EINVAL)
    end
  end
end

describe Sv::Utils::Config, :'utils/config' do
  let(:sample) { sham!(:configs).samples.fetch('override') }
  let(:subject) { described_class.new(sample) }

  context '#["loggerd"]["user"]' do
    it { expect(subject['loggerd']['user']).to eq('svlog') }
  end

  context '#["loggerd"]["group"]' do
    it { expect(subject['loggerd']['group']).to eq('log') }
  end

  context '#["service"].fetch("command")' do
    it { expect(subject['service'].fetch('command')).to be(nil) }
  end

  context '#["control"]["futils"]' do
    it { expect(subject['control']['futils']).to eq('dry_run') }
  end

  context '#["control"]["paths"]' do
    let(:paths) { ['/etc/service', '/var/run/sv'] }

    it { expect(subject['control']['paths']).to eq(paths) }
  end
end
