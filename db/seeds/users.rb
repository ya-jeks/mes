u = User.new email: 'admin@example.com',
             password: 'password',
             password_confirmation: 'password'
u.suppliers = Supplier.all
u.save!
