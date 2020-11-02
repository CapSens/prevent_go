RSpec.describe PreventGo::DriverLicense do
  describe '.new' do
    context 'with only a valid file', cassette: :driver_license_valid do
      subject { PreventGo::DriverLicense.new(file) }
      let(:file) { test_file_path_for('test.pdf') }

      it 'should instanciate an object' do
        instance = subject
        expect(instance).to be_a(PreventGo::DriverLicense)
        expect(instance.document_type).to eq('DRIVER_LICENSE')
      end
    end

    context 'with only a file illisible', cassette: :driver_license_illisble do
      subject { PreventGo::DriverLicense.new(file) }
      let(:file) { test_file_path_for('test.pdf') }

      it 'should raise a PreventGo::ResponseError' do
        expect { subject }.to raise_error(PreventGo::ResponseError)
      end
    end

    context 'with only a file illisible', cassette: :driver_license_invalid do
      subject { PreventGo::DriverLicense.new(file) }
      let(:file) { test_file_path_for('test.pdf') }

      it 'should raise a PreventGo::ResponseError' do
        expect { subject }.to raise_error(PreventGo::ResponseError)
      end
    end
  end

  describe 'instance methods', cassette: :driver_license_valid do
    let(:instance) { PreventGo::DriverLicense.new(file) }
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

    describe '.holder_data' do
      subject { instance.holder_data }

      it { is_expected.to be_a(Hash) }
    end

    describe '.fetch_holder_infos' do
      before do
        allow(instance).to receive(:holder_data).and_return(
          'firstName' => 'test1',
          'lastName' => 'test2',
          'birthName' => 'test3',
          'birthDate' => 'test4',
          'gender' => 'test5'
        )
      end

      context 'without parameters' do
        subject { instance.fetch_holder_infos}

        it { is_expected.to be_a(Array) }

        it 'should include all parameters' do
          expect(subject).to eq(%w[test1 test2 test3 test4 test5])
        end
      end

      context 'with parameters' do
        subject { instance.fetch_holder_infos('firstName', 'gender') }

        it { is_expected.to be_a(Array) }

        it 'should include all parameters' do
          expect(subject).to eq(%w[test1 test5])
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
            'notExpired' => 'OK',
            'mrzValid' => 'OK'
          })
        end

        it { is_expected.to be_truthy }
      end

      context 'when not all controls are ok' do
        before do
          allow(instance).to receive(:document_controls).and_return({
            'typeRecognized' => 'KO',
            'quality' => { 'aboveMinimumThreshold' => 'OK' },
            'notExpired' => 'OK',
            'mrzValid' => 'OK'
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

      it { is_expected.to eq('/driver-license') }
    end
  end
end
