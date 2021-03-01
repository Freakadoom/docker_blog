        
FROM ruby:2.5.1
ENV LANG C.UTF-8

RUN groupadd --gid 1000 app \
    && useradd --home-dir /home/app --create-home --uid 1000 \
        --gid 1000 --shell /bin/sh --skel /dev/null app

RUN apt-get update && \
    apt-get install -y nodejs \
                       vim \
                       default-mysql-client \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /docker_blog
COPY Gemfile /docker_blog/Gemfile
COPY Gemfile.lock /docker_blog/Gemfile.lock
RUN bundle install
COPY . /docker_blog


# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]


EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

