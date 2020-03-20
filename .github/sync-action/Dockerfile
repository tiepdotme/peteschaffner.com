FROM ubuntu:19.10

RUN wget -qO- https://sitejs.org/install | bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]