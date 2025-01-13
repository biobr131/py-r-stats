FROM condaforge/miniforge3:latest

ARG DIR_WORK
WORKDIR ${DIR_WORK}

RUN apt-get update && apt-get install -y build-essential gcc g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG ENV_YML
ARG DIR_WORK
COPY ${ENV_YML} ${DIR_WORK}/
ARG DIR_MFAPY
COPY ${DIR_MFAPY}/ ${DIR_WORK}/${DIR_MFAPY}
ARG ENV_YML
ARG VENV
RUN conda update -y -c conda-forge conda && \
    conda env create --file ${ENV_YML}

ARG DIR_CONDA
ENV PATH ${DIR_CONDA}/envs/${VENV}/bin:$PATH
SHELL ["conda", "run", "--name", "stats", "/bin/bash", "-c"]
ARG REQ_TXT
COPY ${REQ_TXT} ${DIR_WORK}/
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r ${REQ_TXT}
