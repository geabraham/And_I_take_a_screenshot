class MedidationsController < ApplicationController

  before_filter :populate_job_titles, except: [:show, :destroy]
  before_filter :get_medidation, only: [:update, :edit, :show]

  # Render a list of medidations
  def index
    # TODO: treat the responses below as paginated.
    @medidations = Medidation.get(:all)
  end

  # Displays medidation
  def show
     respond_with(@medidation)
  end

  # Render page used to create a new medidation.
  def new
    @medidation = Medidation.new
  end

  # Create a new medidation
  def create
    @medidation = Medidation.post(params[:medidation])

    respond_with(@medidation) do |format|
      if @medidation.errors.empty?
        format.html { redirect_to @medidation, notice: 'Medidation was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # Update an existing medidation
  def update
    @medidation.put(params[:medidation])
    respond_with(@medidation) do |format|
      if @medidation.errors.empty?
        format.html { redirect_to medidation_path, notice: 'Medidation was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # Delete a medidation
  def destroy
    @medidation = Medidation.delete(params[:id])

    respond_with(@medidation) do |format|
      format.html { redirect_to medidations_path }
    end
  end

  protected
  # Fetch Jobtitles
  def populate_job_titles
    # TODO: treat the responses below as paginated.
    @job_titles = JobTitle.get(:all)
  end

  # Get a medidation using uuid
  # params[:id] provides the uuid to get the medidation
  def get_medidation
    @medidation = Medidation.get(params[:id])
  end

end
