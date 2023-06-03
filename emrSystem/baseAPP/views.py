from django.shortcuts import render, redirect
from django.db import connection
from .forms import PatientInformationForm
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
        if form.is_valid():
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