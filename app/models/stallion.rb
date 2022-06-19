# typed: false

class Stallion < Horse
  has_many :foals, class_name: "Horse", foreign_key: "sire_id",
                   inverse_of: :sire, dependent: :restrict_with_exception

  enum status: {
    stallion: "stallion", retired: "retired",
    retired_stallion: "retired_stallion", deceased: "deceased"
  }
  enum gender: { stallion: "stallion", gelding: "gelding" }
end
