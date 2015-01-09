describe PatientManagementController do
  before do
    # Create a provider who is authorized for Study X
  end

  describe 'select_site_and_study' do
    context 'without user logged in'
      it 'redirects to iMedidata'

    context 'with user logged in'
      context 'without study or study group parameter'
        it 'displays a helpful error message'

      context 'with study group parameter'
        it 'makes a roles request to iMedidata for the user for the study group'

        context 'when user is an authorized provider for the study group'
          it 'makes a request for the studies for that study group and user'

        context 'when user is not an authorized provider for the study group'
          it 'displays a helpful error message'

      context 'with study parameter'
        it 'makes a roles to iMedidata for the user for the study'

        context 'when user ia an authorized provider for the study'
          it 'makes a request for the sites for that study and user'

        context 'when user is not an authorized provider for the study'
          it 'displays a helpful error message'
  end
end