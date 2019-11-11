
class Product
  attr_accessor :id, :name, :price
  def initialize(id, name, price)
     @id = id
     @name = name
     @price = price
  end
  def add_product(product)
    $products_list.push(product)
    # puts $products_list
  end
  def self.show_products
    $products_list.each { |product| 
      puts " "
      product.each { |key, value|
      print "#{key}: #{value},  "
    }
  }
  end
  def self.find_product(p_id)
    product = $products_list.select {|product| product[:id] == p_id}
    # puts product
  end  
end
  
    
    