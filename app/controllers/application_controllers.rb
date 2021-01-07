require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	get "/" do
		erb :index
	end

	get "/signup" do
		erb :signup
	end

	post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password])

		if user.save
			redirect "/login"
		else
			redirect "/failure"
		end
	end

	get "/login" do
		erb :login
	end

	post "/login" do
		user = User.find_by(:username => params[:username])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect "/decks"
		else 
			redirect "failure"
		end
    end
    
    #decks

	get "/decks" do
		if logged_in?
			erb :decks
		else
			redirect "/login"
		end
    end
    
    get '/decks/:id/' do #loads deck show page
        @deck = Deck.find_by_id(params[:id])
        erb :show
    end

    get '/decks/:id/edit' do #loads edit form
        @deck = Deck.find_by_id(params[:id])
        erb :edit
    end

    patch '/decks/:id' do  #updates a deck
        @deck = Deck.find_by_id(params[:id])
        @deck.name = params[:name]
        @deck.cards = params[:cards]
        @deck.save
        redirect to "/decks/#{@deck.id}"
    end

    post '/decks' do  #creates a deck
        @deck = Deck.create(params)
        redirect to "/decks/#{@deck.id}"
    end

    delete '/decks/:id' do #destroy action
        @deck = Deck.find_by_id(params[:id])
        @deck.delete
        redirect to '/decks'
    end


	get "/failure" do
		erb :failure
	end

	get "/logout" do
		session.clear
		redirect "/"
    end
    

    #cards
    get '/card/new' do
        erb :new_card
    end
    
    get '/card' do
        @card = Card.all 
        erb :show_card
    end
    
    get '/card/:id' do  #loads show page
        @card = Card.find_by_id(params[:id])
        erb :show_card
    end
    
    get '/card/:id/edit' do #loads edit form for cards
        @card = Card.find_by_id(params[:id])
        erb :edit_card
    end
    
    patch '/card/:id' do  #updates a card
      @card = Card.find_by_id(params[:id])
      @card.name = params[:name]
      @card.save
      redirect to "/card/#{@card.id}"
    end
    
    post '/card' do  #creates a card
      @card = Card.create(params)
      redirect to "/card/#{@card.id}"
    end
    
    delete '/card/:id' do #destroy action
      @card = Card.find_by_id(params[:id])
      @card.delete
      redirect to '/recipes'
    end
    

	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end
end
