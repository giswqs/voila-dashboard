FROM quay.io/jupyter/base-notebook:latest

# -------------------------------------------------------
# 1. Install system-level packages (minimal, just git)
# -------------------------------------------------------
USER root
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

# -------------------------------------------------------
# 2. Install geospatial Python packages via conda (base env)
# -------------------------------------------------------
RUN mamba install -n base -c conda-forge \
    gdal \
    proj \
    geos \
    rasterio \
    pyproj \
    fiona \
    localtileserver \
    geopandas \
    rioxarray \
    maplibre \
    pmtiles \
    flask \
    flask-cors \
    tippecanoe \
    voila \
    leafmap \
    jupyter-server-proxy -y && \
    fix-permissions "${CONDA_DIR}"

# -------------------------------------------------------
# 3. Environment variables
# -------------------------------------------------------
ENV PROJ_LIB=/opt/conda/share/proj
ENV GDAL_DATA=/opt/conda/share/gdal
ENV LOCALTILESERVER_CLIENT_PREFIX='proxy/{port}'

# -------------------------------------------------------
# 4. Copy source code (do this *after* package installs to improve caching)
# -------------------------------------------------------
COPY . /home/jovyan/voila
WORKDIR /home/jovyan/voila


# -------------------------------------------------------
# 5. Build and install leafmap from source
# -------------------------------------------------------

RUN pip install -U leafmap==0.43.13 && \
    mkdir -p /home/jovyan/notebooks && \
    fix-permissions /home/jovyan

# -------------------------------------------------------
# 6. Set back to default user
# -------------------------------------------------------
WORKDIR /home/jovyan
USER jovyan


EXPOSE 8866

CMD ["/bin/bash", "/home/jovyan/voila/run.sh"]


# -------------------------------------------------------
# 7. Build and run
# -------------------------------------------------------
# docker run -it -p 8866:8866 -v $(pwd):/home/jovyan/notebooks giswqs/leafmap:voila 
# open http://localhost:8866 in your browser