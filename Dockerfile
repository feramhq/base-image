FROM node:8.5

RUN apt-get update

# For basic debugging
RUN apt-get install -y vim

# Flowtype dependency
RUN apt-get install -y ocaml libelf-dev

#
# Install haskell ghc 8.0.2 from https://raw.githubusercontent.com/freebroccolo/docker-haskell/master/8.0/Dockerfile
#
# License for the haskell part:
  # The MIT License (MIT)
  #
  # Copyright (c) 2014-2015 Darin Morrison, Christopher Biscardi, Peter Salvatore
  #
  # Permission is hereby granted, free of charge, to any person obtaining a copy
  # of this software and associated documentation files (the "Software"), to deal
  # in the Software without restriction, including without limitation the rights
  # to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  # copies of the Software, and to permit persons to whom the Software is
  # furnished to do so, subject to the following conditions:
  #
  # The above copyright notice and this permission notice shall be included in all
  # copies or substantial portions of the Software.
  #
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  # AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  # LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  # OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  # SOFTWARE.
#
# BEGIN INSTALL HASKELL
#
ENV LANG            C.UTF-8
RUN echo 'deb http://ppa.launchpad.net/hvr/ghc/ubuntu trusty main' > /etc/apt/sources.list.d/ghc.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F6F88286 && \
    apt-get update && \
    apt-get install -y --no-install-recommends cabal-install-1.24 ghc-8.0.2 happy-1.19.5 alex-3.1.7 \
            zlib1g-dev libtinfo-dev libsqlite3-0 libsqlite3-dev ca-certificates g++ git curl && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v1.3.2/stack-1.3.2-linux-x86_64-static.tar.gz -o stack.tar.gz && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v1.3.2/stack-1.3.2-linux-x86_64-static.tar.gz.asc -o stack.tar.gz.asc && \
    apt-get purge -y --auto-remove curl && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C5705533DA4F78D8664B5DC0575159689BEFB442 && \
    gpg --batch --verify stack.tar.gz.asc stack.tar.gz && \
    tar -xf stack.tar.gz -C /usr/local/bin --strip-components=1 && \
    /usr/local/bin/stack config set system-ghc --global true && \
    rm -rf "$GNUPGHOME" /var/lib/apt/lists/* /stack.tar.gz.asc /stack.tar.gz

ENV PATH /root/.cabal/bin:/root/.local/bin:/opt/cabal/1.24/bin:/opt/ghc/8.0.2/bin:/opt/happy/1.19.5/bin:/opt/alex/3.1.7/bin:$PATH
#
# END INSTALL HASKELL
#

# Install basic haskell dependencies for scripts
RUN cabal update && cabal install protolude turtle
