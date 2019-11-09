FROM buildpack-deps:jessie

ENV RUBY_MAJOR 2.3
ENV RUBY_VERSION 2.3.8
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES=true

RUN apt-get update \
	&& apt-get install -y --force-yes nodejs bison curl vim ruby procps build-essential libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /usr/src/ruby \
	&& curl -SL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
		| tar -xjC /usr/src/ruby --strip-components=1 \
	&& cd /usr/src/ruby \
	&& autoconf \
	&& ./configure --disable-install-doc \
	&& make \
	&& apt-get autoremove -y --force-yes \
	&& make install \
	&& rm -r /usr/src/ruby

ADD . /mes
WORKDIR /mes

RUN gem install bundler --version=1.3.0
RUN [ -e /mes/Gemfile ] && bundle install
RUN rake db:migrate db:seed || true
RUN rake assets:precompile || true
CMD rails s