class Reading
  include Mongoid::Document
  include Mongoid::Timestamps

  field :downloads, type: Integer
  field :percent_change, type:Float

  embedded_in :plugin

end