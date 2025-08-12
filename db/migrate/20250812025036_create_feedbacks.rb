class CreateFeedbacks < ActiveRecord::Migration[7.2]
  def change
    create_table :feedbacks do |t|
      t.string :email,    null: false
      t.string :category, null: false
      t.text   :message,  null: false
      t.string :status,   null: false, default: "open"

      t.timestamps
    end
  end
end
