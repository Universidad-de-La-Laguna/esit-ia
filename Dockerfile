FROM python:3.11
WORKDIR /workspace

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cargo/registry && \
    echo 'export PATH="/root/.cargo/bin:$PATH"' >> /root/.bashrc

ENV PATH="/root/.cargo/bin:$PATH"

COPY requirements.txt /workspace

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir transformers==4.47.0 --no-deps && \
    pip install --no-cache-dir -r requirements.txt

# Jupyter port
EXPOSE 8888

# Volume 
VOLUME ["/workspace"]

# Launch Jupyter
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]

