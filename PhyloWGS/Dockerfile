FROM ubuntu

RUN apt-get update && apt-get install -y gfortran build-essential \
make gcc build-essential python python-dev wget libgsl0ldbl \
gsl-bin libgsl0-dev python-pip git \
libblas-dev liblapack-dev

RUN pip install PyVCF

RUN pip install numpy scipy
RUN easy_install -U ete2

WORKDIR /opt

RUN git clone https://github.com/morrislab/smchet-challenge.git && cd smchet-challenge && git checkout master
RUN git clone https://github.com/morrislab/phylowgs.git && cd phylowgs && git checkout smchet4

RUN cd phylowgs && g++ -o mh.o -O3 mh.cpp  util.cpp `gsl-config --cflags --libs`
