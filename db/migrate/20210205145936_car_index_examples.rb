class CarIndexExamples < ActiveRecord::Migration[6.0]
  # The way how the indexes are added doesn’t impact the performance once they are created;
  # however, it’s good to keep in mind that just simple CREATE INDEX will block concurrent writes
  # (inserts, updates, and deletes) until it’s finished.

  # It can lead to some issues, including deadlocks, especially when the index is getting created for
  # a huge table under massive write operations.

  # To prevent such a problem, it’s worth creating indexes concurrently instead. You can do that in Rails
  # using algorithm: :concurrently option and by making sure that the index creation will run outside of
  # a transaction by calling disable_ddl_transaction!.

  disable_ddl_transaction!

  def change
    # For queries like `Car.where("lower(name) like ?", "%#{name.downcase}%")`
    add_index :cars, 'lower(name) varchar_pattern_ops', name: "index_on_lowercase_name"

    add_column :cars, :score, :integer
    add_column :cars, :active, :boolean, null: false, default: true

    add_index :cars, :score, where: "active", order: { score: :desc }

    add_column :cars, :serial_number, :string
    add_column :cars, :serial_number_index_btree, :string
    add_column :cars, :serial_number_index_hash, :string

    add_index :cars, :serial_number_index_btree, algorithm: :concurrently, using: 'btree'
    add_index :cars, :serial_number_index_hash, algorithm: :concurrently, using: 'hash'
    # Safe on Postgres 10+, limited to only equality operators so you need to be looking for exact matches.
  end
end
