from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='emrSystem'),
    path('register-patient/', views.registerPatient, name='register-patient'),
    path('update-patient/<str:pk>/', views.updatePatient, name='update-patient'),
    path('delete-patient/<str:pk>/', views.deletePatient, name='delete-patient'),
    path('check_in_patient/', views.checkinPatient, name='check_in_patient'),
]