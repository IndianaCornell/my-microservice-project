#!/bin/bash
set -e

echo "Starting installation..."

# Docker
if ! command -v docker >/dev/null 2>&1; then
  echo "Installing Docker..."
  sudo apt update
  sudo apt install -y docker.io
else
  echo "Docker already installed"
fi

# Docker Compose (classic)
if command -v docker-compose >/dev/null 2>&1; then
  echo "Docker Compose already installed"
else
  echo "Installing Docker Compose..."
  sudo apt update
  sudo apt install -y docker-compose
fi

# Python + pip
if ! command -v python3 >/dev/null 2>&1; then
  echo "Installing Python3 and pip..."
  sudo apt update
  sudo apt install -y python3 python3-pip
else
  echo "Python already installed"
fi

# pipx (safe way on Ubuntu/Debian with PEP 668)
if ! command -v pipx >/dev/null 2>&1; then
  echo "Installing pipx..."
  sudo apt update
  sudo apt install -y pipx
  pipx ensurepath
else
  echo "pipx already installed"
fi

# Django via pipx
if command -v django-admin >/dev/null 2>&1; then
  echo "Django already installed"
else
  echo "Installing Django via pipx..."
  pipx install django
fi

echo "All tools are installed"
