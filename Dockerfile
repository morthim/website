FROM alpine:3

ARG img_ver
ENV IMAGE_VERSION ${img_ver}

LABEL org.opencontainers.image.title="Website" \
      org.opencontainers.image.description="My website -- morthimer.fr" \
      org.opencontainers.image.source="https://git.int.morthimer.fr/morthimer/website" \
      org.opencontainers.image.url="https://git.int.morthimer.fr/morthimer/website" \
      org.opencontainers.image.authors="morthimer"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"


RUN apk update && apk upgrade \
 && apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo go git \
 && addgroup -g 1000 morthimer \
 && adduser -u 1000 -G morthimer -s /bin/sh -D morthimer

USER morthimer
WORKDIR /home/morthimer

RUN hugo new site www \
 && cd www \
 && hugo mod init git.morthimer.fr
COPY --chown=morthimer:morthimer rootfs/ /
WORKDIR /home/morthimer/www

EXPOSE 1313
ENTRYPOINT [ "hugo" ]
CMD [ "server", "--bind", "0.0.0.0", "-w", "-D" ]
