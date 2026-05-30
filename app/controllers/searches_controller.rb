class SearchesController < ApplicationController
  skip_after_action :verify_pundit_authorization

  def show
    @query = params[:query].to_s.strip

    return if @query.blank?

    multi_search = PgSearch.multisearch(@query).includes(:searchable)
    horses_query = multi_search.where(searchable_type: "Horses::Horse")
    stables_query = multi_search.where(searchable_type: "Account::Stable")
    @counts = {
      total: multi_search.count,
      horses: horses_query.count,
      stables: stables_query.count
    }

    @results = {
      horses: horses_query.limit(20),
      stables: stables_query.limit(10)
    }
    if @counts[:total] == 1
      matching_result = multi_search.first.searchable
      if matching_result.is_a? Horses::Horse
        redirect_to horse_path(matching_result) and return
      else
        redirect_to stable_path(matching_result) and return
      end
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end

