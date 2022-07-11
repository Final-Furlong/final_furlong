class StablesController < AuthenticatedController
  # @route GET /stable (stable)
  def show
    authorize current_stable
  end
end
