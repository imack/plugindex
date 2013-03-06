class Plugin
  include Mongoid::Document

  field :name, type: String
  field :past_week, type: Float
  field :past_month, type: Float
  field :last_update, type: DateTime
  field :total_downloads, type: Integer

  field :dead, type: Boolean, default: false
  field :old, type: Boolean, default: false

  index ({ name:1 })

  embeds_many :readings

  validates :name, presence: true, uniqueness: true

end