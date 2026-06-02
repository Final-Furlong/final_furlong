module Horse
  class CommentsController < AuthenticatedController
    def index
      @horse = Horses::Horse.find(params[:horse_id])
      base_query = (@horse.manager_id == Current.stable.id) ? @horse.comments.visible_by_owner : @horse.comments.visible_by_all
      @query = policy_scope(base_query)
      @pagy, @comments = pagy(:countless, @query)
    end

    def new
      @horse = Horses::Horse.find(params[:horse_id])
      @comment = @horse.comments.build
      authorize @comment
    end

    def edit
      @horse = Horses::Horse.find(params[:horse_id])
      @comment = @horse.comments.find(params[:id])
      authorize @comment
    end

    def create
      @horse = Horses::Horse.find(params[:horse_id])
      @comment = @horse.comments.build
      authorize @comment

      if @comment.update(comment_params.merge(stable: Current.stable))
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("comment-form", partial: "horse/comments/form", locals: { horse: @horse, comment: @comment, url: horse_comments_path(@horse) })
          end
        end
      end
    end

    def update
      @horse = Horses::Horse.find(params[:horse_id])
      @comment = @horse.comments.find(params[:id])
      authorize @comment

      if @comment.update(comment_params.merge(stable: Current.stable))
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        respond_to do |format|
          format.html { render :edit, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("comment-form", partial: "horse/comments/form", locals: { horse: @horse, comment: @comment, url: horse_comment_path(@horse, @comment) })
          end
        end
      end
    end

    def destroy
      @horse = Horses::Horse.find(params[:horse_id])
      @comment = @horse.comments.find(params[:id])
      authorize @comment

      if @comment.destroy
        flash[:success] = t(".success")
      else
        flash[:alert] = t(".failure")
      end
      redirect_to horse_path(@horse)
    end

    private

    def comment_params
      params.expect(horses_comment: [:title, :comment, :private])
    end
  end
end

