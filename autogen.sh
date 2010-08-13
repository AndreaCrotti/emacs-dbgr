#!/bin/sh
ln -vfs README.textile README
git submodule init
git submodule update
autoreconf -vi && \
autoconf && {
  echo "Running configure with --enable-maintainer-mode $@"
  ./configure --enable-maintainer-mode $@
}
