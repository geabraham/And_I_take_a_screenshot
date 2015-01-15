describe IMedidataClient::InvitationRequest do
  let(:user_uuid)          { SecureRandom.uuid }
  let(:study_group_uuid)   { SecureRandom.uuid }
  let(:invitation_request) { IMedidataClient::InvitationRequest.new(user_uuid: user_uuid, study_group_uuid: study_group_uuid) }

  describe '#path' do
    context 'with study group uuid' do
      it 'is the right path' do
        expect(invitation_request.path).to eq("/api/v2/study_groups/#{study_group_uuid}/users/#{user_uuid}/invitation.json")
      end
    end
  end
end
