FROM ruby:4.0.5-slim

ENV INSTALL_PATH /app
ENV PNPM_VERSION 11.0.8
ENV NODE_VERSION 25.1.0
SHELL ["/bin/bash", "-c"]

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    postgresql-client \
    tzdata \
    libgit2-dev \
    libvips \
    cmake \
    pkg-config \
    libssl-dev \
    libssh2-1-dev \
    libzstd-dev \
    libatomic1 \
    curl \
    libyaml-dev \
    git && \
    rm -rf /var/lib/apt/lists/*

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN curl -sL https://deb.nodesource.com/setup_25.x -o nodesource_setup.sh && bash nodesource_setup.sh && apt install -y nodejs
RUN npm install -g pnpm@${PNPM_VERSION}

RUN gem install bundler:2.7.1

COPY .ruby-version ./
COPY Gemfile Gemfile.lock ./
COPY package.json pnpm-lock.yaml ./

RUN bundle install

COPY . .
CMD ["bash", "-c", "bundle exec rails assets:precompile"]

EXPOSE 3000

CMD ["bash", "-c", "bin/rails db:migrate && rails server -b 0.0.0.0"]
