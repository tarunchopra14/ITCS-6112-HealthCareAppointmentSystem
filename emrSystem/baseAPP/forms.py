from django.forms import ModelForm
from .models import PatientInformation
from .models import CheckInInformation
from .models import ProviderInformation

class PatientInformationForm(ModelForm):
    class Meta:
        model = PatientInformation
        fields = '__all__'


class CheckInformationForm(ModelForm):
    class Meta:
        model = CheckInInformation
        fields = '__all__'

class ProviderInformationForm(ModelForm): 
    class Meta:
        model = ProviderInformation
        fields = '__all__'