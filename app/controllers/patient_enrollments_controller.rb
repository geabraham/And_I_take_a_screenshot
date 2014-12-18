require 'SecureRandom'

class PatientEnrollmentsController < ApplicationController
  layout "patient_registration"
  
  def new
    session[:patient_enrollment_uuid] = SecureRandom.uuid
    patient_enrollment_uuid = session[:patient_enrollment_uuid]
    @patient_enrollment = PatientEnrollment.new(uuid: patient_enrollment_uuid)
    # @tou_dpn_agreement_body = @patient_enrollment.tou_dpn_agreement_body
    @tou_dpn_agreement_body = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer lacinia urna justo, id vehicula lorem suscipit vitae. Vestibulum venenatis pulvinar nulla in placerat. Nam convallis ante ligula, vel egestas lorem tincidunt non. Pellentesque sed aliquam turpis. Aenean eget nibh velit. Cras mattis consequat nisi, a ultricies eros convallis sed. Nam at nisi ac metus pellentesque tristique. Integer justo tellus, lobortis vel pulvinar id, interdum ut lorem.

Integer orci risus, commodo vitae egestas at, aliquet sed elit. Aliquam erat volutpat. Suspendisse mattis massa eu libero sagittis, ac vulputate neque tincidunt. Donec turpis ante, dictum a suscipit non, molestie ut nisl. Vestibulum tristique enim sed est eleifend tincidunt. Duis nisl leo, rhoncus tempus sagittis sed, semper vitae risus. Maecenas id velit vitae lorem sodales vestibulum eu ac ligula. Suspendisse sit amet lorem condimentum, tempor sem a, facilisis dolor. Suspendisse eget nisl ligula. Nam aliquet feugiat pretium. Fusce laoreet lorem at augue volutpat luctus. Morbi in tortor eget erat fringilla faucibus vitae in tellus. Donec pellentesque consequat ullamcorper. Etiam mattis sagittis ultrices. Pellentesque a hendrerit augue.

Morbi laoreet porttitor urna, mattis auctor quam faucibus sit amet. Fusce dignissim tristique ligula quis ultrices. Nam viverra sagittis diam, eu pellentesque turpis hendrerit non. Nam dolor sem, fermentum non est a, lobortis porta libero. Nullam et augue bibendum, tempor neque at, scelerisque lacus. Sed accumsan odio sit amet nisl placerat hendrerit. Praesent sagittis tristique rhoncus. Curabitur ornare est sed dignissim interdum. Nam suscipit sollicitudin augue, eget venenatis turpis elementum ac.

Cras a laoreet dui, quis egestas ligula. Suspendisse accumsan tincidunt mauris a condimentum. Pellentesque placerat diam eu aliquet auctor. Nunc id risus lacus. Ut vestibulum eros id erat ultrices tincidunt. Sed eu velit tortor. Curabitur mi tellus, malesuada at elit sagittis, mollis vulputate quam. Nullam purus lectus, aliquet ac mi pulvinar, ultricies blandit erat. Vestibulum id tellus condimentum augue imperdiet sagittis quis ut ipsum. Phasellus sapien lacus, consequat vel sagittis eu, ultricies imperdiet nibh. Nam luctus risus vitae purus rutrum, quis sodales ante lobortis. Ut molestie convallis magna, quis rhoncus dolor convallis finibus. Aenean justo leo, semper et arcu accumsan, congue interdum ipsum. Pellentesque non ante erat. Aliquam sit amet enim imperdiet, consectetur sem sed, cursus nunc.

Nulla facilisi. Donec sagittis nibh turpis, sit amet molestie nulla facilisis ac. Phasellus dignissim dui quis neque ultrices lobortis. Pellentesque suscipit mi odio, et tristique orci consequat vitae. Aliquam sed tristique elit, et volutpat dolor. Pellentesque aliquam facilisis convallis. Suspendisse tincidunt, neque in rhoncus dapibus, nisl nulla aliquam orci, in congue dui mauris vel magna. Nullam viverra dui eu placerat malesuada. Maecenas eleifend consequat dictum. Praesent sollicitudin tortor nec tincidunt lacinia.

Pellentesque finibus accumsan pretium. Duis lobortis, arcu sed vulputate ullamcorper, mauris ligula lobortis odio, nec pretium tellus ante non est. Donec semper lectus sed tempus suscipit. Curabitur et felis sodales, scelerisque justo vitae, aliquam diam. Vivamus sed urna massa. Donec molestie convallis risus vel commodo. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut finibus ex in odio vehicula, et maximus risus rhoncus. Sed nunc est, volutpat vel dui nec, gravida pulvinar arcu. Aliquam nec ipsum ipsum. Pellentesque diam est, interdum eu massa sed, egestas mollis augue. Sed euismod commodo magna, ac egestas nibh finibus at. Nunc ut aliquam sem. Mauris vitae suscipit magna.

Etiam convallis ex nisi, quis porttitor massa ullamcorper nec. Maecenas et felis non nisl convallis condimentum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed sollicitudin sapien ut leo rhoncus, gravida eleifend ante aliquet. Donec rhoncus, nulla ac rhoncus elementum, orci quam venenatis metus, ut dictum turpis nibh eu tortor. Fusce sed leo a odio elementum rhoncus. Maecenas vel augue lobortis, bibendum leo id, bibendum ex.

Nam ut egestas nulla, at blandit lacus. Fusce commodo ante elit, vel placerat purus bibendum ac. Ut tristique, tortor eget aliquam iaculis, purus lectus porta nulla, at imperdiet odio quam rhoncus elit. Morbi nec lobortis orci, a congue erat. Etiam tincidunt odio eget sagittis tempor. Ut lacinia arcu a orci feugiat pulvinar. Integer at vulputate elit, quis congue tellus. Vestibulum at purus lacinia, malesuada sem non, ultricies nisi. Proin elementum urna sem, quis suscipit dolor efficitur eget. Pellentesque fermentum augue ligula, vehicula convallis nisl elementum eget. In vulputate enim risus, ut tempus velit semper ut. Suspendisse ornare, nulla et vulputate consectetur, nulla quam pulvinar metus, at sodales lectus magna id odio. Sed elementum ultrices nulla, in interdum urna gravida at.'

    @security_questions = ["Hi"]#RemoteSecurityQuestions.find_or_fetch(@patient_enrollment.language_code || I18n.default_locale).map { |sq| sq.values }
  rescue StandardError => e
    # TODO: render error modal
    return render json: {message: "Unable to continue with registration. Error: #{e.message}"}, status: 422
  end

  def create #TODO test this
    # TODO PATCH: /v1/patient_enrollments/:patient_enrollment_uuid/register
    
    render 'download'
  end
end
