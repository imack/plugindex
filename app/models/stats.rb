class Stats
  include Mongoid::Document
  include Mongoid::Timestamps


  field :hottest, type: Array, default: []
  field :top_weekly, type: Array, default: []
  field :newest, type: Array, default: []
  field :total, type: Array, default: []

  #has_and_belongs_to_many :plugins, inverse_of: nil, name: :hottest
  #has_and_belongs_to_many :plugins, inverse_of: nil, name: :top
  #has_and_belongs_to_many :plugins, inverse_of: nil, name: :new
  #has_and_belongs_to_many :plugins, inverse_of: nil, name: :total

end