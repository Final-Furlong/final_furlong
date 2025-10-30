class PopulateBroodmareFoalRecordsService
  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    Horses::Horse.female.where.associated(:foals).where.missing(:broodmare_foal_record)
    query = Horses::Horse.female.where(id: "00020bd0-c34c-4c6a-9111-d31c4e5aaec9")
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

