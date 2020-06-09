YawdSale

Users can create YawdSale accounts, post up their own YawdSales (yardsales), find nearby Yawdsales based on the address in their profile, as well as search for YawdSales based on location data entered.

Demo: https://vimeo.com/322158667

Pre-requisites:

Ruby 2.4.0 or higher
Google Maps API key

Installation
1) Clone this repository and run $'bundle install' to get the required gems listed in the Gemfile.
2) User needs to create and paste Google Maps API key into apikey.txt file one folder up from the project folder (./../apikey.txt) This path can be changed in the config/environment.rb.
For more details on how to get a Google Maps API key, please visit: https://cloud.google.com/maps-platform/maps/.
3) Run $rake db:migrate to set up the database.
  For mock data:
  a) Adjust the data in the seed file:
    - update User data
    - update Yawdsale data
  b) Run $rake db:seed
4) Run shotgun to host the web app on your local machine
5) Open provided address in browser

Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/gitluky/yawdsale. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant code of conduct.

License
Available as open source under the terms of the MIT License.

Code of Conduct
Everyone interacting in the yawdsale project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the code of conduct.
