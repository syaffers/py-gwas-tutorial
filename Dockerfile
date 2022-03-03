# Base.
FROM mambaorg/micromamba:0.22.0
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yml /tmp/env.yml
RUN micromamba install -y -f /tmp/env.yml && micromamba clean --all --yes

# Copy configs.
COPY jupyter_notebook_config.py /home/mambauser/.jupyter/jupyter_notebook_config.py

# Copy notebooks.
RUN [ "mkdir", "/home/mambauser/workdir" ]
COPY 0_Foreword.ipynb /home/mambauser/workdir/
COPY 1_QC_GWAS /home/mambauser/workdir/1_QC_GWAS

# Set starting directory.
USER root
RUN [ "chown", "-R", "mambauser:mambauser", "/home/mambauser/workdir" ]
USER mambauser

# Starting.
WORKDIR /home/mambauser/workdir
ARG MAMBA_DOCKERFILE_ACTIVATE=1
ENTRYPOINT [ "/usr/local/bin/_entrypoint.sh", "jupyter", "notebook" ]
