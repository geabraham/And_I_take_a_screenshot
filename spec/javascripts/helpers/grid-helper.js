var MUI = {};
MUI.patientEnrollments = [];
var x = 0;

while (x < 106) {
  MUI.patientEnrollments.push({
    activation_code: '24',
    created_at: '24-MAR-2015',
    email: '33*@gh**.com',
    initials: 'CMB',
    state: 'Invited',
    subject_id: 'MN008'
  });
  x++;
}

$('#total-count').html(MUI.patientEnrollments.length);