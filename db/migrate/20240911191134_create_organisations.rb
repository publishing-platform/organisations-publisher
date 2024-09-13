class CreateOrganisations < ActiveRecord::Migration[7.2]
  def change
    create_table :organisations do |t|
      t.uuid :content_id
      t.string :name
      t.string :slug
      t.string :status
      t.string :abbreviation
      t.string :organisation_type_key

      t.timestamps

      t.index :content_id, unique: true
      t.index :slug, unique: true
      t.index :organisation_type_key
      t.index :name, unique: true
    end
  end
end
