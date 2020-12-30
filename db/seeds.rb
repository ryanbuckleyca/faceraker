puts "creating user..."
user = User.create!(name: "Ryan Buckley", email: "ryanbuckley@gmail.com", address: "4107 Boul. St. Laurent, Montreal QC, H2L1Y7")
puts "creating group..."
cession_de_bail = Group.create!(id: 263590541122539, name: "Cession de bail et sous-location Montréal")
puts "creating subscription..."
Subscription.create!(user: user, group: cession_de_bail)
