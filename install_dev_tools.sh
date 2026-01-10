#!/bin/bash
set -e

echo "Starting installation..."

has() { command -v "$1" >/dev/null 2>&1; }

python_ok() {
  if ! has python3; then
    return 1
  fi
  python3 - <<'PY'
import sys
sys.exit(0 if sys.version_info >= (3, 9) else 1)
PY
}

NEED_UPDATE=0

if ! has docker; then
  NEED_UPDATE=1
else
  echo "Docker already installed"
fi

if ! has docker-compose; then
  NEED_UPDATE=1
else
  echo "Docker Compose already installed"
fi

if ! python_ok; then
  NEED_UPDATE=1
else
  echo "Python version OK"
fi

if ! python3 -m pip --version >/dev/null 2>&1; then
  NEED_UPDATE=1
fi

if [ "$NEED_UPDATE" -eq 1 ]; then
  sudo apt update
fi

if ! has docker; then
  sudo apt install -y docker.io
fi

if ! has docker-compose; then
  sudo apt install -y docker-compose
fi

if ! python_ok; then
  sudo apt install -y python3 python3-pip
fi

if ! python3 -m django --version >/dev/null 2>&1; then
  sudo apt install -y python3-django
else
  echo "Django already installed"
fi

chmod +x "$0"
echo "All tools are installed"
