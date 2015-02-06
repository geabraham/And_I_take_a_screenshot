describe 'patient management invitation form', ->
  subject = 'Subject-000'
  countryLanguagePair = "{'language_code':'ara','country_code':'ISR'}"

  describe 'invite button', ->
    beforeEach ->
      loadFixtures 'patient_management/invite.html'

    it 'is disabled when a subject is selected', ->
      $('#_patient_management_invite_subject').val(subject).change()
      expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

    it 'is disabled when a country / language pair is selected', ->
      $('#_patient_management_invite_country_language').val(countryLanguagePair).change()
      expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

    it 'is enabled when both a subject and a country / language pair are selected', ->
      $('#_patient_management_invite_subject').val(subject).change()
      $('#_patient_management_invite_country_language').val(countryLanguagePair).change()
      expect($('input#invite-button')).not.toHaveAttr('disabled')

    it 'is disabled when it is enabled and then a subject is deselected', ->
      $('#_patient_management_invite_subject').val(subject).change()
      $('#_patient_management_invite_country_language').val(countryLanguagePair).change()
      $('#_patient_management_invite_subject').val('').change()
      expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')
