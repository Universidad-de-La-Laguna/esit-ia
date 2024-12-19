FROM nvidia/cuda:12.6.3-runtime-ubuntu20.04
WORKDIR /workspace

RUN apt-get update && apt-get install -y \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main" > /etc/apt/sources.list.d/deadsnakes.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys BA6932366A755776 && \
    apt-get update
RUN apt-get install -y python3.11 python3.11-venv python3.11-dev && rm -rf /var/lib/apt/lists/*
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3.11 get-pip.py && rm get-pip.py

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /root/.cargo/registry \
    && echo 'export PATH="/root/.cargo/bin:$PATH"' >> /root/.bashrc

ENV PATH="/root/.cargo/bin:$PATH"

COPY requirements.txt /workspace

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir transformers==4.47.0 --no-deps
RUN pip install --no-cache-dir -r requirements.txt

# Jupyter port
EXPOSE 8888

# Volume 
VOLUME ["/workspace"]

# Launch Jupyter
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]

