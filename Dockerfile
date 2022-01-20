FROM ruby:3.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN gem install rails

ADD . /inv-mngr
WORKDIR /inv-mngr
RUN bundle install

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["bash"]
