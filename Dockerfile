FROM ruby:3.1.3

RUN apt-get update && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    postgresql-client

#RUN useradd -u 1000 -m postgres


#RUN echo "postgres:x:9999:9999:PostgreSQL User:/var/lib/postgresql:/bin/bash" >> /etc/passwd
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler

RUN bundle install

COPY . .

EXPOSE 9292

# Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/env
RUN chmod +x /usr/bin/env
ENTRYPOINT ["docker-entrypoint.sh"]

USER postgres

CMD ["ruby", "app.rb"]
