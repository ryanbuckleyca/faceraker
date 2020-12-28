puts "creating user..."
user = User.create!(name: "Ryan Buckley", email: "ryanbuckley@gmail.com")
puts "creating group..."
cession_de_bail = Group.create!(id: 263590541122539, name: "Cession de bail et sous-location Montréal")
puts "creating subscription..."
Subscription.create!(user: user, group: cession_de_bail)