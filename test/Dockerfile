FROM python:3.8-bullseye

WORKDIR /code

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY conftest.py create_tables.py ./

CMD ["python", "ci_test.py", "s1", "30000", "s2", "30001", "scp756-221"]
