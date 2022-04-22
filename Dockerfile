FROM tiangolo/uvicorn-gunicorn:python3.9-slim

LABEL maintainer="info@mfdz.de"

WORKDIR /app

RUN \
	apt update \
	&& apt install -y \
	# GDAL headers are required for fiona, which is required for geopandas.
	# Also gcc is used to compile C++ code.
	libgdal-dev g++ \
	# libspatialindex is required for rtree.
	libspatialindex-dev \
	# Remove package index obtained by `apt update`.
	&& rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

COPY ./app /app/app
COPY config /app
COPY logging.conf /app
COPY prestart.sh /app
COPY enhancer.py /app