#!/bin/bash

# Скрипт для автоматичного встановлення Docker, Docker Compose, Python і Django
# Ubuntu/Debian

set -e

echo "Starting the development environment installation"

# Оновлення пакетів
echo "-> Updating package list..."
sudo apt-get update -y

# Встановлення Docker
if ! command -v docker &> /dev/null
then
    echo "-> Install Docker..."
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce
    sudo systemctl enable docker
    sudo systemctl start docker
    echo "Docker instaled!"
else
    echo "Docker exist..."
fi

# Встановлення Docker Compose
if ! docker compose version &> /dev/null
then
    echo "-> Install Docker Compose..."
    sudo apt-get install -y docker-compose-plugin
    echo "Docker Compose instaled!"
else
    echo "Docker Compose exist..."
fi

# Встановлення Python 3.9+
if ! command -v python3 &> /dev/null
then
    echo "-> Install Python 3..."
    sudo apt-get install -y python3 python3-pip python3-venv
else
    PYTHON_VERSION=$(python3 -V | awk '{print $2}')
    if [ "$(printf '%s\n' "3.9" "$PYTHON_VERSION" | sort -V | head -n1)" = "3.9" ]; then
        echo "Python $PYTHON_VERSION is OK"
    else
        echo "-> Update Python to 3.9+..."
        sudo apt-get install -y python3.9 python3.9-venv python3.9-distutils
        sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 2
    fi
fi

# Встановлення Django
if ! python3 -m pip show django &> /dev/null
then
    echo ">> Install Django..."
    python3 -m pip install --upgrade pip
    python3 -m pip install django
    echo "Django instaled!"
else
    echo "Django exist..."
fi

echo "-> Ready!"
