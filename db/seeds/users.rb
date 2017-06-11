u = User.new email: 'user@example.com',
             password: 'password',
             password_confirmation: 'password'
u.suppliers = Supplier.all
u.save!
