FROM python:3.6

LABEL maintainer="Aurum Kathuria <akathuria@rexhomes.com>"
LABEL version="1.0"
LABEL description="chatbot-repaint"

ENV LIB_PATH /usr/src/app

RUN mkdir -p ${LIB_PATH} \
	&& groupadd -g 999 appuser \
	&& useradd -r -u 999 -g appuser appuser \
	&& chown -R appuser ${LIB_PATH} \
	&& pip install --upgrade pip

WORKDIR ${LIB_PATH}
COPY requirements.txt ${LIB_PATH}
RUN pip install -r requirements.txt

COPY . .

ENV LISTEN_PORT 80
EXPOSE ${LISTEN_PORT}

CMD ["/usr/src/app/entrypoint.sh"]
