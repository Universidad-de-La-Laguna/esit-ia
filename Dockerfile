FROM nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

# Actualizar los paquetes e instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common && \
    apt-get update
RUN apt-get install -y build-essential \
        curl \
        git \
        wget \
        libgl1 \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxrender1

RUN apt-get install -y python3.10 \
        python3.10-venv \
        python3.10-dev \
        python3-pip
RUN rm -rf /var/lib/apt/lists/*

# Actualizar pip e instalar TensorFlow, Keras y otras dependencias
RUN python3.10 -m pip install --upgrade pip
RUN python3.10 -m pip install tensorflow==2.15.0 keras keras-cv matplotlib

# Verificar la instalación de CUDA y cuDNN
RUN nvcc --version

# Establecer el directorio de trabajo
WORKDIR /workspace

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cargo/registry \
    && echo 'export PATH="/root/.cargo/bin:$PATH"' >> /root/.bashrc

ENV PATH="/root/.cargo/bin:$PATH"

COPY requirements.txt /workspace
RUN python3.10 -m pip install --no-cache-dir transformers==4.47.0 --no-deps
RUN python3.10 -m pip install --no-cache-dir -r requirements.txt

# Jupyter port
EXPOSE 8888

# Volume
VOLUME ["/workspace"]

# Launch Jupyter
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
