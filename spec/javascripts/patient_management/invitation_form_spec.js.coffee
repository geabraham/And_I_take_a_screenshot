describe 'patient management invitation form', ->
  subject = 'Subject-000'
  countryLanguagePair = "{'language_code':'ara','country_code':'ISR'}"

  describe 'invite button', ->
    beforeEach ->
      loadFixtures 'patient_management/invite.html'

    describe 'when a subject is selected', ->
      beforeEach ->
        $('#_patient_management_invite_subject').val(subject).change()

      it 'is disabled', ->
        expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

    describe 'when a country / language pair is selected', ->
      beforeEach ->
        $('#_patient_management_invite_country_language').val(countryLanguagePair).change()

      it 'is disabled', ->
        expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

    describe 'when both a subject and country / language pair are selected', ->
      beforeEach ->
        $('#_patient_management_invite_subject').val(subject).change()
        $('#_patient_management_invite_country_language').val(countryLanguagePair).change()

      it 'is enabled', ->
        expect($('input#invite-button')).not.toHaveAttr('disabled')

    describe 'when it is enabled and then a subject is deselected', ->
      beforeEach ->
        $('#_patient_management_invite_subject').val(subject).change()
        $('#_patient_management_invite_country_language').val(countryLanguagePair).change()
        $('#_patient_management_invite_subject').val('').change()

      it 'is disabled', ->
        expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')
