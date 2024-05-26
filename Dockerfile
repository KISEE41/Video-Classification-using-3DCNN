FROM python:3.9-slim-bookworm

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    # pip:
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    # poetry:
    POETRY_VERSION=1.8.3 \
    POETRY_NO_INTERACTION=1 \
    POETRY_CACHE_DIR='/var/cache/pypoetry' \
    PATH="$PATH:/root/.local/bin"

# Update and install libgl
RUN apt-get update && apt-get install --no-install-recommends -y
RUN pip install "poetry==$POETRY_VERSION"

# COPY only requirements to cache in docker layer
WORKDIR /home/app

# # Copy only the necessary files for installing dependencies first
# COPY pyproject.toml poetry.lock ./

# Project initialization
RUN poetry config virtualenvs.create false \
    && poetry add $(cat requirements.txt)

# Creating folders, and files for a project:
COPY . /home/app/

# Exchanging port for intercommunication between containers
# EXPOSE 80

# # CMD poetry run python main.py
# ENTRYPOINT ["poetry", "run"]
# CMD ["python", "train_main.py"]
