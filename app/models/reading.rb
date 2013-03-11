class Reading
  include Mongoid::Document
  include Mongoid::Timestamps

  field :downloads, type: Integer

  embedded_in :plugin

end