FROM nvidia/cuda:11.0.3-runtime-ubuntu20.04
# install system packages
RUN apt update
RUN apt install -y git wget

WORKDIR /raft

# install conda
RUN mkdir -p ~/miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm ~/miniconda3/miniconda.sh
# install dependencies for
# RAFT: Recurrent All Pairs Field Transforms for Optical Flow, ECCV 2020
RUN . ~/miniconda3/bin/activate && conda create --name raft python=3.6
RUN . ~/miniconda3/bin/activate && conda activate raft && conda install pytorch=1.6.0 torchvision=0.7.0 cudatoolkit=10.1 -c pytorch
RUN . ~/miniconda3/bin/activate && conda activate raft && conda install matplotlib
RUN . ~/miniconda3/bin/activate && conda activate raft && conda install tensorboard
RUN . ~/miniconda3/bin/activate && conda activate raft && conda install scipy
RUN . ~/miniconda3/bin/activate && conda activate raft && conda install opencv
RUN . ~/miniconda3/bin/activate && conda activate raft && conda install tqdm
# download the version of RAFT bundled with flowsam
RUN git clone https://github.com/lukas-buergi/flowsam.git

# move to the beginning when I'm rebuilding anyway
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y ffmpeg

# glue
RUN sed -i 's|/path/to/dataset/|/output/|g' flowsam/flow/run_inference.py
COPY container-cmd.sh ./
RUN chmod +x container-cmd.sh
ENTRYPOINT ["/raft/container-cmd.sh"]
