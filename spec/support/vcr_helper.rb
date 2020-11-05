module VcrHelper
  def self.extended(base)
    base.around do |spec|
      if (cassette_name = spec.metadata[:cassette])
        path            = spec.metadata[:file_path]

        # remove `./spec/` and `_spec.rb`
        path          = path.gsub('./spec/', '').gsub('_spec.rb', '')
        cassette_path = "#{path}/#{cassette_name}"

        VCR.insert_cassette(cassette_path)
        spec.run
        VCR.eject_cassette(cassette_path)
      else
        spec.run
      end
    end
  end

  def cassette(cassette_name)
    let(:_cassette) { cassette_name }
  end
end
