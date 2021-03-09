FROM python:3.9
WORKDIR /app
RUN pip install pipenv
ENV PIPENV_VENV_IN_PROJECT=true 
COPY Pipfile Pipfile.lock  /app/
RUN pipenv lock -r > requirements.txt
RUN pip install -r requirements.txt
COPY . /app
ENTRYPOINT [ "python"]