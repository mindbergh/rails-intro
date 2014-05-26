class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger

    if params == nil or (!params.keys.include?('ratings') and !params.keys.include?('order'))
      flash.keep
      flash[:notice] = "redirect_to1  from " + "#{params}"
      session[:ratings] = {"PG"=>"1", "PG-13"=>"1", "G"=>"1", "R"=>"1"}
      session[:order] = 'title'
      redirect_to movies_path(:order => 'title', :ratings => {"PG"=>"1", "PG-13"=>"1", "G"=>"1", "R"=>"1"}), id:'title_header' 
      return
    end



    if params[:ratings] == nil or params[:ratings].length == 0
      #params = session[:params]       
      #flash.keep
      #flash[:notice] = "redirect_to2"
      #redirect_to movies_path(session[:params]), id:'title_header' 
      params[:ratings] = session[:params][:ratings]
    else
      session[:params][:ratings] = params[:ratings]
    end
      #@a = params[:ratings].keys.length
      #flash[:notice] = "#{@a} was successfully created."
      

    

    

    case params[:order] 
    when 'title'
      @htitle = 'hilite'
      @hdate = ''
    when 'release_date'
      @htitle = ''
      @hdate = 'hilite'
    end
    @checked = params[:ratings].keys    
    @all_ratings = Movie.select('rating').all.map { |e| e[:rating] }.uniq.sort
    @movies = Movie.where(rating: @checked).order(params[:order]).all    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
