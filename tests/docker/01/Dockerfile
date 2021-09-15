FROM python:3.8.8-buster

COPY . /app

ENV ENVIRONMENT test

RUN pip install -r /app/requirements.txt
RUN pip install -r /app/additional-requirements.txt
RUN pip install --upgrade pip

RUN apt-get update && \
    apt-get install -y curl libssl-dev && \
    chmod +x /app/entrypoint.sh

USER root

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD ["python", "-m", "application"]
