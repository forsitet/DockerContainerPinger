from django.contrib import admin
from django import forms
from .models import User

class UserAdminForm(forms.ModelForm):
    class Meta:
        model = User
        fields = ('username', 'password', 'is_admin')

    def clean_password(self):
        password = self.cleaned_data.get("password")
        if not password.startswith('pbkdf2_'):
            from django.contrib.auth.hashers import make_password
            return make_password(password)
        return password

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    form = UserAdminForm
    list_display = ('id', 'username', 'is_admin')
    search_fields = ('username',)
