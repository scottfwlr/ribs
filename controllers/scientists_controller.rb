class ScientistsController < Controller 

  def index
    @scientists = Scientist.all
  end

  def show
    @scientist = Scientist.find(params[:id])
  end

end