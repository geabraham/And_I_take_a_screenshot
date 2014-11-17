class PatientEnrollmentsController < ApplicationController

  def new
    # NOTE: @security_questions has no test. It is, for now, faked.
    @security_questions = ["What's the worst band in the world?"]
    @patient_enrollment = PatientEnrollment.new
  end
end
