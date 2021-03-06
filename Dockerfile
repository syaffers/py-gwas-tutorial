# Base.
FROM mambaorg/micromamba:0.22.0
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yml /tmp/env.yml
RUN micromamba install -y -f /tmp/env.yml && micromamba clean --all --yes
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN pip install qmplot

# Copy configs.
COPY jupyter_notebook_config.py /home/mambauser/.jupyter/jupyter_notebook_config.py

# Copy notebooks.
RUN [ "mkdir", "/home/mambauser/workdir" ]
COPY 0_Foreword.ipynb /home/mambauser/workdir/
COPY 1_QC_GWAS /home/mambauser/workdir/1_QC_GWAS
COPY 2_Population_stratification /home/mambauser/workdir/2_Population_stratification
COPY 3_Association_GWAS /home/mambauser/workdir/3_Association_GWAS

# Set starting directory.
USER root
RUN [ "chown", "-R", "mambauser:mambauser", "/home/mambauser/workdir" ]
USER mambauser

# Starting.
WORKDIR /home/mambauser/workdir
ENTRYPOINT [ "/usr/local/bin/_entrypoint.sh", "jupyter", "notebook" ]
