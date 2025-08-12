# db/migrate/20250812045157_add_fields_to_feedbacks.rb
class AddFieldsToFeedbacks < ActiveRecord::Migration[7.1]
  def up
    # EMAIL
    if !column_exists?(:feedbacks, :email)
      add_column :feedbacks, :email, :string, null: false
    else
      change_column_null :feedbacks, :email, false
    end

    # CATEGORY
    if !column_exists?(:feedbacks, :category)
      add_column :feedbacks, :category, :string, null: false
    else
      change_column_null :feedbacks, :category, false
    end

    # MESSAGE
    if !column_exists?(:feedbacks, :message)
      add_column :feedbacks, :message, :text, null: false
    else
      change_column_null :feedbacks, :message, false
    end

    # OPTIONAL indexes (skip if you don't want them)
    # add_index :feedbacks, :email   unless index_exists?(:feedbacks, :email)
    # add_index :feedbacks, :status  unless index_exists?(:feedbacks, :status)
  end

  def down
    # Remove indexes first if you added them
    # remove_index :feedbacks, :email  if index_exists?(:feedbacks, :email)
    # remove_index :feedbacks, :status if index_exists?(:feedbacks, :status)

    remove_column :feedbacks, :message  if column_exists?(:feedbacks, :message)
    remove_column :feedbacks, :category if column_exists?(:feedbacks, :category)
    remove_column :feedbacks, :email    if column_exists?(:feedbacks, :email)
  end
end
