FROM resin/rpi-raspbian:wheezy-20161221
ENV PATH /opt/elixir/bin:$PATH
ENV LANG C.UTF-8
ENV MIX_ENV prod
RUN apt-get update && apt-get install -y \
    tree \
    curl \
    unzip \
    git \
    ca-certificates \
    build-essential \
  && echo "deb http://packages.erlang-solutions.com/debian wheezy contrib" >> /etc/apt/sources.list \
  && curl 'http://packages.erlang-solutions.com/debian/erlang_solutions.asc' -o 'esolutions.asc' \
  && apt-key add esolutions.asc \
  && rm esolutions.asc \
  && apt-get update \
  && apt-cache search erlang \
  && apt-get install -y --force-yes erlang \
  && rm -rf /var/lib/apt/lists/*
RUN  mkdir /opt/elixir \
  && curl -k -L https://github.com/elixir-lang/elixir/releases/download/v1.3.4/Precompiled.zip -o /opt/elixir/precompiled.zip \
  && cd /opt/elixir \
  && unzip precompiled.zip \
  && mix local.hex --force \
  && mix local.rebar --force
WORKDIR /app
ENV PORT 80
ADD mix.* /app/
RUN mix deps.get && mix deps.compile
ADD . /app
RUN mix compile && mix phoenix.digest
CMD elixir --name "recruitbot@$RESIN_DEVICE_UUID.local" --cookie pi -S mix phoenix.server --no-halt --no-deps-check
