class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings].nil? && params[:sort].nil? && (!session[:ratings].nil? || !session[:sort].nil?)
      flash.keep
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
      return
    end

    # Update session with the current params
    session[:ratings] = params[:ratings]
    session[:sort] = params[:sort]
    
    # Get all possible rating
    @all_ratings = Movie.all_ratings

    if params[:ratings].present?
      @ratings_to_show_hash = params[:ratings]
      @ratings_to_show = params[:ratings].keys
    else
      @ratings_to_show_hash = Hash[@all_ratings.map { |rating| [rating, "1"] }]
      @ratings_to_show = @all_ratings
    end

    @movies = Movie.with_ratings(@ratings_to_show)

    if params[:sort].present?
      @sort = params[:sort]
      @movies = @movies.order(@sort)
    end

    @title_header_class = 'hilite bg-warning' if @sort == 'title'
    @release_date_header_class = 'hilite bg-warning' if @sort == 'release_date'

  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

