class Task
  module SupplierHelpers

    def subsuppliers_addresses
      tasks_suppliers.pluck(:address).uniq.join(', ')
    end

    def subsuppliers_codes
      tasks_suppliers.pluck(:code).uniq.join(', ')
    end

    def destination_address
      parents_suppliers.first.try(:address)
    end

    def destination_code
      parents_suppliers.first.try(:code)
    end

  end
end