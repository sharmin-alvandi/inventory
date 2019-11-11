# x = key:
# t = key:
# if t == key:
#   print "r"
# end


$warehouses = [{w_id: 200, w_location: "M2K1H2", w_products: [{p_id: 100, p_quantity: 4}, {p_id: 101, p_quantity: 60}]}, 
{w_id: 201,  w_location: "L4E1G2",  w_products: [{p_id: 100, p_quantity: 30}, {p_id: 101, p_quantity: 20}]}]


def find_product_in_warehouse(w_id, p_id)
  my_warehouse = $warehouses.detect {|warehouse| warehouse[:w_id] == w_id}
  # p_list = my_warehouse.keep_if { |key, value| key == :w_products}
  p_list = my_warehouse[:w_products]
  # p_list.any? {|p| p[:p_id] == p_id}
  product = p_list.select {|hash| 
    hash[:p_id] == p_id
  }
  puts product
   
end
 find_product_in_warehouse(200, 101)