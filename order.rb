class Order
  attr_accessor :order_id, :buyer_id, :order_list
  def initialize(order_id, buyer_id, order_list)
    @order_id = order_id
    @buyer_id = buyer_id
    @order_list = order_list
  end
  def place_order(my_order) 
    $orders.push(my_order)
  end
  def self.show_orders
    $orders.each { |order| 
      puts " "
      order.each { |key, value|
      print "#{key}: #{value},  "
    }
  }
  end
  
end
