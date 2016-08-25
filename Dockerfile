FROM hudl/ffmpeg

# Dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    gfortran \
    libatlas-base-dev \
    libmysqlclient-dev \
    mysql-server \
    mysql-client \
    python \
    python-dev \
    wget

# Download OpenCV and extra modules
RUN apt-get install -y libopencv-dev python-opencv

# Install pip
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py && rm get-pip.py
RUN pip install --upgrade pip

COPY ./requirements.txt /root/
RUN pip install -r /root/requirements.txt

RUN git clone https://github.com/jbencook/vatic.git /root/vatic
RUN git clone https://github.com/jbencook/turkic.git /root/turkic
RUN git clone https://github.com/jbencook/pyvision.git /root/pyvision
RUN git clone https://github.com/jbencook/vatic_tracking.git /root/vatic_tracking

WORKDIR /root/turkic
RUN python setup.py install

WORKDIR /root/pyvision
RUN python setup.py install

WORKDIR /root/vatic_tracking
RUN python setup.py install

WORKDIR /root/vatic
CMD python start_server.py