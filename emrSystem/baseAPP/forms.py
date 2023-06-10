from django.forms import ModelForm
from .models import PatientInformation
from .models import CheckInInformation

class PatientInformationForm(ModelForm):
    class Meta:
        model = PatientInformation
        fields = '__all__'


class CheckInformationForm(ModelForm):
    class Meta:
        model = CheckInInformation
        fields = '__all__'