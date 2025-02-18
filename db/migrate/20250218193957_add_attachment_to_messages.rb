class AddAttachmentToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :attachment, :string
  end
end
