class Plugin
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :long_name, type: String
  field :percent_growth, type: Float
  field :weekly_download, type: Integer
  field :last_update, type: DateTime
  field :total_downloads, type: Integer

  field :dead, type: Boolean, default: false
  field :old, type: Boolean, default: false

  index ({ name:1 })

  embeds_many :readings

  validates :name, presence: true, uniqueness: true

  def display_name
    if self.long_name
      return long_name
    else
      return self.name
    end
  end

end