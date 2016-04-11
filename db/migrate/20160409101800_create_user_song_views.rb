class CreateUserSongViews < ActiveRecord::Migration
  def change
    create_table :user_song_views do |t|
      t.belongs_to :song, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.integer :view_cnt

      t.timestamps null: false
    end
  end
end
