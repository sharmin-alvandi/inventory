class Warehouse
  attr_accessor :w_id, :w_location, :w_products
  def initialize(w_id, w_location, w_products)
     @w_id = w_id
     @w_location = w_location
     @w_products = w_products
    
  end
  def add_warehouse(warehouse)
    $warehouses.push(warehouse)
    # puts $warehouses
  end
  def self.show_warehouses
    $warehouses.each { |warehouse| 
      puts " "
      warehouse.each { |key, value|
      print "#{key}: #{value},  "
    }
  }
  end

  # Returns a hash of {p-id, p_quantity} in the w_id warehouse
  def self.get_product_Balance(w_id, p_id)
    my_warehouse = $warehouses.detect {|w| w[:w_id] == w_id}
    # puts my_warehouse.is_a? Hash
    # puts my_warehouse
    # p_list is the list of products and their corresponding quantities in a specific warehouse (with the id of w_id)
    p_list = my_warehouse[:w_products]
    product = p_list.detect {|hash| 
      hash[:p_id] == p_id
    }
  end 
  def self.update_product_Balance(w_id, p_id, new_balance)
    my_warehouse = $warehouses.detect {|w| w[:w_id] == w_id}
    # p_list is the list of products and their corresponding quantities in a specific warehouse (with the id of w_id)
    p_list = my_warehouse[:w_products]
    product = p_list.detect {|hash| 
      hash[:p_id] == p_id
    }
    product[:p_quantity] = new_balance

  end
  
end