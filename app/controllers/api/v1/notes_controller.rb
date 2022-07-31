class Api::V1::NotesController < ActionController::API
  acts_as_token_authentication_handler_for User, only: [:index, :show]

  def create
    @note = Note.new note_params
    @note.user = current_user
    @note.save
    render json: { note: @note, create: "success",  }, status: 200
  end


  private

  def note_params
    params.require(:note).permit(:title)
  end
end