RSpec.describe PreventGo do
  it "has a version number" do
    expect(PreventGo::VERSION).not_to be nil
  end

  describe '#configuration' do
    subject { described_class.configuration }

    it 'returns a Configuration instance' do
      expect(subject).to be_a(PreventGo::Configuration)
    end

    it 'memoize configuration' do
      configuration = subject
      expect(configuration).to eq(PreventGo.configuration)
      expect(configuration).not_to eq(PreventGo::Configuration.new)
    end
  end

  describe '#configure' do
    subject do
      described_class.configure do |config|
        config.site_key = 'site_key'
        config.secret_key = 'secret_key'
      end
    end

    it 'overrides initial configuration' do
      expect { subject }.to change { PreventGo.configuration.site_key }.from('test').to('site_key')
      expect(PreventGo.configuration.secret_key).to eq('secret_key')
      reset_configuration
    end
  end

  describe '#api_root_url' do
    subject { PreventGo.api_root_url }

    it { is_expected.to eq('https://integration-api.preventgo.io/v2') }
  end

  describe '#api_uri' do
    context 'with param' do
      subject { PreventGo.api_uri(url) }
      let(:url) { 'parazyte' }

      it { is_expected.to eq(URI(PreventGo.api_root_url + url)) }
    end

    context 'without param' do
      subject { PreventGo.api_uri }

      it { is_expected.to eq(URI(PreventGo.api_root_url)) }
    end
  end

  describe '#concat_params' do
    subject { PreventGo.concat_params(files, params) }
    let(:file_path) { test_file_path_for('test.pdf') }
    let(:files) { [file_path] }
    let(:params) { { test: 'test' } }

    it 'should return a Hash with formatted file as UploadIO object' do
      expect(subject['file_1']).to be_a(UploadIO)
    end

    it 'should format each params entries as JSON' do
      expect(subject[:test]).to be_a(String)
    end

    it 'should add as files as given' do
      files = [file_path, file_path]
      res = PreventGo.concat_params([file_path, file_path], params)
      expect(res).to have_key('file_1')
      expect(res).to have_key('file_2')
    end

    it 'should ignore nil value for files' do
      files << nil
      res = subject
      expect(res).to have_key('file_1')
      expect(res).not_to have_key('file_2')
    end
  end

  describe '#detect_mime_type_for' do
    subject { PreventGo.detect_mime_type_for(file) }
    let(:file) { double("file") }

    context 'with a form file format' do
      before { allow(file).to receive(:content_type).and_return('test') }

      it { is_expected.to eq(file.content_type) }
    end

    context 'with a file' do
      before { allow(file).to receive(:path).and_return('/test/test.pdf') }

      it { is_expected.to eq('application/pdf') }
    end

    context 'with a file path' do
      let(:file) { test_file_path_for('test.pdf') }

      it { is_expected.to eq('application/pdf') }
    end
  end
end
