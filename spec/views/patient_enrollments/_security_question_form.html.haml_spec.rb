require 'spec_helper'

describe 'patient_enrollments/_security_question_form.html.haml' do
  describe 'rendering form' do
    before do
      @patient_enrollment = PatientEnrollment.new
      @security_questions = [['What year were you born?', '1'],
                             ['Last four digits of SSN or Tax ID number?', '2'],
                             ['What is your father\'s middle name?', '3'],
                             ['What was the name of your first school?', '4'],
                             ['Who was your childhood hero?', '5'],
                             ['What is your favorite pastime?', '6'],
                             ['What is your all-time favorite sports team?', '7'],
                             ['What was your high school team or mascot?', '8'],
                             ['What make was your first car or bike?', '9'],
                             ['What is your pets name?', '10'],
                             ['What is your mother\'s middle name?', '11']]
      render
    end
    
    it 'displays the expected instruction text' do
      expect(rendered).to have_selector('select#patient_enrollment_security_question')
    end
    
    it 'displays the security_questions as a drop down of 12 items (11 questions + 1 blank)' do
      expect(rendered).to have_selector('option', count: 12)
    end

    it 'includes the security question text' do
      expect(rendered).to have_selector('option', text: @security_questions[0][0])
    end
  end
end
