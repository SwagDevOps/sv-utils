# frozen_string_literal: true

require 'securerandom'

# Return samples as a Hash with files indexed by name
sampler = lambda do
  {}.yield_self do |samples|
    Dir.glob(SAMPLES_PATH.join('configs', '*.yml')).each do |file|
      file = Pathname.new(file)
      name = file.basename('.yml')

      samples[name.to_s] = file.freeze
    end

    # add random (inexisting file)
    samples['random'] = lambda do
      Array.new(3).tap do |parts|
        parts.map! { |t| SecureRandom.hex[0..8] }

        return Pathname.new('').join(parts.join('/').concat('.yml'))
      end
    end.call

    samples
  end
end

Sham.config(FactoryStruct, :configs) do |c|
  c.attributes do
    {
      samples: sampler.call
    }
  end
end
