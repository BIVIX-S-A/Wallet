class Account < ActiveRecord::Base
  belongs_to :user
  has_one :card
  has_many :source_transactions, class_name: 'Transaction', foreign_key: :source_account_id
  has_many :target_transactions, class_name: 'Transaction', foreign_key: :target_account_id
  has_many :movements, class_name: 'Movement', foreign_key: :account_id
  
  # -- Return all contacts saved by this account --
  has_many :owned_contacts_entries, class_name: 'Contact', foreign_key: :owner_account_id #return contacts 
  has_many :owned_contacts, through: :owned_contacts_entries, source: :contact_account
  
  # -- Return all accounts that have saved this account --
  has_many :entries_where_i_am_the_contact, class_name:  'Contact', foreign_key: :contact_account_id 
  has_many :accounts_that_saved_this, through: :entries_where_i_am_the_contact, source: :owner_account

  before_validation :generate_cvu_and_alias, on: :create

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
  validate :check_user_presence

  private
  def check_user_presence
    if user.nil?
      errors.add(:user, "can't be blank")
    end
  end
  
  def generate_cvu_and_alias
    loop do
      cvu_temporal = ""
      22.times do 
        digito = rand(0..9)
        cvu_temporal = cvu_temporal + digito.to_s
      end
      self.cvu = cvu_temporal
      break unless Account.exists?(cvu: self.cvu)
    end

    words = ["sol","luna","casa","golpear","hijos","penales","fallo","crear","pico","pase","diamante","diente","registro","german","terno","dado","problema","vivo","linea","puerto","comportamiento"]
    loop do
      words_selected = []
      3.times do
        random_word = words.sample
        words_selected.push(random_word)
      end
      self.alias = words_selected.join('.')
      break unless Account.exists?(alias: self.alias)
    end
  end
end
