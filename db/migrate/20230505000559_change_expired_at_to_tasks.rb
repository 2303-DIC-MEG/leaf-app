class ChangeExpiredAtToTasks < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :expired_at, :datetime, default: -> { 'now()' }, null: false
  end
end
