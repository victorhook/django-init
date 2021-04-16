#!/bin/bash

if [ $# -eq 0 ] ; then 
    echo "First argument must be app name!"
    exit 0
fi

APP_NAME=$1

mkdir $APP_NAME
cd $APP_NAME

# Enable version control
git init
cp /home/victor/coding/tools/django-init/.gitignore .
echo \
"
${APP_NAME}/${APP_NAME}/settings.py
*.pyc
env/
" >> .gitignore

virtualenv env
source env/bin/activate
pip install django django-livereload-server

django-admin startproject $APP_NAME

echo \
"
#!/bin/bash
APP_ROOT=$(pwd)
APP_ENV=$(pwd)/${APP_NAME}

cd $(pwd)
source env/bin/activate

cd $(pwd)/${APP_NAME}
python manage.py livereload & python manage.py runserver
" >> run.sh
chmod +x run.sh


# Create default stuff
cd $APP_NAME
cp -r /home/victor/coding/tools/django-init/templates .
cp -r /home/victor/coding/tools/django-init/static .
cp /home/victor/coding/tools/django-init/urls.py ${APP_NAME}/
cp /home/victor/coding/tools/django-init/views.py ${APP_NAME}/

# Add stuff to settings.py
echo \
" 
# Auto-generated
DEPLOY = False

if DEPLOY:
    STATIC_ROOT = BASE_DIR.joinpath('static')
else:
    STATICFILES_DIRS = [
        BASE_DIR.joinpath('static')
    ]

MEDIA_URL = '/media/'
STATIC_URL = '/static/'
LOGIN_REDIRECT_URL = '/'
LOGOUT_REDIRECT_URL = '/'

if DEBUG:
    INSTALLED_APPS.append('livereload')
    MIDDLEWARE.append('livereload.middleware.LiveReloadScript')
" >> ${APP_NAME}/settings.py

# Need to enable template as well.
sed -i 's/\[\],/\[BASE_DIR.joinpath("templates")\],/' ${APP_NAME}/settings.py

# Migrate database.
python manage.py makemigrations 
python manage.py migrate

# Do first commit
git add -A
git commit -m "Initial commit."