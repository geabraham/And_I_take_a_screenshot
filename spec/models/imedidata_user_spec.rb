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
    let(:uuid)        { SecureRandom.uuid }
    let(:study_uuid)  { SecureRandom.uuid }
    let(:user)        { IMedidataUser.new(imedidata_user_uuid: uuid) }
    let(:accepted_at) { Time.now.to_s }
    let(:apps)        { {'apps' => [{'uuid' => SecureRandom.uuid}, {'uuid' => MAUTH_APP_UUID}], 'accepted_at' => accepted_at} }
    let(:options)     { {user_uuid: uuid, study_uuid: study_uuid} }
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
      end
    end

    context 'when user is not assigned to the app' do
      let(:apps) { {'apps' => [{'uuid' => SecureRandom.uuid}], 'accepted_at' => accepted_at} }

      it('returns false') { expect(user.has_accepted_invitation?(options)).to eq(false) }
    end
  end
end