module Dashboard
  module Horse
    class Sales
      attr_reader :horse, :events

      def initialize(horse:)
        @horse = horse
        @events = []
        load_sales
        load_leases
        load_current_lease
        @events = @sales + @leases + @current_lease
        @events.sort_by! { |hash| hash[:date] || hash[:start_date] }
      end

      private

      def load_sales
        @sales ||= horse.sales.joins(:seller, :buyer).select(
          "stables.name AS seller_name, buyers_horse_sales.name AS buyer_name, horse_sales.date, horse_sales.private, horse_sales.price"
        ).order(date: :asc).map do |sales_data|
          {
            old_stable: sales_data[:seller_name],
            new_stable: sales_data[:buyer_name],
            date: sales_data[:date],
            private: sales_data[:private],
            price: sales_data[:price]
          }
        end
      end

      def load_leases
        @leases ||= horse.past_leases.joins(:owner, :leaser).select(
          "stables.name AS leaser_name, leasers_leases.name AS leasee_name,
leases.start_date, GREATEST(leases.end_date, leases.early_termination_date)
AS end_date, leases.fee"
        ).order(start_date: :asc).map do |lease_data|
          {
            old_stable: lease_data[:leaser_name],
            new_stable: lease_data[:leasee_name],
            start_date: lease_data[:start_date],
            end_date: lease_data[:end_date],
            price: lease_data[:fee]
          }
        end
      end

      def load_current_lease
        return @current_lease if @current_lease

        lease = @horse.current_lease
        lease_info = lease ? {
          old_stable: horse.owner.name,
          new_stable: lease.leaser.name,
          start_date: lease.start_date,
          end_date: lease.end_date,
          price: lease.fee
        } : {}
        @current_lease = lease_info.blank? ? [] : [lease_info]
      end
    end
  end
end

