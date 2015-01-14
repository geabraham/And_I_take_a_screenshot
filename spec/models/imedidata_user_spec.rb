require 'spec_helper'
require_relative '../../app/models/imedidata_user'

describe IMedidataUser do
  let(:uuid)           { SecureRandom.uuid }
  let(:imedidata_user) { IMedidataUser.new(imedidata_user_uuid: uuid)}

  describe '#initialize' do
    context 'without an imedidata user uuid' do
      it 'raises an error' do
        expect { IMedidataUser.new }.to raise_error(ArgumentError, 'Please provide a uuid from a valid user in iMedidata.')
      end
    end

    context 'with an imedidata user uuid' do
      it 'assigns an imedidata user uuid attribute' do
        expect(imedidata_user.imedidata_user_uuid).to eq(uuid)
      end
    end
  end

  describe '#check_study_invitation!' do
    let(:study_uuid)     { SecureRandom.uuid }
    let(:accepted_at)    { Time.now.to_s }
    let(:apps)           do
      {'apps' => [{'uuid' => SecureRandom.uuid}, {'uuid' => MAUTH_APP_UUID}], 'accepted_at' => accepted_at}
    end
    let(:options)        { {user_uuid: uuid, study_uuid: study_uuid} }

    before do
      allow(imedidata_user).to receive(:request_invitation!).with(options).and_return(apps)
    end

    context 'when user is assigned to the app' do
      context 'when accepted_at is present' do
        it('returns true') { expect(imedidata_user.check_study_invitation!(options)).to eq(true) }
      end

      context 'when accepted_at is not present' do
        let(:expected_error) { ["User invitation to study with uuid #{study_uuid} has not been accepted."] }
        let(:accepted_at)    { nil }

        it('returns false') { expect(imedidata_user.check_study_invitation!(options)).to eq(false) }

        it 'adds an error' do
          imedidata_user.check_study_invitation!(options)
          expect(imedidata_user.errors[:invitation]).to eq(expected_error)
        end
      end
    end

    context 'when user is not assigned to the app' do
      let(:expected_error) { ['User invitation does not include app.'] }
      let(:apps)           { {'apps' => [{'uuid' => SecureRandom.uuid}], 'accepted_at' => accepted_at} }

      it('returns false') { expect(imedidata_user.check_study_invitation!(options)).to eq(false) }

      it 'adds an error' do
        imedidata_user.check_study_invitation!(options)
        expect(imedidata_user.errors[:invitation]).to eq(expected_error)
      end
    end
  end
end
