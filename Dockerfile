FROM python:3.7.0

RUN set -ex && pip install pipenv --upgrade

# sphinxcontrib-spelling dependency
RUN apt-get update \
  && apt-get install -yqq libenchant-dev

COPY Pipfile Pipfile
RUN set -ex && pipenv lock && pipenv install --system --deploy --dev

COPY docs/ /docs/
WORKDIR /docs
