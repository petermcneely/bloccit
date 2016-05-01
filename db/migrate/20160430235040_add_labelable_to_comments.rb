class AddLabelableToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :labelable, polymorphic: true, index: true
  end
end
