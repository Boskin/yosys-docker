from ubuntu:16.04

# Install dependencies
RUN apt-get update && apt-get install -y \
  build-essential \
  bison \
  flex \
  libreadline-dev \
  gawk \
  tcl-dev \
  libffi-dev \
  git \
  graphviz \
  xdot \
  pkg-config \
  python3 \
  libboost-system-dev \
  libboost-python-dev \
  libboost-filesystem-dev \
  zlib1g-dev

# Fetch and install yosys
RUN git clone https://github.com/YosysHQ/yosys.git && \
  cd yosys && make config-gcc && make -j$(nproc) && make install && \
  cd ../ && rm -rf yosys/

# Fetch and install z3
RUN git clone https://github.com/Z3Prover/z3.git && \
  cd z3 && \
  python scripts/mk_make.py --prefix=/usr/local && \
  cd build && make -j$(nproc) && make install && \
  cd ../../ && rm -rf z3/


# Fetch and install symbiyosys
RUN git clone https://github.com/YosysHQ/SymbiYosys.git && \
  cd SymbiYosys && make -j$(nproc) && make install && \
  cd ../ && rm -rf SymbiYosys


# Setup user and workspace
RUN adduser --disabled-password --gecos '' claude

USER claude
WORKDIR /home/claude

# Fetch tmux settings
RUN git clone https://github.com/Boskin/tmux-conf.git && ln -s tmux-conf/.tmux.conf ~/.tmux.conf

