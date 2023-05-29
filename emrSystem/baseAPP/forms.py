from django.forms import ModelForm
from .models import PatientInformation

class PatientInformationForm(ModelForm):
    class Meta:
        model = PatientInformation
        fields = '__all__'