CREATE DATABASE IF NOT EXISTS foodrush CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE foodrush;

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS reviews, order_items, orders, wishlist, cart, addresses, foods, restaurants, categories, coupons, admins, users;
SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE users (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE,
 phone VARCHAR(30) NOT NULL,
 password VARCHAR(255) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE admins (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE,
 password VARCHAR(255) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(100) NOT NULL UNIQUE,
 image VARCHAR(500) DEFAULT '',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE restaurants (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(150) NOT NULL,
 cuisine VARCHAR(150) NOT NULL,
 image VARCHAR(500) DEFAULT '',
 rating DECIMAL(2,1) DEFAULT 4.5,
 delivery_time VARCHAR(40) DEFAULT '30-40 min',
 delivery_fee DECIMAL(10,2) DEFAULT 30,
 price_range VARCHAR(30) DEFAULT '₹₹',
 is_veg TINYINT(1) DEFAULT 0,
 offer_text VARCHAR(255) DEFAULT '',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE foods (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 restaurant_id INT UNSIGNED NOT NULL,
 category_id INT UNSIGNED NOT NULL,
 name VARCHAR(150) NOT NULL,
 description TEXT,
 image VARCHAR(500) DEFAULT '',
 price DECIMAL(10,2) NOT NULL,
 discount DECIMAL(5,2) DEFAULT 0,
 rating DECIMAL(2,1) DEFAULT 4.5,
 is_veg TINYINT(1) DEFAULT 0,
 is_bestseller TINYINT(1) DEFAULT 0,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
 FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE cart (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NOT NULL,
 food_id INT UNSIGNED NOT NULL,
 quantity INT UNSIGNED NOT NULL DEFAULT 1,
 UNIQUE KEY user_food (user_id, food_id),
 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
 FOREIGN KEY (food_id) REFERENCES foods(id) ON DELETE CASCADE
);

CREATE TABLE wishlist (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NOT NULL,
 food_id INT UNSIGNED NOT NULL,
 UNIQUE KEY user_food (user_id, food_id),
 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
 FOREIGN KEY (food_id) REFERENCES foods(id) ON DELETE CASCADE
);

CREATE TABLE addresses (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NOT NULL,
 label VARCHAR(50) DEFAULT 'Home',
 address TEXT NOT NULL,
 city VARCHAR(100) NOT NULL,
 pincode VARCHAR(20) NOT NULL,
 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE orders (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NOT NULL,
 total DECIMAL(10,2) NOT NULL,
 payment_method VARCHAR(50) NOT NULL,
 address TEXT NOT NULL,
 status ENUM('Placed','Confirmed','Preparing','Out for Delivery','Delivered','Cancelled') DEFAULT 'Placed',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE order_items (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 order_id INT UNSIGNED NOT NULL,
 food_id INT UNSIGNED NOT NULL,
 quantity INT UNSIGNED NOT NULL,
 price DECIMAL(10,2) NOT NULL,
 FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
 FOREIGN KEY (food_id) REFERENCES foods(id)
);

CREATE TABLE coupons (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 code VARCHAR(50) NOT NULL UNIQUE,
 discount_percent DECIMAL(5,2) NOT NULL,
 min_order DECIMAL(10,2) DEFAULT 0,
 expires_at DATETIME NOT NULL
);

CREATE TABLE reviews (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 user_id INT UNSIGNED NOT NULL,
 food_id INT UNSIGNED NOT NULL,
 rating TINYINT UNSIGNED NOT NULL,
 comment TEXT,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
 FOREIGN KEY (food_id) REFERENCES foods(id) ON DELETE CASCADE
);

INSERT INTO admins(name,email,password) VALUES
('FoodRush Admin','admin@foodrush.local','$2y$12$x8wMJq67D1qEjTEBID9Rk.UARktGABlFtwu0S/2CSoknBOv5EwMce');
-- Password for the demo admin above: password

INSERT INTO categories(name,image) VALUES
('Pizza','https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500'),
('Burgers','https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500'),
('Biryani','https://images.unsplash.com/photo-1563379091339-03246963d96c?w=500'),
('Indian','https://images.unsplash.com/photo-1601050690597-df0568f70950?w=500'),
('Chinese','https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?w=500'),
('South Indian','https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500'),
('Desserts','https://images.unsplash.com/photo-1551024506-0bccd828d307?w=500'),
('Beverages','https://images.unsplash.com/photo-1544145945-f90425340c7e?w=500'),
('Fast Food','https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=500'),
('Healthy Food','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500'),
('Cakes','https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500'),
('Ice Cream','https://images.unsplash.com/photo-1501443762994-82bd5dace89a?w=500');

INSERT INTO restaurants(name,cuisine,image,rating,delivery_time,delivery_fee,price_range,is_veg,offer_text) VALUES
('Spice Route','North Indian & Biryani','https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=900',4.8,'25-35 min',30,'₹₹',0,'20% OFF'),
('Urban Crust','Pizza & Italian','https://images.unsplash.com/photo-1513104890138-7c749659a591?w=900',4.7,'20-30 min',20,'₹₹',0,'Buy 1 Get 1'),
('Burger Lab','Burgers & Fast Food','https://images.unsplash.com/photo-1552566626-52f8b828add9?w=900',4.6,'25-35 min',25,'₹₹',0,'Free fries'),
('Green Bowl','Healthy & Salads','https://images.unsplash.com/photo-1515003197210-e0cd71810b5f?w=900',4.5,'20-30 min',15,'₹₹',1,'15% OFF'),
('Chopsticks','Chinese & Asian','https://images.unsplash.com/photo-1552566626-52f8b828add9?w=900',4.4,'30-40 min',25,'₹₹',0,'Flat ₹100 OFF');

INSERT INTO foods(restaurant_id,category_id,name,description,image,price,discount,rating,is_veg,is_bestseller) VALUES
(1,3,'Hyderabadi Chicken Biryani','Aromatic basmati rice, tender chicken and signature spices.','https://images.unsplash.com/photo-1563379091339-03246963d96c?w=700',299,10,4.9,0,1),
(1,4,'Paneer Butter Masala','Creamy tomato gravy with soft paneer.','https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=700',229,8,4.7,1,1),
(2,1,'Margherita Pizza','Classic tomato, mozzarella and basil.','https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=700',249,15,4.8,1,1),
(2,1,'Farmhouse Pizza','Loaded with fresh vegetables and cheese.','https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=700',329,12,4.7,1,0),
(3,2,'Classic Smash Burger','Double smashed patty with cheese and house sauce.','https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=700',219,10,4.8,0,1),
(3,9,'Loaded Fries','Crispy fries with cheese and signature seasoning.','https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=700',149,5,4.5,1,0),
(4,10,'Power Salad Bowl','Fresh greens, grains, vegetables and dressing.','https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=700',199,15,4.6,1,1),
(4,8,'Berry Smoothie','Mixed berries blended with yogurt and honey.','https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=700',159,10,4.6,1,0),
(5,5,'Veg Hakka Noodles','Wok-tossed noodles with vegetables.','https://images.unsplash.com/photo-1585032226651-759b368d7246?w=700',189,10,4.5,1,0),
(5,5,'Chicken Fried Rice','Fragrant rice wok-tossed with chicken and vegetables.','https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=700',229,8,4.6,0,1);

INSERT INTO foods(restaurant_id,category_id,name,description,image,price,discount,rating,is_veg,is_bestseller) VALUES
(1,3,'Mutton Biryani','Slow-cooked mutton with fragrant basmati rice and spices.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',349,12,4.8,0,1),
(1,3,'Egg Biryani','Spiced basmati rice layered with boiled eggs.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',219,8,4.6,0,0),
(1,4,'Dal Tadka','Yellow lentils tempered with cumin, garlic and chillies.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',149,5,4.6,1,0),
(1,4,'Butter Naan','Soft tandoor naan brushed with butter.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',59,0,4.7,1,1),
(1,4,'Chicken Tikka','Char-grilled chicken pieces marinated in aromatic spices.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',279,10,4.7,0,1),
(1,4,'Veg Korma','Mixed vegetables in a rich creamy curry.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',189,8,4.5,1,0),
(2,1,'Pepperoni Pizza','Cheesy pizza topped with spicy pepperoni.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',349,15,4.8,0,1),
(2,1,'Cheese Burst Pizza','Loaded with mozzarella and a creamy cheese center.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',379,12,4.7,1,1),
(2,1,'BBQ Chicken Pizza','Smoky BBQ chicken with onions and mozzarella.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',369,10,4.6,0,0),
(2,1,'Veggie Delight Pizza','Bell peppers, olives, onions and sweet corn.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',299,10,4.6,1,0),
(2,1,'Garlic Bread','Toasted bread with garlic butter and herbs.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',129,5,4.5,1,0),
(2,7,'Chocolate Lava Cake','Warm chocolate cake with a molten center.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',169,8,4.8,1,1),
(3,2,'Cheese Burger','Crispy patty, cheddar, lettuce and signature sauce.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',199,10,4.7,0,1),
(3,2,'Chicken Zinger Burger','Crunchy chicken fillet with spicy mayo.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',239,12,4.8,0,1),
(3,2,'Veggie Burger','Crispy vegetable patty with fresh lettuce.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',179,8,4.5,1,0),
(3,9,'Chicken Wings','Crispy wings tossed in smoky spicy sauce.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',229,10,4.7,0,1),
(3,9,'Peri Peri Fries','Crispy fries with fiery peri peri seasoning.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',139,5,4.5,1,0),
(3,9,'Chicken Nuggets','Golden chicken nuggets served with dip.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',179,5,4.6,0,0),
(3,8,'Cold Coffee','Chilled creamy coffee topped with foam.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',129,10,4.6,1,1),
(3,8,'Mango Shake','Fresh mango blended into a creamy shake.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',149,5,4.7,1,0),
(4,10,'Paneer Salad','Fresh greens with grilled paneer and dressing.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',219,10,4.6,1,1),
(4,10,'Quinoa Bowl','Quinoa, roasted vegetables and herbs.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',239,12,4.5,1,0),
(4,10,'Avocado Toast','Toasted bread topped with seasoned avocado.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',199,8,4.6,1,0),
(4,8,'Green Detox Juice','Cucumber, apple, spinach and lemon blend.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',139,5,4.4,1,0),
(4,7,'Fruit Yogurt Bowl','Seasonal fruits with creamy yogurt and granola.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',179,10,4.5,1,0),
(5,5,'Chicken Manchurian','Crispy chicken tossed in tangy Manchurian sauce.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',249,10,4.7,0,1),
(5,5,'Veg Manchurian','Vegetable dumplings in a spicy Indo-Chinese sauce.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',199,8,4.6,1,0),
(5,5,'Schezwan Fried Rice','Spicy wok-fried rice with vegetables.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',209,10,4.6,1,1),
(5,5,'Chilli Paneer','Crispy paneer with peppers in chilli sauce.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',229,8,4.7,1,0),
(5,5,'Spring Rolls','Crispy rolls stuffed with seasoned vegetables.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',159,5,4.5,1,0),
(5,8,'Lemon Iced Tea','Refreshing iced tea with fresh lemon.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',99,0,4.4,1,0),
(1,6,'Masala Dosa','Crispy dosa with potato masala and chutneys.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',129,5,4.8,1,1),
(1,6,'Idli Sambar','Soft idlis served with hot sambar and chutney.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',99,0,4.6,1,0),
(1,6,'Medu Vada','Crispy lentil fritters with sambar and chutney.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',109,5,4.6,1,0),
(2,7,'Gulab Jamun','Soft milk dumplings soaked in fragrant syrup.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',99,0,4.7,1,1),
(2,7,'Brownie Sundae','Warm chocolate brownie with vanilla ice cream.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',199,10,4.8,1,1),
(3,7,'Red Velvet Cake','Moist red velvet sponge with cream cheese frosting.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',189,8,4.7,1,0),
(4,7,'Classic Cheesecake','Creamy cheesecake with a buttery biscuit base.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',219,10,4.8,1,1),
(5,7,'Ice Cream Sundae','Vanilla ice cream with chocolate sauce and nuts.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',159,5,4.6,1,0),
(5,8,'Fresh Lime Soda','Chilled lime soda with a refreshing fizz.','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=700',89,0,4.5,1,0);
