web: rm -f /app/tmp/pids/server.pid && bundle exec rails server -p3000 -b '0.0.0.0'
worker: bundle exec sidekiq -C ./config/sidekiq.yml -e ${RAILS_ENV:-development}
