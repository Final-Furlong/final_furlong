class String
  def substrings(min_length = 1)
    ((min_length - 1)...length).each do |i|
      yield(self[0..i])
    end
  end

  def to_search_terms_arr(&block)
    clean_query = gsub(/[,:;]/, " ").gsub(/%/, '\%')
    terms_array = clean_query.split(/\s+/)
    if block
      terms_array = terms_array.filter_map do |term|
        yield(term) ? nil : term
      end
    end

    terms_array.map { |term| "%#{term}%".downcase }
  end

  def last_path_component
    split("/").last || ""
  end

  def remove_last_path_component
    array = split("/")
    array = array.take(array.length - 1) if array.length > 1
    array.join("/")
  end

  def normalized_last_path_component
    result = split("/").last || ""
    result.strip.downcase
  end

  def normalize_path
    strip&.sub(%r{^/*}, "/")&.remove_trailing_slash
  end

  def normalized_basename
    basename = remove_extension
    basename.present? ? basename.strip.downcase : nil
  end

  def normalized_extension
    match_data = /\.([\w-]+)$/.match(self)
    match_data.present? ? match_data[1].strip.downcase : nil
  end

  def remove_extension
    sub(/\.([\w-]*)$/, "")
  end

  def remove_extensions
    result = remove_extension

    result = result.remove_extension while result =~ /\.([\w-]*)$/

    result
  end

  def remove_numbers_and_symbols
    gsub(/[^a-zA-Z]/, "")
  end

  def remove_symbols
    gsub(/[\W_]/, "")
  end

  def remove_prefix_slash
    sub(%r{^[\s/]*}, "")
  end

  def remove_trailing_slash
    sub(%r{/*\s*$}, "")
  end

  def normalize_email
    strip.downcase
  end

  def normalize_email!
    strip!
    downcase!
  end

  def normalize
    strip.downcase
  end

  def into_search_terms
    split(/\s+/).map { |term| term.strip.downcase }
  end

  def mask_email
    account_name_length = rpartition("@").first.size
    tld = rpartition("@").last.rpartition(".").last
    domain_name_length = rpartition("@").last.rpartition(".").first.size

    "#{'*' * account_name_length}@#{'*' * domain_name_length}.#{tld}"
  end
end
