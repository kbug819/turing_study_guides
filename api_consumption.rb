### Consuming an API in Rails
### RAILS COMMANDS
rails db:{create, migrate}

#API KEY SETUP, saved in config *App must be closed to initiate, but terminal must be in correct folder. No other VS Code apps should be open
EDITOR="code --wait" rails credentials:edit

#*****CONFIG SETUP, will be saved and encrypted after close*****
propublica:
  key: asdsa3498serghjirteg978ertertwhter

# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base: ugsdfeadsfg98a7sd987asjkas98asd87asdkdwfdg876fgd
#********************* -- when connecting through services, use pry to verify key is set up @ Rails.application.credentials.probublica[:key]

# API SETUP IN CONNECTIONS #AS HEADER
def search
  conn = Faraday.new(url: "https://api.propublica.org") do |faraday|
    faraday.headers["X-API-KEY"] = Rails.application.credentials.propublica[:key]
  end
  response = conn.get("/congress/v1/116/senate/members.json")
  data = JSON.parse(response.body, symbolize_names: true)
end

# API SETUP IN CONNECTIONS #AS param
def find_park_by_state_code(state_code)
  get_url("/api/v1/parks?stateCode=#{state_code}&api_key=#{Rails.application.credentials.propublica[:key]}")
end

#File Structure
#FLOW
Spec < View < Controller < Facade < Services && POROS

#SERVICES - Ex.
#app/services/state_park_services.rb
class StateParksService

  def find_park_by_state_code(state_code)
    get_url("/api/v1/parks?stateCode=#{state_code}&api_key=MTbvoQMoYJIgdSgjaaFbAhmZmxKC6XaRBVissP5G")
  end
  
  def get_url(url)
    response = connection.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def connection
    Faraday.new(url: 'https://developer.nps.gov')
  end
end

#FACADES ****usually params are passed in through the argument*****
#app/facades/state_park_facade.rb
class StateParksFacade
  attr_reader :state
  def initialize(parks_info) 
    @state = parks_info[:state]
  end
  def parks_by_state_code
    StateParksService.new.find_park_by_state_code(@state)[:data].map do |park|
      Park.new(park)
    end
  end

  def parks_by_state_code_total
    StateParksService.new.find_park_by_state_code(@state)[:total]
  end
end

#POROS
#app/poros/park.rb
class Park
  attr_reader :name,
              :description,
              :direction_info,
              :standard_hours_monday,
              :standard_hours_tuesday,
              :standard_hours_wednesday
    
  def initialize(park_info)
    @name = park_info[:fullName]
    @description = park_info[:description]
    @direction_info = park_info[:directionsInfo]
    @standard_hours_monday = park_info[:operatingHours][0][:standardHours][:monday]
    @standard_hours_tuesday = park_info[:operatingHours][0][:standardHours][:tuesday]
    @standard_hours_wednesday = park_info[:operatingHours][0][:standardHours][:wednesday]
  end
end

#CONTROLLERS ****specific methods called in view****
class ParksController < ApplicationController
  def index
    @park_state = params[:state]
    @facade = StateParksFacade.new(params)
  end
end

