class CreateCostumers < ActiveRecord::Migration[6.0]
  def change
    create_table :costumers do |t|
      t.string :name
      t.string :address
      t.string :document
      t.string :email
      t.string :phone
      t.date :birth_date

      t.timestamps
    end
  end
end
