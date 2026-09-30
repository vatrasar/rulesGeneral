---
trigger: always_on

---
# deployment
I don't want to use python scripts and import dependencies to my main python environment. thus use virtual venv as environment for development. then for publish make bash script install.sh which in folder
~/.local/share/appName (where appName should be replaced with name of your app) put python scripts and create there virtual venv and install in it all required dependecies. it also should create bash script and put it in ~/.local/bin/. this bash script should allow to use python script as linux command. NEVER RUN install.sh by yourself because it is possible that i don't want to install script on development mashine.