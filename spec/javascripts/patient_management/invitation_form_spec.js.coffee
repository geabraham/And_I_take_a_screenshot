describe 'patient management invitation form', ->
  describe 'invite button', ->
    beforeEach ->
      loadFixtures 'patient_management/invite.html'

    it 'is disabled when a subject is selected', ->
      $('#_patient_management_invite_subject').val('Subject-000').change()
      expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

    it 'is disabled when a country / language pair is selected', ->
      $('#_patient_management_invite_country_language').val("{'language_code':'ara','country_code':'ISR'}").change()
      expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

    it 'is enabled when both a subject and a country / language pair are selected', ->
      $('#_patient_management_invite_subject').val('Subject-000').change()
      $('#_patient_management_invite_country_language').val("{'language_code':'deu','country_code':'DEU'}").change()
      expect($('input#invite-button')).not.toHaveAttr('disabled')

    it 'is disabled when it is enabled and then a subject is deselected', ->
      $('#_patient_management_invite_subject').val('Subject-000').change()
      $('#_patient_management_invite_country_language').val("{'language_code':'deu','country_code':'DEU'}").change()
      $('#_patient_management_invite_subject').val('').change()
      expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')
