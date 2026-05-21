FROM adelielinux/adelie:1.0-beta6

# Install OpenSSH server and Gitolite
# Unlock the automatically-created git user
RUN set -x \
 && apk add --no-cache lighttpd cgit

COPY conf/lighttpd/cgit.conf /etc/lighttpd/cgit.conf
RUN echo 'include "cgit.conf"' >> /etc/lighttpd/lighttpd.conf

COPY conf/cgitrc /etc/cgitrc
RUN mkdir -p /var/cache/cgit

# Default command is to run the lighttpd server with cgit
CMD ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
