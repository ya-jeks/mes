class Task
  module SupplierHelpers

    def subsuppliers_addresses
      tasks_suppliers.pluck('distinct address')
    end

    def subsuppliers_codes
      tasks_suppliers.pluck('distinct code')
    end

    def subsuppliers_ids
      tasks_suppliers.pluck('distinct id')
    end

    def destination_address
      parents_suppliers.first.try(:address)
    end

    def destination_code
      parents_suppliers.first.try(:code)
    end

    def destination_id
      parents_suppliers.first.try(:id)
    end

  end
end
