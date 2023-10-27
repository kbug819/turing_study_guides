### Shoulda matchers
#Shoulda Matchers --- Install
#Shoulda Matchers --- rails_helper.rb - at bottom of the page
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

#Shoulda Matchers --- tests lines
visit "/users/#{@user_1.id}/movies/238/viewing_parties/new"

expect(page.status_code).to eq 200
expect(current_path).to eq("/users/#{@user_1.id}/discover")
expect(page).to have_button('Discover Top Rated Movies')

#Shoulda Matchers --- Filling in forms:
select 'Tennessee', from: 'state'
click_on 'Find Parks'
expect(current_path).to eq('/parks')

fill_in :search, with: 'Sanders'
click_button 'Search'
fill_in 'duration', with: 180
fill_in 'date', with: '2023-11-16'
fill_in 'start_time', with: '07:00:00'
check @user_2.id.to_s
expect(page).to have_checked_field(@user_2.id.to_s)
expect(page).to have_unchecked_field(@user_3.id.to_s)

###Webmock
#Webmock --- install
gem install Webmock

test: do
  gem "webmock"
end

#Webmock ---spec_helper
require 'webmock/rspec'

# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
end

###VCR
#VCR --- install
test: do
  gem "vcr"
end

#VCR --- rails_helper - at bottom
VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = { re_record_interval: 1.days }
end

#VCR --- in tests
VCR.use_cassette("propublica_members_of_the_senate_for_CO") do
end
