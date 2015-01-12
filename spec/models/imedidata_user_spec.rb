require 'spec_helper'
load 'app/models/imedidata_user.rb'

describe IMedidataUser do
  describe '#initialize' do
    context 'without an imedidata user uuid' do
      it 'raises an error' do
        expect { IMedidataUser.new }.to raise_error(ArgumentError, 'Please provide a uuid from a valid user in iMedidata.')
      end
    end

    context 'with an imedidata user uuid' do
      it 'assigns an imedidata user uuid attribute' do
        uuid = SecureRandom.uuid
        user = IMedidataUser.new(imedidata_user_uuid: uuid)
        expect(user.imedidata_user_uuid).to eq(uuid)
      end
    end
  end

  describe '#has_accepted_invitation?' do
    let(:uuid)           { SecureRandom.uuid }
    let(:study_uuid)     { SecureRandom.uuid }
    let(:user)           { IMedidataUser.new(imedidata_user_uuid: uuid) }
    let(:accepted_at)    { Time.now.to_s }
    let(:apps)           do
      {'apps' => [{'uuid' => SecureRandom.uuid}, {'uuid' => MAUTH_APP_UUID}], 'accepted_at' => accepted_at}
    end
    let(:options)        { {user_uuid: uuid, study_uuid: study_uuid} }
    let(:expected_error) { ["User has no accepted invitation to study or study group with uuid #{study_uuid}"]} 
    before do
      allow(user).to receive(:request_invitation!).with(options).and_return(apps)
    end

    context 'when user is assigned to the app' do
      context 'when accepted_at is present' do
        it('returns true') { expect(user.has_accepted_invitation?(options)).to eq(true) }
      end

      context 'when accepted_at is not present' do
        let(:accepted_at) { nil }

        it('returns false') { expect(user.has_accepted_invitation?(options)).to eq(false) }
        it 'adds an error' do
          user.has_accepted_invitation?(options)
          expect(user.errors[:invitation]).to eq(expected_error)
        end
      end
    end

    context 'when user is not assigned to the app' do
      let(:apps) { {'apps' => [{'uuid' => SecureRandom.uuid}], 'accepted_at' => accepted_at} }

      it('returns false') { expect(user.has_accepted_invitation?(options)).to eq(false) }
      it 'adds an error' do
        user.has_accepted_invitation?(options)
        expect(user.errors[:invitation]).to eq(expected_error)
      end
    end
  end

  describe '#get_user_studies!' do
    let(:uuid)    { SecureRandom.uuid }
    let(:user)    { IMedidataUser.new(imedidata_user_uuid: uuid) }
    let(:studies) do
      {studies: [{name: 'TesStudy001', uuid: SecureRandom.uuid}, {name: 'TestStudy002', uuid: SecureRandom.uuid}]}
    end

    context 'when request is successful' do
      before do
        allow(user).to receive(:request_studies!).and_return(studies)
      end

      it 'makes a request for user\'s studies' do
        expect(user.get_user_studies!).to eq(studies)
      end
    end

    context 'when request raises an error' do
      before do
        allow(user).to receive(:request_studies!).and_raise(IMedidataClientError.new('Failed to get studies'))
      end

      it 'raises the error' do
        expect(user.get_user_studies!).to eq(studies)
      end
    end
  end
end
