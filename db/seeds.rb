item_one = Item.create(name: 'Item 1', description: 'Example item', category: 'Soft Goods', initial_stock: 10)
item_one.purchases.create(quantity: 5)
item_one.purchases.create(quantity: 10)
item_one.sales.create(quantity: 4)

item_two = Item.create(name: 'Item 2', description: 'Example item', category: 'Hard Goods', initial_stock: 2)
item_two.purchases.create(quantity: 12)
item_two.purchases.create(quantity: 20)
item_two.sales.create(quantity: 4)

item_three = Item.create(name: 'Item 3', description: 'Example item', category: 'Soft Goods', initial_stock: 5)
item_three.purchases.create(quantity: 14)
item_three.purchases.create(quantity: 17)
item_three.sales.create(quantity: 4)
item_three.sales.create(quantity: 8)

item_four = Item.create(name: 'Item 4', description: 'Example item', category: 'Hard Goods', initial_stock: 12)
item_four.purchases.create(quantity: 7)
item_four.purchases.create(quantity: 5)
item_four.purchases.create(quantity: 10)
item_four.sales.create(quantity: 4)
item_four.sales.create(quantity: 12)

item_five = Item.create(name: 'Item 5', description: 'Example item', category: 'Misc Goods', initial_stock: 22)
item_five.purchases.create(quantity: 10)
item_five.purchases.create(quantity: 8)
