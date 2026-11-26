# Create your views here.
from rest_framework import viewsets

from consultations.serializers import ConsultationAppointmentSerializer

from .models import ConsultationAppointment


class ConsultationAppointmentViewSet(viewsets.ModelViewSet):
    queryset = ConsultationAppointment.objects.all()
    serializer_class = ConsultationAppointmentSerializer
