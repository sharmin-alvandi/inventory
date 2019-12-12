require_relative 'product'
require './warehouse'
require  './order'
require  './validate'

class MultiLocactionInventory
 
  # Initialize Products array 
  # products_list = []
  $products_list = [{id: 100, name: "P1", price: 11.99}, {id: 101, name: "P2", price: 16.99}]
  $p_id = 101

  # Initialize Warehouses array
  $warehouses = [{w_id: 200, w_location: "M2K1H2", w_products: [{p_id: 100, p_quantity: 4}, {p_id: 101, p_quantity: 60}]}, 
  {w_id: 201,  w_location: "L4E1G2",  w_products: [{p_id: 100, p_quantity: 30}, {p_id: 101, p_quantity: 20}]}]
  # $warehouse_products = [{p_id: 100, p_quantity:50}]
  $w_id = 201

  # Initializing orders array
  $orders = [{o_id: 300, buyer_id: 22, order_list: [{o_p_id: 100, o_p_quantity: 4, warehouse_id: 200}, {o_p_id: 101, o_p_quantity: 5, warehouse_id: 201}]}]
  $o_id = 300
  # $buyer_id = 22
  
  def self.run
    exit_app =  false
    while !exit_app do
      puts ""
      puts "Please Enter your option number:"
      puts "1-Products  2-Warehouses  3-Orders  4-Exit"
      main_menu_option = gets.chomp()
      case main_menu_option
      when "1"
        # Product manipulation
        self.manage_products
      when "2"
        # warehouse manipulation
        self.manage_warehouses
      when "3"
        self.manage_orders
      when "4"
        # Exit the application
        exit_app = true
      end #case
    end #while !exit_app

  end  #run




  def self.manage_products
    puts "1-Add a new product, 2-Show products "
    option = gets.chomp()
    case option
    when "1"
      # Add  a new product
      continue = "Y"
      while (continue == "Y") do
        $p_id += 1
        puts "Product's name: "
        p_name = gets.chomp()
        puts "product's price: "
        p_price = gets.chomp()
        product = {id: $p_id, name: p_name, price: p_price}
        product_obj = Product.new($p_id, p_name, p_price)
        product_obj.add_product(product)
        puts "The following product has been added successfully!"
        puts "Name: #{product_obj.name}  Pice: #{product_obj.price}"
        print "Add a new product? Y/N "
        continue = gets.chomp()
        continue.upcase!
      end
    when "2"
      #  Show Products
      Product.show_products()
    end
  end #manage_products


  def self.manage_warehouses
    puts "1-Add a new warehouse, 2-Show warehouses "
    option = gets.chomp()
    case option
    when "1"
      # Add a new warehouse
      continue = "Y"
      while (continue == "Y") do
        $w_id += 1
        valid_postalcode = false
        while !valid_postalcode do
          puts "Warehouse's postal code(A1A 1A1): "
          w_location = gets.chomp()
          if !Validate.postal_code?(w_location)
            puts "It's not a valid postal code! Try again." 
          else
            valid_postalcode = true
            w_location = w_location.gsub(/\s+/, "").upcase!
          end
        end
        # w_products stores a list of products as well as each product's quantity in a specific warehouse 
        w_products = []
        continue_product_list = "Y"
        while continue_product_list == "Y" do
          product_exists = false
          while !product_exists do
            
            puts "Enter product_id: "
            p_id = gets.chomp().to_i
            if Product.find_product(p_id).empty?
              puts "Product does not exist. Try another product or Add a new product in main menu"
            else
              product_exists = true
              if !w_products.empty? && w_products.any? {|p| p[:p_id] == p_id}
                puts "You already added this product!" 
              else
                puts "Enter the quantity:"
                p_quantity = gets.chomp().to_i
                w_products << {p_id: p_id, p_quantity: p_quantity}
              end
            end
          end
          
          print "Add more products to the warehouse? Y/N "
          continue_product_list = gets.chomp().upcase!
        end
        warehouse = {w_id: $w_id, w_location: w_location, w_products: w_products}
        warehouse_obj = Warehouse.new($w_id, w_location, w_products)
        warehouse_obj.add_warehouse(warehouse)
        puts "The following warehouse has been added successfully!"
        puts "Location: #{warehouse_obj.w_location}  Id: #{warehouse_obj.w_id}    products: #{w_products}"
        print "Add a new warehouse? Y/N "
        continue = gets.chomp()
        continue.upcase!
      end
    when "2"
      Warehouse.show_warehouses()
    end  #case 
  end #manage_warehouses  


  def self.manage_orders
    puts "1-Place an order, 2-Show orders "
      option = gets.chomp()
      case option
      when "1"
        # Place an order
        found_enough = false
        found = false
        order_list = []
        $o_id += 1
        #  Because there is no User class/authentication in my design, I need to get the buyer_id from console
        puts "Enter your 2-digit buyer id: "
        buyer_id = gets.chomp().to_i
        continue = "Y"
        while (continue == "Y") do
          puts "Enter your ordering product_id: "
          p_id = gets.chomp().to_i
          puts "How many:"
          order_quantity = gets.chomp().to_i
          $warehouses.each {|warehouse| 
            w_id = warehouse[:w_id]
            # get_product_balance returns a hash of product_id and its quantity in the w_id warehouse
            product = Warehouse::get_product_Balance(w_id, p_id)
            p product
            if !product.nil?
              found = true
              current_balance = product[:p_quantity]
              if order_quantity < current_balance
                found_enough = true
                new_balance = current_balance - order_quantity
                Warehouse.update_product_Balance(w_id, p_id, new_balance)
                order_list << {o_p_id: p_id, o_p_quantity: order_quantity, warehouse_id: w_id}
                p order_list
                break
              else
                found_enough = false
              end
            else
              found = false
            end
          }

          puts "Sorry! We're running out of product# #{p_id}!" if !found_enough && found
          puts "Sorry! the product# #{p_id} is out of stock." if !found

          print "Add another product to your order? Y/N "
          continue = gets.chomp().gsub(/\s+/, "").upcase!
        end
        if found_enough
          order_obj = Order.new($o_id, buyer_id, order_list)
          my_order = {o_id: $o_id, buyer_id: buyer_id, order_list: order_list}
          puts my_order
          order_obj.place_order(my_order)
        end
      when "2"
        Order.show_orders()
      end #case
  end #manage_orders  

  MultiLocactionInventory.run
end #class