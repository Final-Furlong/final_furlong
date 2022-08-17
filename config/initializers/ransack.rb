Ransack.configure do |c|
  c.custom_arrows = {
    default_arrow: '<i class="fas fa-sort-alt"></i>'
  }

  c.add_predicate "dategteq", arel_predicate: "gteq", formatter: proc { |v| v.beginning_of_day }, type: :date
  c.add_predicate "datelteq", arel_predicate: "lteq", formatter: proc { |v| v.end_of_day }, type: :date
end

