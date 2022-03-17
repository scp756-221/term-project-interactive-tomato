FROM python:3.8-bullseye

WORKDIR /code

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY conftest.py create_tables.py ./
