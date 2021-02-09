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
- https://www.citusdata.com/blog/2017/10/17/tour-of-postgres-index-types/
- https://karolgalanciak.com/blog/2018/08/19/indexes-on-rails-how-to-make-the-most-of-your-postgres-database/
- https://medium.com/better-programming/how-to-use-sidekiq-in-rails-6-f3b76678362d
- https://bigbinary.com/blog/rails-5-adds-support-for-expression-indexes-for-postgresql
- https://medium.com/captain-contrat-engineering/how-to-execute-arel-queries-431639047e91

## Videos

[Guru-SP 39: Porque usar PostgreSQL por Nando Vieira](https://www.youtube.com/watch?v=VWtvJsjpOjY)
[Dicas e truques com PostgreSQL por Nando Vieira - DevInSantos 2015](https://www.youtube.com/watch?v=unFnLc9f3dg)
[Postgres The Bits You Haven’t Found, Heroku’s Peter van Hardenberg at Waza 2013](https://vimeo.com/61044807)
