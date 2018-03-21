class InstitutesController < Controller 

  def index
    @institutes = Institute.all
  end

  def show
    @institute = Institute.find(params[:id])
  end
  
end