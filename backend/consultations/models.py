from django.contrib.auth import get_user_model
from django.db import models
from django.utils.translation import gettext_lazy as _

User = get_user_model()


class ConsultationAppointment(models.Model):
    date = models.DateField(_("Datum"))
    time = models.TimeField(_("Uhrzeit"))
    advice_seeker = models.CharField(_("Ratsuchende*r"), max_length=255)
    consultant = models.CharField(_("Berater"), max_length=255)
    language = models.CharField(_("Language"), max_length=255)
    concern = models.TextField(_("Anliegen"), null=True, blank=True)
    comment = models.TextField(_("Anmerkung"), null=True, blank=True)
    first_time = models.BooleanField(_("Erste Beratung"), default=True)
