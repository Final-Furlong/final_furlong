class Racing::TrackTypePreferenceCalculator
  attr_reader :track_type, :dirt, :turf, :steeplechase

  def initialize(track_type:, dirt:, turf:, steeplechase:)
    @track_type = track_type
    @dirt = dirt
    @turf = turf
    @steeplechase = steeplechase
  end

  def call
    value = send(track_type.to_s.downcase)

    (100 - (5 - value)).fdiv(100)
  end
end

