j = User.create(first_name: 'J', last_name: 'L', email_address: 'jl@gmail.com', password: 'asdf', street_address: "11 Piper Ln", city: "Levittown", state: "NY", zipcode: "11756")
w = User.create(first_name: 'W', last_name: 'L', email_address: 'wl@gmail.com', password: 'asdf', street_address: "15 Piper Ln", city: "Levittown", state: "NY", zipcode: "11756")
m = User.create(first_name: 'M', last_name: 'L', email_address: 'ml@gmail.com', password: 'asdf', street_address: "18 Piper Ln", city: "Levittown", state: "NY", zipcode: "11756")
a = User.create(first_name: 'A', last_name: 'L', email_address: 'al@gmail.com', password: 'asdf', street_address: "11 Forester Lane", city: "Levittown", state: "NY", zipcode: "11756")
h = User.create(first_name: 'H', last_name: 'L', email_address: 'hl@gmail.com', password: 'asdf', street_address: "95 Stratford North", city: "Roslyn Heights", state: "NY", zipcode: "11577")
h = User.create(first_name: 'HE', last_name: 'L', email_address: 'hel@gmail.com', password: 'asdf', street_address: "1 Shelter Rock Rd", city: "Roslyn", state: "NY", zipcode: "11576")

ys1 = h.yawdsales.create(title: "Old Stuff Yard Sale", description: "Old Stuff", street_address: "95 Stratford North", city: "Roslyn Heights", state: "NY", zipcode: "11577")
ys2 = h.yawdsales.create(title: "School Yard Sale", description: "School Stuff", street_address: "1 Shelter Rock Rd", city: "Roslyn", state: "NY", zipcode: "11577")
ys3 = j.yawdsales.create(title: "Tool Sale", description: "Tool Stuff", street_address: "11 Piper Ln", city: "Levittown", state: "NY", zipcode: "11756")
ys4 = a.yawdsales.create(title: "Dog Sale", description: "Dog Stuff", street_address: "11 Forester Lane", city: "Levittown", state: "NY", zipcode: "11756")