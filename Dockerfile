FROM alpine:3.20.3 AS builder

RUN apk add --no-cache python3 py3-pip

RUN python3 -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

FROM alpine:3.20.3 AS build

RUN apk add --no-cache python3 \ 
    && addgroup -S tux && adduser -S tux -G tux 

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv

USER tux

COPY app .

EXPOSE 5000

ENV PATH="/opt/venv/bin:$PATH"

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
