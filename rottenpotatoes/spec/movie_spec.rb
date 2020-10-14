require 'rails_helper.rb'

describe MoviesController, :type => :controller do
    describe 'Finding movies with identical director' do
        it 'call the model method which finds movies with identical director' do
            expect(Movie).to receive(:find_similar_movies).with('1')
            #Movie.should_receive(:find_similar_movies).with("1")
            get :director, {:id => '1'}
        end
        it 'selects the find similar movies template for rendering' do
            @movies = [double('Movie'), double('Movie')]
            Movie.stub(:find_similar_movies).and_return(@movies)
            get :director, {:id => '1'}
            expect(response).to render_template(:director)
        end
        it 'creates find similar movies available to template' do
            @movies = [double('Movie'), double('Movie')]
            @movie = double('Movie')
            Movie.stub(:find_similar_movies).and_return([@movies,0,@movie])
            get :director, {:id => '1'}
            assigns(:movie).should == @movie
            assigns(:movies).should == @movies
        end
        it 'creates find similar movies available to sad path template' do
            @movie = double('Movie', :title => 'MovieRandom')
            Movie.stub(:find_similar_movies).and_return([nil,1,@movie])
            get :director, {:id => '1'}
            expect(response).to redirect_to movies_path
            flash[:notice].should eq("'#{@movie.title}' has no director info.")
        end
    end
    describe "Sorting movies based on tile and release date" do
        it "sort based on movie title" do 
            get :index, sort: "title"
            expect(response.body).to include "title"
        end
        it "sort based on release date" do 
            get :index, sort: "release_date"
            expect(response.body).to include "release_date"
        end 
    end
    describe "Sorting movies based on rating" do
        it "sort movies based on rating" do 
            @ratings={"G"=>"1", "NC-17"=>"1", "R"=>"1"}
            get :index, ratings: @ratings
            expect(response.body).to include "ratings"
            expect(response.body).to include "G"
            expect(response.body).to include "R"
            expect(response.body).to include "NC-17"
        end
    end
    describe "update" do
        it "update existing movie to add director" do
            @id = "1"
            @movie = double('null movie').as_null_object
            @defaults = {title: "abc", rating: "PG", director: "Bond"}
            expect(Movie).to receive(:find).with(@id).and_return(@movie)

            put :update, id: @id, movie: @defaults
            expect(flash[:notice]).to match(/was successfully updated./)
            expect(response).to redirect_to(movie_path(@movie))
        end
    end

    describe "create" do
        it "create movie " do
            @movie = {title: "Love", rating: "PG"}
            post :create, movie: @movie
            expect(flash[:notice]).to eq("Love was successfully created.")
            expect(response).to redirect_to(movies_path)
        end
    end

    describe "show" do
        it "show movie details" do
            @movie = double('Movie')
            expect(Movie).to receive(:find).and_return(@movie)
            get :show, {:id => '1'}
            expect(response).to render_template(:show)
        end
    end

    describe "destroy" do
        it "delete a movie" do
            @id='1'
            @movie = double('null movie').as_null_object
            expect(Movie).to receive(:find).with(@id).and_return(@movie)
            delete :destroy, {:id => @id}
            expect(flash[:notice]).to match(/Movie || deleted./)
            expect(response).to redirect_to(movies_path)
        end
    end

    describe "edit" do
        it "edit a movie" do
            @movie = double('Movie')
            expect(Movie).to receive(:find).and_return(@movie)
            get :edit, {:id => '1'}
            expect(response).to render_template(:edit)
        end
    end

    describe "new" do
        it "render new template" do
            get :new 
            expect(response).to render_template(:new)
        end
    end
end 