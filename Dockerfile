FROM continuumio/miniconda3:4.9.2

MAINTAINER Architecture & Performance <dockerhub@architecture-performance.fr>

ARG TP_USER="tabpy"
ARG TP_UID="1000"
ARG TP_GID="100"

# Configure environment
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    TP_USER=$TP_USER \
    TP_UID=$TP_UID \
    TP_GID=$TP_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8


RUN apt-get install -y gcc \
  && adduser --home /$TP_USER --disabled-password --uid $TP_UID --gecos --quiet $TP_USER


COPY requirements.txt tabpy.conf /$TP_USER/
COPY fix-permissions.bash /usr/local/bin/fix-permissions
RUN chmod 555 /usr/local/bin/fix-permissions

WORKDIR /$TP_USER


RUN pip install --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt


RUN pip install --no-cache-dir --upgrade tabpy==2.3.1 \
  && mkdir /$TP_USER/state \
  && mkdir /$TP_USER/pwd \
  && conda clean --all -f -y  \
  && rm -rf /$TP_USER/.cache/ \
  && chown $TP_USER:$TB_GID $CONDA_DIR \
  && fix-permissions /$TP_USER \
  && fix-permissions /$CONDA_DIR

EXPOSE 9004


RUN sh -c "tabpy --config /$TP_USER/tabpy.conf & (sleep 1 && tabpy-deploy-models)"


USER $TP_USER

CMD ["sh", "-c", "tabpy --config /$TP_USER/tabpy.conf"]



