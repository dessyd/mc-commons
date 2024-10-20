FROM alpine:3.20
RUN apk --no-cache add \
  restic \
  bash \
  coreutils \
  curl \
  openssh-client \
  tzdata \
  zstd

COPY --chmod=755 *.sh /usr/local/bin/

VOLUME ["/data" ]
WORKDIR "/tmp"

ENTRYPOINT ["restore-restic-backup.sh"]

