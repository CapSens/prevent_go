RSpec.describe PreventGo::TaxNotice do
  describe '.new' do
    context 'with only a valid file', cassette: :tax_notice_valid do
      subject { described_class.new(file) }
      let(:file) { test_file_path_for('test.pdf') }

      it 'should instanciate an object' do
        instance = subject
        expect(instance).to be_a(described_class)
        expect(instance.document_type).to eq('TAX_NOTICE')
      end
    end
  end

  describe 'instance methods', cassette: :tax_notice_valid do
    let(:instance) { described_class.new(file) }
    let(:file) { test_file_path_for('test.pdf') }

    describe '.holders_data' do
      subject { instance.holders_data }

      it { is_expected.to be_a(Array) }
    end

    describe '.document_details' do
      subject { instance.document_details }

      it { is_expected.to be_a(Hash) }
    end

    describe '.document_controls' do
      subject { instance.document_controls }

      it { is_expected.to be_a(Hash) }
    end

    describe '.fetch_holders_infos' do
      before do
        allow(instance).to receive(:holders_data).and_return(
          [
            {
              'firstName' => 'femme_1',
              'lastName' => 'femme_2',
              'birthName' => 'femme_3',
              'birthDate' => 'femme_4'
            },
            {
              'firstName' => 'mari_1',
              'lastName' => 'mari_2',
              'birthName' => 'mari_3',
              'birthDate' => 'mari_4'
            }
          ]
        )
      end

      context 'without parameters' do
        subject { instance.fetch_holders_infos }

        it { is_expected.to be_a(Array) }

        it 'should include all parameters' do
          expect(subject).to eq([%w[femme_1 femme_2 femme_3 femme_4], %w[mari_1 mari_2 mari_3 mari_4]])
        end
      end

      context 'with parameters' do
        subject { instance.fetch_holders_infos('firstName', 'birthDate') }

        it { is_expected.to be_a(Array) }

        it 'should include all parameters' do
          expect(subject).to eq([%w[femme_1 femme_4], %w[mari_1 mari_4]])
        end
      end
    end

    describe '.quality_validated?' do
      subject { instance.quality_validated? }

      context 'when all controls are ok' do
        before do
          allow(instance).to receive(:document_controls).and_return({
            'typeRecognized' => 'OK',
            'quality' => { 'aboveMinimumThreshold' => 'OK' },
            'fiscalNumberFound' => 'OK'
          })
        end

        it { is_expected.to be_truthy }
      end

      context 'when not all controls are ok' do
        before do
          allow(instance).to receive(:document_controls).and_return({
            'typeRecognized' => 'KO',
            'quality' => { 'aboveMinimumThreshold' => 'OK' },
            'fiscalNumberFound' => 'OK'
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
