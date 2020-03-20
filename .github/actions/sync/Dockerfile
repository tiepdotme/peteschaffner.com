FROM ubuntu:19.10

RUN apt update
RUN apt -y install sudo wget openssh-client

RUN wget -qO- https://sitejs.org/install | bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]