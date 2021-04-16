# Django init
Create a new django-project and automatically get some boilerplate code generated
and project setup configured.
```
django-init.sh MYNEWPROJECT
```

## Create symbolic link to path.
```
git clone https://github.com/victorhook/django-init.git
cd django-init.sh
sudo ln -s $(pwd)/django-init.sh /usr/local/bin/
```

## Background
This serves as a wrapper on top of the normal django-admin startproject command.
I found myself always writing a bunch of boilerplate code when starting
new projects so I decided to put all the boilerplate in a script to start
a project for me.