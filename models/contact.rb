class Contact < ActiveRecord::Base
  # Validations
  validates :owner_account_id, presence: true
  validates :contact_account_id, presence: true

  validate :owner_is_not_contact
  # Associations
  belongs_to :owner_account, class_name: 'Account'
  belongs_to :contact_account, class_name: 'Account'
  
  # Custom validation method
  def owner_is_not_contact
    if owner_account_id.present? && contact_account_id.present?
      if owner_account_id == contact_account_id
        errors.add(:contact_account_id, "You cannot add yourself to your contacts")
      end
    end
  end
end
