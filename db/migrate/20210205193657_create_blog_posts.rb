class CreateBlogPosts < ActiveRecord::Migration[6.0]
  def up
    create_table :blog_posts do |t|
      t.string :title
      t.text :body
      t.column :search, 'tsvector'

      t.timestamps
      t.index 'search', using: :gin
      t.index 'lower(title)', unique: true
    end

    execute <<-SQL
      CREATE TRIGGER blog_posts_vector_update BEFORE INSERT OR UPDATE
      ON blog_posts 
      FOR EACH ROW EXECUTE PROCEDURE         
        tsvector_update_trigger("search", 'pg_catalog.english', title, body);
    SQL
  end

  def down
    execute 'DROP TRIGGER IF EXISTS blog_posts_vector_update ON blog_posts'
    drop_table :blog_posts
  end
end
