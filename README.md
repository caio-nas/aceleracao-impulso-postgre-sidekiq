# Aceleração Global Dev #5 Impulso
### Subject: Advanced integrations for Ruby On Rails, PostgreSQL and Sidekiq


## Hosts

- Lucas Santos - https://github.com/lsantosc - https://www.linkedin.com/in/lsantosc/
- Caio Nascimento - https://github.com/caio-nas - https://www.linkedin.com/in/caiomvnascimento/

## Table of contents

### insert_all/upsert_all
New Rails 6 methods for bulk operations

- spec/database/insert_all_spec.rb
- spec/database/upsert_all_spec.rb

## How to run profiler tests

```
RAILS_ENV=test bundle exec rspec -fd --profile

# Docker setup is available for your convenience <3
docker-compose run web RAILS_ENV=test bundle exec rspec -fd --profile
```

## References
- https://bigbinary.com/blog/bulk-insert-support-in-rails-6
