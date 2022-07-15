class Array
  def in_groups_alternately(groups_count)
    result = []

    (1..groups_count).each do |group_no|
      result << each_with_index.filter_map { |value, i| i % groups_count == group_no - 1 ? value : nil }
    end

    result
  end
end
