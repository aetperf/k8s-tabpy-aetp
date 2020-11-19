FROM continuumio/miniconda3:latest

MAINTAINER Architecture & Performance <dockerhub@architecture-performance.fr>

WORKDIR /tabpy

COPY requirements.txt tabpy.conf ./

RUN pip install --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt  \
  && pip install --upgrade tabpy

EXPOSE 9004

RUN su -c "tabpy --config /tabpy/tabpy.conf & (sleep 1 && tabpy-deploy-models)"

CMD ["sh", "-c", "tabpy --config=/tabpy/tabpy.conf"]


