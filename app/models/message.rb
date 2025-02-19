class Message < ApplicationRecord
    belongs_to :sender, class_name: 'User'
    belongs_to :receiver, class_name: 'User'

    has_one_attached :attachment

    validate :content_or_attachment_must_be_present

    private

    def content_or_attachment_must_be_present
        if content.blank? && !attachment.attached?
        errors.add(:base, 'A mensagem deve ter um texto ou um anexo.')
        end
    end
end