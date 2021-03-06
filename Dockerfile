FROM python:3.8-slim-buster

# Set pip to have cleaner logs and no saved cache
ENV PIP_NO_CACHE_DIR=false \
    PIPENV_HIDE_EMOJIS=1 \
    PIPENV_IGNORE_VIRTUALENVS=1 \
    PIPENV_NOSPIN=1

# Change to workdir
WORKDIR /sfxdlebot/bot

# Copy and Grab Dependencies
COPY poetry.lock pyproject.toml ./
ARG PRODUCTION

RUN apt-get update \
    && apt-get install -y \
        libcairo2 \
    && rm -rf /var/lib/apt/lists/*

RUN pip --no-cache-dir install poetry \
    && POETRY_VIRTUALENVS_CREATE=false poetry install --no-root \
    && pip uninstall poetry -y \
    && rm -rf ~/.config/pypoetry

COPY . /sfxdlebot/

ENV PYTHONPATH="$PYTHONPATH:/sfxdlebot"

ENTRYPOINT ["python"]
CMD ["-m", "bot"]