FROM node:8.1

RUN apt-get update

# Install yarn
RUN apt-get update && apt-get install apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y \
  # JavaScript dependency management
  yarn \
  # Necessary for Flow type checking
  ocaml \
  libelf-dev

RUN yarn config set cache-folder /root/.cache/yarn

# flowtype dependency
RUN apt-get install -y ocaml libelf-dev
