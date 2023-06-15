from django.shortcuts import render, redirect
from django.db import connection
from .forms import PatientInformationForm
from .forms import CheckInformationForm
from .forms import ProviderInformationForm
from .models import PatientInformation

# Create your views here.

def home(request):
    cursor = connection.cursor()
    cursor.execute('call sp_get_patient_information()')
    patients = cursor.fetchall()
    cursor.execute('call sp_get_all_visits_view()')
    visits = cursor.fetchall()
    cursor.close()
    context = {'patients' : patients, 'visits' : visits}
    return render(request, 'home.html', context)

def registerPatient(request):
    form = PatientInformationForm()
    if request.method == 'POST':
        if form.is_valid:
            add_patient(request.POST)
            return redirect('emrSystem')
    context = {'form' : form}
    return render(request, 'patient_form.html', context)


def updatePatient(request, pk):
    patient = PatientInformation.objects.get(id=pk)
    form = PatientInformationForm(instance=patient)
    if request.method == 'POST':
        form = PatientInformationForm(request.POST, instance=patient)
        if form.is_valid():
            form.save()
            return redirect('emrSystem')
    context = {'form': form}
    return render(request, 'patient_form.html', context)

def deletePatient(request, pk):
    patient = PatientInformation.objects.get(id=pk)
    if request.method == 'POST':
        patient.delete()
        return redirect('emrSystem')
    return render(request, 'delete.html', {'obj': patient})

def add_patient(data):
    first_name = str(data['first_name'])
    last_name = str(data['last_name'])
    gender = data['gender']
    date_of_birth = str(data['date_of_birth'])
    age = int(data['age'])
    race = str(data['race'])
    phone = str(data['phone'])
    address = str(data['address'])
    zip_code = str(data['zip_code'])
    email = str(data['email'])
    if str(data['maratial_status']) == 'no':
        maratial_status = 0
    elif str(data['maratial_status']) == 'yes':
        maratial_status = 1
    maratial_status = str(data['maratial_status'])
    snn = str(data['snn'])
    preferred_language = str(data['preferred_language'])
    cursor = connection.cursor()
    cursor.callproc('sp_insert_patient_information', [first_name, last_name, gender, date_of_birth, age, race, phone, address, zip_code, email, maratial_status, snn, preferred_language])

def checkinPatient(request):
    form = CheckInformationForm()
    if request.method == 'POST':
        #if form.is_valid():
            check_in_patient(request.POST)
            return redirect('emrSystem')
    context = {'form' : form}
    return render(request, 'check_in_form.html', context)


def check_in_patient(data):
    patient_weight = int(data['patient_weight']) ##int
    visit_type = int(data['visit_type'])
    patient_weight = float(data['patient_weight'])
    date = str(data['date'])
    from_time = str(data['from_time'])
    to_time = str(data['to_time'])
    status = str(data['status'])
    new_patient = bool(data['new_patient'])
    walk_in = bool(data['walk_in'])
    cursor = connection.cursor()
    cursor.callproc('sp_insert_check_in_information', [patient_weight, visit_type, patient_weight, date, from_time, to_time, status, new_patient, walk_in])

def addProvider(request):
    form = ProviderInformationForm()
    if request.method == 'POST':
        if form.is_valid:
            add_provider_information(request.POST)
            return redirect('emrSystem')
    context = {'form' : form}
    return render(request, 'provider_form.html', context)

def add_provider_information(data):
    first_name = str(data['first_name'])
    last_name = str(data['last_name'])
    specialty = str(data['specialty'])
    from_time = str(data['from_time'])  #TODO: check
    to_time = str(data['to_time'])  #TODO: check
    available = str(data['available']) 
    address = str(data['address'])
    zip_code = str(data['zip_code'])
    phone = str(data['phone'])
    cursor = connection.cursor()
    cursor.callproc('sp_insert_provider_information', [first_name, last_name, specialty, from_time, to_time, available, address, zip_code, phone])
