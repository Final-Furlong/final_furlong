class PopulateBroodmareFoalRecordsService
  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    query = Horses::Horse.female.where.associated(:foals).where.missing(:broodmare_foal_record)
    query.find_each(cursor: [:id], order: [:asc]) do |horse|
      next unless horse.female?

      result = Horses::BroodmareFoalRecordCreator.new.create_record(horse)
      raise "Could not handle horse #{horse.id}, error: #{result.error}" unless result.created?
    end
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end
end

