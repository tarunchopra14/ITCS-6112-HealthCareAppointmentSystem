# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class AuthGroup(models.Model):
    name = models.CharField(unique=True, max_length=150)

    class Meta:
        managed = False
        db_table = 'auth_group'


class AuthGroupPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)
    permission = models.ForeignKey('AuthPermission', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_group_permissions'
        unique_together = (('group', 'permission'),)


class AuthPermission(models.Model):
    name = models.CharField(max_length=255)
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING)
    codename = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'auth_permission'
        unique_together = (('content_type', 'codename'),)


class AuthUser(models.Model):
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(blank=True, null=True)
    is_superuser = models.IntegerField()
    username = models.CharField(unique=True, max_length=150)
    first_name = models.CharField(max_length=150)
    last_name = models.CharField(max_length=150)
    email = models.CharField(max_length=254)
    is_staff = models.IntegerField()
    is_active = models.IntegerField()
    date_joined = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'auth_user'


class AuthUserGroups(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    group = models.ForeignKey(AuthGroup, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_groups'
        unique_together = (('user', 'group'),)


class AuthUserUserPermissions(models.Model):
    id = models.BigAutoField(primary_key=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)
    permission = models.ForeignKey(AuthPermission, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'auth_user_user_permissions'
        unique_together = (('user', 'permission'),)


class Bill(models.Model):
    clinic_care_info = models.ForeignKey('ClinicCareInformation', models.DO_NOTHING)
    fees = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'bill'


class CheckInInformation(models.Model):
    clinic_department = models.ForeignKey('ClinicDepartment', models.DO_NOTHING, blank=True, null=True)
    visit_type = models.ForeignKey('VisitType', models.DO_NOTHING, db_column='visit_type', blank=True, null=True)
    patient_weight = models.FloatField()
    date = models.DateField()
    from_time = models.TimeField()
    to_time = models.TimeField()
    status = models.CharField(max_length=50)
    new_patient = models.IntegerField()
    walk_in = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'check_in_information'


class ClinicCareInformation(models.Model):
    check_in_info = models.ForeignKey(CheckInInformation, models.DO_NOTHING)
    diagnoses = models.CharField(max_length=50, blank=True, null=True)
    test = models.CharField(max_length=60, blank=True, null=True)
    test_results = models.CharField(max_length=50, blank=True, null=True)
    prescription = models.CharField(max_length=150)
    fees = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        managed = False
        db_table = 'clinic_care_information'


class ClinicDepartment(models.Model):
    name = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'clinic_department'


class DjangoAdminLog(models.Model):
    action_time = models.DateTimeField()
    object_id = models.TextField(blank=True, null=True)
    object_repr = models.CharField(max_length=200)
    action_flag = models.PositiveSmallIntegerField()
    change_message = models.TextField()
    content_type = models.ForeignKey('DjangoContentType', models.DO_NOTHING, blank=True, null=True)
    user = models.ForeignKey(AuthUser, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'django_admin_log'


class DjangoContentType(models.Model):
    app_label = models.CharField(max_length=100)
    model = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'django_content_type'
        unique_together = (('app_label', 'model'),)


class DjangoMigrations(models.Model):
    id = models.BigAutoField(primary_key=True)
    app = models.CharField(max_length=255)
    name = models.CharField(max_length=255)
    applied = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_migrations'


class DjangoSession(models.Model):
    session_key = models.CharField(primary_key=True, max_length=40)
    session_data = models.TextField()
    expire_date = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'django_session'


class InsuranceInformation(models.Model):
    patient = models.ForeignKey('PatientInformation', models.DO_NOTHING)
    insurance_name = models.CharField(max_length=50, blank=True, null=True)
    member_id = models.CharField(max_length=20, blank=True, null=True)
    insurance_type = models.ForeignKey('InsuranceType', models.DO_NOTHING, db_column='insurance_type', blank=True, null=True)
    patient_relationship_to_insured = models.CharField(max_length=20, blank=True, null=True)
    patient_status = models.CharField(max_length=20, blank=True, null=True)
    provided_by_employeer = models.IntegerField(blank=True, null=True)
    payer_name = models.CharField(max_length=20, blank=True, null=True)
    plan_name = models.CharField(max_length=20, blank=True, null=True)
    co_pay = models.CharField(max_length=30, blank=True, null=True)
    balance = models.DecimalField(max_digits=10, decimal_places=2)
    address = models.CharField(max_length=20)
    zip_code = models.ForeignKey('ZipCode', models.DO_NOTHING, db_column='zip_code', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'insurance_information'


class InsuranceType(models.Model):
    type = models.CharField(max_length=15)

    class Meta:
        managed = False
        db_table = 'insurance_type'


class Medicine(models.Model):
    name = models.CharField(max_length=60)

    class Meta:
        managed = False
        db_table = 'medicine'


class PatientCheckIn(models.Model):
    patient = models.OneToOneField('PatientInformation', models.DO_NOTHING, primary_key=True)
    check_in_info = models.ForeignKey(CheckInInformation, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'patient_check_in'
        unique_together = (('patient', 'check_in_info'),)


class PatientEmergencyContactInformation(models.Model):
    patient = models.ForeignKey('PatientInformation', models.DO_NOTHING)
    first_name = models.CharField(max_length=20)
    last_name = models.CharField(max_length=20)
    relation_to_patient = models.CharField(max_length=20)
    phone = models.CharField(max_length=20)
    address = models.CharField(max_length=30, blank=True, null=True)
    zip_code = models.ForeignKey('ZipCode', models.DO_NOTHING, db_column='zip_code', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'patient_emergency_contact_information'


class PatientInformation(models.Model):
    first_name = models.CharField(max_length=20)
    last_name = models.CharField(max_length=20)
    gender = models.CharField(max_length=10)
    date_of_birth = models.DateField()
    age = models.IntegerField()
    race = models.CharField(max_length=20)
    phone = models.CharField(max_length=20)
    address = models.CharField(max_length=30)
    zip_code = models.ForeignKey('ZipCode', models.DO_NOTHING, db_column='zip_code', blank=True, null=True)
    email = models.CharField(max_length=30)
    maratial_status = models.CharField(max_length=10, blank=True, null=True)
    snn = models.CharField(max_length=20, blank=True, null=True)
    preferred_language = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'patient_information'


class PrescribeMedicine(models.Model):
    medicine = models.OneToOneField(Medicine, models.DO_NOTHING, primary_key=True)
    prescription = models.ForeignKey('Prescription', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'prescribe_medicine'
        unique_together = (('medicine', 'prescription'),)


class Prescription(models.Model):
    clinic_care_info = models.ForeignKey(ClinicCareInformation, models.DO_NOTHING, related_name='+')
    pharmacy_name = models.CharField(max_length=20)
    quantity = models.IntegerField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    duration = models.CharField(max_length=60, blank=True, null=True)
    date = models.DateField()
    caution = models.CharField(max_length=60)

    class Meta:
        managed = False
        db_table = 'prescription'


class ProviderInformation(models.Model):
    first_name = models.CharField(max_length=20)
    last_name = models.CharField(max_length=20)
    specialty = models.CharField(max_length=20)
    from_time = models.TimeField()
    to_time = models.TimeField()
    available = models.CharField(max_length=10)
    address = models.CharField(max_length=30, blank=True, null=True)
    zip_code = models.ForeignKey('ZipCode', models.DO_NOTHING, db_column='zip_code', blank=True, null=True)
    phone = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'provider_information'


class ProviderPatientCheckIn(models.Model):
    provider = models.OneToOneField(ProviderInformation, models.DO_NOTHING, primary_key=True)
    patient_check_in = models.ForeignKey(CheckInInformation, models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'provider_patient_check_in'
        unique_together = (('provider', 'patient_check_in'),)


class Supplier(models.Model):
    clinic_care_info = models.ForeignKey(ClinicCareInformation, models.DO_NOTHING)
    order_name = models.CharField(max_length=20)
    date = models.DateField(blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'supplier'


class VisitType(models.Model):
    type = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'visit_type'


class ZipCode(models.Model):
    id = models.CharField(primary_key=True, max_length=5)
    city_name = models.CharField(max_length=20)
    state = models.CharField(max_length=20)

    class Meta:
        managed = False
        db_table = 'zip_code'
