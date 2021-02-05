# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

BlogPost.find_or_create_by(title: 'Postgres is very cool')
BlogPost.find_or_create_by(title: 'MySQL Transactions is fake')
BlogPost.find_or_create_by(title: 'How much Postgres is different from MySQL')
BlogPost.find_or_create_by(title: 'All warning outputs from MySQL')
BlogPost.find_or_create_by(title: 'This is only a secret post!', body: 'Postgres is awesome')
BlogPost.find_or_create_by(title: 'wat?', body: 'But MySQL is not so much :/')