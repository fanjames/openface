FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

MAINTAINER fanhua

# Add a few needed packages to the base Ubuntu 16.04
# OK, maybe *you* don't need emacs :-)
RUN \
    apt-get update && apt-get install -y \
    python-pip \
    build-essential \
    curl \
    git \
    cmake \
    wget \
    && rm -rf /var/lib/lists/*


RUN pip install opencv-python matplotlib && \
    git clone https://github.com/davisking/dlib.git && \
    cd dlib && \
    python setup.py install --yes DLIB_USE_CUDA --yes USE_AVX_INSTRUCTIONS && \
    cd .. && rm -rf dlib

RUN cd /root && \
    git clone https://github.com/cmusatyalab/openface.git && \
    cd openface && \
    ./models/get-models.sh && \
    pip install -r requirements.txt && \
    python setup.py install && \
    pip install --user --ignore-installed -r demos/web/requirements.txt


EXPOSE 8000 9000
CMD /bin/bash -l -c '/root/openface/demos/web/start-servers.sh'
