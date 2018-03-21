class PapersController < Controller 

  def index
    @papers = Paper.all
  end 

  def show
    @paper = Paper.find(params[:id])
  end
end