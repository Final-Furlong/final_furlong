module Api
  module V1
    class Base < Grape::API
      mount Api::V1::Activations
      mount Api::V1::AuctionBids
      mount Api::V1::AuctionHorses
      mount Api::V1::Budgets
      mount Api::V1::LegacyHorses
    end
  end
end

