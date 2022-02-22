RSpec.describe PreventGo::AddressDocument do
  describe '.new' do
    context 'with only a valid file', cassette: :address_document_valid do
      subject { described_class.new(file) }
      let(:file) { test_file_path_for('test.pdf') }

      it 'should instanciate an object' do
        instance = subject
        expect(instance).to be_a(described_class)
        expect(instance.document_type).to eq('PHONE_INVOICE')
      end
    end
  end

  describe 'instance methods', cassette: :address_document_valid do
    let(:instance) { described_class.new(file) }
    let(:file) { test_file_path_for('test.pdf') }

    describe '.holder_controls' do
      subject { instance.holder_controls }

      it { is_expected.to be_a(Hash) }
    end

    describe '.document_details' do
      subject { instance.document_details }

      it { is_expected.to be_a(Hash) }
    end

    describe '.document_controls' do
      subject { instance.document_controls }

      it { is_expected.to be_a(Hash) }
    end

    describe '.quality_validated?' do
      subject { instance.quality_validated? }

      context 'when all controls are ok' do
        before do
          allow(instance).to receive(:document_controls).and_return({
            'typeRecognized' => 'OK',
            'quality' => { 'aboveMinimumThreshold' => 'OK' }
          })
        end

        it { is_expected.to be_truthy }
      end

      context 'when not all controls are ok' do
        before do
          allow(instance).to receive(:document_controls).and_return({
            'typeRecognized' => 'KO',
            'quality' => { 'aboveMinimumThreshold' => 'OK' }
          })
        end

        it { is_expected.to be_falsey }
      end
    end

    describe '.document_type' do
      subject { instance.document_type }

      it { is_expected.to be_a(String) }
    end

    describe '.endpoint' do
      subject { instance.send(:endpoint) }

      it { is_expected.to eq('/any') }
    end
  end
end
