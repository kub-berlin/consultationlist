from rest_framework import serializers

from .models import ConsultationAppointment


class ConsultationAppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = ConsultationAppointment
        fields = "__all__"
