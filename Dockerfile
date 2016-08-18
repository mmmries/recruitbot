FROM resin/rpi-raspbian:jessie-20160401
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
  && apt-get install -y --force-yes erlang-mini \
  && mkdir /opt/elixir \
  && curl -k -L https://github.com/elixir-lang/elixir/releases/download/v1.3.2/Precompiled.zip -o /opt/elixir/precompiled.zip \
  && cd /opt/elixir \
  && unzip precompiled.zip \
  && mix local.hex --force \
  && mix local.rebar --force \
  && rm -rf /var/lib/apt/lists/*
COPY . /app
WORKDIR /app
RUN mix hex.registry fetch && mix deps.get && mix compile
ENV PORT 80
CMD elixir --name "homebody@$RESIN_DEVICE_UUID.local" --cookie pi -S mix phoenix.server --no-halt --no-deps-check
