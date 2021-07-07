class RemoveEvaluationToBooks < ActiveRecord::Migration[5.2]
  def change
    remove_column :books, :evaluation, :float
  end
end
