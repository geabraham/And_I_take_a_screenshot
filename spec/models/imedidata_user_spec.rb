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

  describe '#has_invitation?' do
    let(:uuid)       { SecureRandom.uuid }
    let(:study_uuid) { SecureRandom.uuid }
    let(:user)       { IMedidataUser.new(imedidata_user_uuid: uuid) }
    let(:apps)       { [{'uuid' => SecureRandom.uuid}, {'uuid' => MAUTH_APP_UUID}] }
    let(:options)    { {user_uuid: uuid, study_uuid: study_uuid} }
    before do
      allow(user).to receive(:request_invitation!).with(options).and_return(apps)
    end

    context 'when user is assigned to the app' do
      it('returns true') { expect(user.has_invitation?(options)).to eq(true) }
    end

    context 'when user is not assigned to the app' do
      let(:apps) { [{uuid: SecureRandom.uuid}] }

      it('returns false') { expect(user.has_invitation?(options)).to eq(false) }
    end
  end
end