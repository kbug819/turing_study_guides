### Setting up a Ruby App in Rails

# 1. Create a Rails app
rails new ____________ -T -d="postgresql"   #fill in title in the ____

# 2. Setup Gemfile
group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "pry"  # --- Adding pry to the gemfile
end

#2b - Shoulda-matchers - put at the bottom of rails_helper.rb
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

#3. Rails setup
rails db:create #Creates a database for the Rails App

#STARTING COMMANDS
bundle install
bundle update
rails db:{drop,create,migrate,seed}


#MIGRATIONS
rails generate migration CreateTask title:string description:string  # - creating a new table
rails g migration AddArtistsToSongs artist:references #Creates relationship between one table and another
rails g migration CreatePlaylistSongs song:references playlist:references #- Creates table joined to two different references
rails g migration add_description_to_bachelorette description:string #- Adds a column to an existing table
rails db:migrate

# Model Setup - SINGULAR
class Applicant < ApplicationRecord
  validates :name, presence: true  #VALIDATIONS
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true
  validates :description, presence: true
  has_many :pets_applications
  has_many :pets, through: :pets_applications
  
end

# Relationships - ONE TO MANY.
class Bachelorette < ApplicationRecord
  has_many :contestants
end
class Contestant < ApplicationRecord
  belongs_to :bachelorette
end
# _TESTING
require "rails_helper"
RSpec.describe Bachelorette, type: :model do
  describe "relationships" do
    it {should have_many :contestants}
  end
end
RSpec.describe Contestant, type: :model do
  describe "relationships" do
    it {should belong_to :bachelorette}
  end
end

# VALIDATIONS - MANY TO MANY
class ContestantsOuting < ApplicationRecord
  belongs_to :outing
  belongs_to :contestant
end
class Outing < ApplicationRecord
  has_many :contestants_outings
  has_many :contestants, through: :contestants_outings
end
class Contestant < ApplicationRecord
  has_many :contestants_outings
  has_many :outings, through: :contestants_outings
end

#_TESTING
RSpec.describe ContestantsOuting, type: :model do
  describe "relationships" do
    it {should belong_to :outing}
    it {should belong_to :contestant}
  end
end
RSpec.describe Contestant, type: :model do
  describe "relationships" do
    it {should have_many :contestants_outings}
    it {should have_many(:outings).through(:contestants_outings) }
  end
end
RSpec.describe Outing, type: :model do
  describe "relationships" do
    it {should have_many :contestants_outings}
    it {should have_many(:contestants).through(:contestants_outings) }
  end
end

#FILE STRUCTURE
app/controllers/bachelorettes
app/models/contestant.rb
app/views/bachelorettes/show.html.erb
spec/features/bachelorett/show_spec.rb

#TEST SETUP
#_FEATURE
require "rails_helper"
RSpec.describe "the department index" do
  it "shows a list of departments, floors and associated employees" do
    department_1 = Department.create(name: "IT", floor: "Basement")
    department_2 = Department.create(name: "English", floor: "Floor 2")
# EXAMPLE TEST LINES
    within(".bachelorette_info") do
      expect(page).to have_content("Bachelorette: Katie")
      expect(page).to have_content("#{bachelorette.season_number} - #{bachelorette.description}")
      expect(page).to have_content("Bachelorette: Katie")
    end
    within(".contestats") do
      expect(page).to have_link("Contestants")
      click_link("Contestants")
      expect(page).to have_current_path("/bachelorettes/#{bachelorette.id}/contestants")
    end
# OTHERS
    fill_in "new_ticket_id", with: "#{ticket_5.id}"
    click_button "Save" 
  end
end

#Route Setups - HANDROLLED
  get "/", to: "welcome#index"
  get "/tasks/new", to: "tasks#new"
  post "/tasks", to: "tasks#create"  
  get "/tasks/:id", to: "tasks#show"
  get '/tasks/:id/edit', to: 'tasks#edit'
  patch '/tasks/:id', to: 'tasks#update'
  delete '/tasks/:id', to: 'tasks#destroy'

#_Advanced Routing
resources :bachelorettes, only: [] do #-creates all default routes for bachelorettes
  resources :contestants, controller: "bachelorettes/contestants" #pus contestant routes within bachelorette
end

  #5. Controller Setup - PLURAL
  class TasksController < ApplicationController
    # OR
  class Bachelorettes::ContestantsController < ApplicationController
  end
    def index
      @tasks = ["Task 1", "Task 2", "Task 3"]
    end
  def show
    @bachelorette = Bachelorette.find(params[:id])
  end
  def destroy
    Task.destroy(params[:id])
    redirect_to '/tasks'
  end
  def self.retrieve_applicant(application_id)
    Applicant.find(PetsApplication.find(application_id).applicant_id)
  end
  
  #6. View Setup  --- app/views/tasks/index.html.erb  -- PLURAL
  <h1>Welcome to the Task Manager</h1>
  
  <div class= "list">
  <ul>
  <li><a href="/tasks">Task Index</a></li>
  <li><a href="/tasks/new">New Task</a></li>
  </ul>

  <%= link_to "#{item.name}", merchant_item_path(@merchant, item), method: :get %>
  
  <% @invoice.invoice_items.each do |invoice_item| %>
      <%= invoice_item.item.name %>
  <% end %>
            
#FORMS
#_ADDING AN EXISTING ID
<section class="add_ride">
<h3>Add a ride to workload: </h3>
<%= form_with url: "/mechanics/#{@mechanic.id}", method: :post, local: true do |f| %>
  <%= f.label :new_ride_id %>
  <%= f.text_field :new_ride_id %>
  <%= f.submit %>
<% end %>
</section
  
  
  #8. Other commands
  rails dbconsole  #use to work through active record and SQL


#11. Seeds
Song.destroy_all
Artist.destroy_all

prince = Artist.create!(name: 'Prince')
rtj = Artist.create!(name: 'Run The Jewels')
caamp = Artist.create!(name: 'Caamp')
jgb = Artist.create!(name: 'Jerry Garcia Band')
billie = Artist.create!(name: 'Billie Eilish')
lcd = Artist.create!(name: 'LCD Soundsystem')

prince.songs.create!(title: 'Raspberry Beret', length: 345, play_count: 34)
prince.songs.create!(title: 'Purple Rain', length: 524, play_count: 19)
