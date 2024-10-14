FROM python

RUN apt update && \
    apt install openscad -y && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN pip install onshape-to-robot
ADD ./entrypoint.sh /usr/local/bin/entrypoint

ENV ONSHAPE_API=https://cad.onshape.com
# ENV ONSHAPE_ACCESS_KEY
# ENV ONSHAPE_SECRET_KEY

RUN mkdir /work
WORKDIR /work

ENTRYPOINT ["entrypoint"]