RSpec.describe PreventGo::Base do
  describe '.initialize' do
    subject { described_class.new(file) }
    let(:file) { test_file_path_for('test.pdf') }

    context 'when PreventGo respond with a code 400', cassette: '400' do
      it 'should raise a PreventGo::ResponseError' do
        expect { subject }.to raise_error(PreventGo::ResponseError)
      end

      it 'should set code and message in exception' do
        begin
          subject
        rescue PreventGo::ResponseError => e
          expect(e.code).to eq('400')
          expect(e.type).to eq(1205)
        end
      end
    end

    context 'when PreventGo respond with a code 403', cassette: '403' do
      it 'should raise a PreventGo::ResponseError' do
        expect { subject }.to raise_error(PreventGo::ResponseError)
      end

      it 'should set code and message in exception' do
        begin
          subject
        rescue PreventGo::ResponseError => e
          expect(e.code).to eq('403')
          expect(e.type).to eq(1205)
        end
      end
    end

    context 'when PreventGo respond with a code 500', cassette: '500' do
      it 'should raise a PreventGo::ResponseError' do
        expect { subject }.to raise_error(PreventGo::ResponseError)
      end

      it 'should set code and message in exception' do
        begin
          subject
        rescue PreventGo::ResponseError => e
          expect(e.code).to eq('500')
          expect(e.type).to eq(1205)
        end
      end
    end

    context 'when PreventGo respond with a code 503', cassette: '503' do
      it 'should raise a PreventGo::ResponseError' do
        expect { subject }.to raise_error(PreventGo::ResponseError)
      end

      it 'should set code and message in exception' do
        begin
          subject
        rescue PreventGo::ResponseError => e
          expect(e.code).to eq('503')
          expect(e.type).to eq(1205)
        end
      end
    end
  end
end
