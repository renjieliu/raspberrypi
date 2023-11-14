### Compile and Build PyArrow for ARM v7

- I am using a docker container for this process in order not to mess around with my current setup
- The output is named as pyarrow-1.0.1-cp37-cp37m-linux_armv7l.whl, under the folder /build/arrow/python/dist inside the docker container.
- The output whl can also be downloaded here - https://drive.google.com/drive/folders/13rdy69jtjF4rtf2K5-REzTPeFPQW4Uyy?usp=sharing
- Special thanks to [kpine/rpi-pyarrow-plasma](https://github.com/kpine/rpi-pyarrow-plasma)

Below is the Dockerfile

```
FROM balenalib/raspberrypi3-debian:buster-build as builder

ARG MAKE_JOBS=1
ARG ARROW_VERSION=1.0.1

RUN install_packages \
        autoconf \
        bison \
        ca-certificates \
        cmake \
        curl \
        cython3 \
        flex \
        g++ \
        gcc \
        libboost-dev \
        libboost-filesystem-dev \
        libboost-regex-dev \
        libboost-system-dev \
	libgflags-dev \
	libutf8proc-dev\
        libjemalloc-dev \
        libssl-dev \
        make \
        ninja-build \
        pkg-config \
        python3-dev \
        python3-numpy \
        python3-pandas \
        python3-pip \
        python3-psutil \
        python3-setuptools \
        python3-six \
        python3-wheel \
        rapidjson-dev \
        tzdata \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build/arrow
RUN curl --silent --show-error --fail --location \
      https://github.com/apache/arrow/archive/apache-arrow-${ARROW_VERSION}.tar.gz \
  | tar --strip-components=1 -xz

ENV ARROW_HOME=/dist
ENV CMAKE_BUILD_PARALLEL_LEVEL=${MAKE_JOBS}

WORKDIR /build/arrow/cpp/release
RUN cmake -G Ninja \
          -DCMAKE_INSTALL_PREFIX=${ARROW_HOME} \
          -DCMAKE_INSTALL_LIBDIR=lib \
          -DCMAKE_SHARED_LINKER_FLAGS="-latomic" \
          -DPYTHON_EXECUTABLE=/usr/bin/python3 \
          -DARROW_BUILD_STATIC=OFF \
          -DARROW_DEPENDENCY_SOURCE=SYSTEM \
          -DARROW_ENABLE_TIMING_TESTS=OFF \
          -DARROW_HOME=/dist \
          -DARROW_PLASMA=ON \
          -DARROW_PYTHON=ON \
          -DARROW_RPATH_ORIGIN=ON \
          -DARROW_USE_LD_GOLD=ON \
          .. \
 && ninja install

ENV PYARROW_CMAKE_GENERATOR=Ninja
ENV PYARROW_CMAKE_OPTIONS="-DARROW_USE_LD_GOLD=ON"
ENV PYARROW_WITH_PLASMA=1
ENV PYARROW_BUNDLE_ARROW_CPP=1

WORKDIR /build/arrow/python
RUN python3 setup.py build_ext bdist_wheel

FROM busybox
COPY --from=builder /build/arrow/python/dist/pyarrow-*.whl /dist/
CMD /bin/sh
```





