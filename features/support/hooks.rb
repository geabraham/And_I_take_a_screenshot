Before('@PatientFlow') do
  @security_questions ||= [{name: 'In what year were you born?', id: '1'},
                         {name: 'What was the make of your first car or bike?', id: '2'}]
  @patient_enrollment_uuid ||= SecureRandom.uuid
  @activation_code ||= ([*('A'..'Z'),*('0'..'9')] - %w(I O 1 0)).sample(6).join
  @activation_code_attrs ||= {
    state: 'active',
    patient_enrollment_uuid: @patient_enrollment_uuid,
    activation_code: @activation_code
  }.stringify_keys
  @invalid_activation_code_attrs ||= @activation_code_attrs.merge({'state' => 'inactive'})
  @tou_dpn_agreement ||= {
    html: '<html><body>We think in generalities, but we live in detail.</body></html>', 
    language_code: 'eng'
  }.stringify_keys
  @patient_enrollment ||= build :patient_enrollment, uuid: @patient_enrollment_uuid, login: 'the-dude@mdsol.com', 
    password: 'B0wl11ng', answer: 'The Eagles', activation_code: @activation_code
  @security_question ||= @security_questions.sample
  @patient_enrollment_register_params ||= {
    login: @patient_enrollment.login,
    password: @patient_enrollment.password,
    activation_code: @activation_code,
    security_question_id: @security_question[:id],
    answer: @patient_enrollment.answer,
    tou_accepted_at: /[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2} [-|\+|][0-9]{4}/
  }
end
