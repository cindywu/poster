class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :munged_title
      t.text :description
      t.timestamps
    end
  end
end