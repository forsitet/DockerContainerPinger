#!/bin/bash

python manage.py migrate

echo "Create a superuser if it doesn't exist"
python manage.py shell -c "
from django.contrib.auth import get_user_model

User = get_user_model()
try:
    if not User.objects.filter(username='forsitet').exists():
            User.objects.create_superuser('forsitet', '12345')
            print('Суперпользователь создан!')
    else:
        print('Суперпользователь уже существует.')
except Exception as e:
        print(f'Ошибка: {str(e)}')
"
exec python manage.py runserver 0.0.0.0:8095
