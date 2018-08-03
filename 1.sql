--ITRATION 4 KEZIA LOWERY-MCCLAIN

CREATE USER TermProjectDDI IDENTIFIED BY termprojectddipassword
DEFAULT TABLESPACE users TEMPORARY TABLESPACE TEMP;

--SELLER ENTITY

CREATE TABLE SELLER (
  seller_id NUMBER (10)  NOT NULL PRIMARY KEY,
  listing_id NUMBER (10) NOT NULL,
  product_id NUMBER (10) NOT NULL,
  seller_first_name VARCHAR(50),
  seller_last_name VARCHAR(50)
);

ALTER TABLE SELLER
ADD CONSTRAINT fk_listing_id
FOREIGN KEY (listing_id)
REFERENCES Listing (listing_id);

ALTER TABLE SELLER
ADD CONSTRAINT fk_product_id
FOREIGN KEY (product_id)
REFERENCES Product (product_id);

--NOT WORKING!
ALTER TABLE SELLER
ADD FOREIGN KEY (product_id)
REFERENCES PRODUCT (product_id);

--EXAMPLE

CREATE TABLE customer_order (
order_id NUMBER(10) NOT NULL PRIMARY KEY,
customer_id NUMBER(10) NOT NULL,
order_total NUMBER(12,2),
order_date DATE
);

ALTER TABLE customer_order
ADD CONSTRAINT fk_customer_id
FOREIGN KEY (customer_id) 
REFERENCES customer(customer_id);

--END OF EXAMPLE

--TIME TO INSERT DATA!
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name) VALUES (1,'Ship24', NULL);
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name) VALUES (2,'ReliableMarketplace', NULL);
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name) VALUES (3,'MaryAnn', 'JohnsonINC');
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name) VALUES (4,'UnlimitedAppliance', 'Parts');
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name) VALUES (5,'UnbeatableSale,INC', NULL);


--CATEGORY ENTITY

CREATE TABLE CATEGORY (
  category_id NUMBER (10)  NOT NULL PRIMARY KEY,
  product_id NUMBER (10) NOT NULL,
  category_name VARCHAR(50)
  );


ALTER TABLE CATEGORY
ADD CONSTRAINT fk_ProductCategory
FOREIGN KEY (product_id)
REFERENCES PRODUCT (product_id);  

--TIME TO INSERT DATA!
INSERT INTO CATEGORY (category_id, category_name) VALUES (1,'Computers');
INSERT INTO CATEGORY (category_id, category_name) VALUES (2,'Electronics');
INSERT INTO CATEGORY (category_id, category_name) VALUES (3,'Appliances');
INSERT INTO CATEGORY (category_id, category_name) VALUES (4,'Beauty');
INSERT INTO CATEGORY (category_id, category_name) VALUES (5,'Clothing');
INSERT INTO CATEGORY (category_id, category_name) VALUES (6,'Furniture');
INSERT INTO CATEGORY (category_id, category_name) VALUES (7,'Food');

--NOT THESE

INSERT INTO CATEGORY (category_id, product_id, category_name) VALUES (1,'Ship24', NULL);
INSERT INTO CATEGORY (category_id, product_id, category_name) VALUES (1,'Ship24', NULL);
INSERT INTO CATEGORY (category_id, product_id, category_name) VALUES (1,'Ship24', NULL);
INSERT INTO CATEGORY (category_id, product_id, category_name) VALUES (1,'Ship24', NULL);


--LISTING ENTITY

CREATE TABLE LISTING (
  listing_id NUMBER (10)  NOT NULL PRIMARY KEY,
  seller_id NUMBER (10) NOT NULL,
  product_id NUMBER (10) NOT NULL
 );
  
ALTER TABLE LISTING
ADD CONSTRAINT fk_seller_id
FOREIGN KEY (seller_id)
REFERENCES SELLER (seller_id);


ALTER TABLE LISTING
ADD CONSTRAINT fk_ProductListing
FOREIGN KEY (product_id)
REFERENCES PRODUCT (product_id);

--TIME TO INSERT DATA!
INSERT INTO LISTING (listing_id, seller_id) VALUES (1,1);
INSERT INTO LISTING (listing_id, seller_id) VALUES (2,1);

INSERT INTO LISTING (listing_id, seller_id) VALUES (3,5);
INSERT INTO LISTING (listing_id, seller_id) VALUES (4,4);

COMMIT;


--there will be twelve more listings

--PRODUCT ENTITY

CREATE TABLE PRODUCT (
  product_id NUMBER (10)  NOT NULL PRIMARY KEY,
  category_id NUMBER (10) NOT NULL--CONSTRAINT fk_prod_cate REFERENCES CATEGORY(category_id),
  inventory_id NUMBER (10) NOT NULL,
  listing_id NUMBER (10) NOT NULL,
  seller_id NUMBER (10) NOT NULL,
  product_name VARCHAR(50),
  product_description VARCHAR(50),
  product_price NUMBER (10)
);

ALTER TABLE PRODUCT
ADD CONSTRAINT fk_SellerProduct
FOREIGN KEY (seller_id)
REFERENCES SELLER (seller_id);


ALTER TABLE PRODUCT
ADD CONSTRAINT fk_ListingProduct
FOREIGN KEY (listing_id)
REFERENCES LISTING (listing_id);

ALTER TABLE PRODUCT
ADD CONSTRAINT fk_category_id
FOREIGN KEY (category_id)
REFERENCES CATEGORY (category_id);

ALTER TABLE PRODUCT
ADD CONSTRAINT fk_InventoryProduct
FOREIGN KEY (inventory_id)
REFERENCES INVENTORY (inventory_id);

--INVENTORY ENTITY

CREATE TABLE INVENTORY (
  inventory_id NUMBER (10)  NOT NULL PRIMARY KEY,
  warehouse_id NUMBER (10),
  product_id NUMBER (10),
  balance_on_hand NUMBER (10),
  CONSTRAINT Fk_ProductInventory FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
 );

--TIME TO INSERT DATA!
INSERT INTO INVENTORY (inventory_id,balance_on_hand) VALUES (1,15);
INSERT INTO INVENTORY (inventory_id,balance_on_hand) VALUES (2,7);

COMMIT;


--Stored Procedure 2

--A seller adds two new products. 

--The first is a self driving video camera which automatically
--follows a subject that is being recorded. 

--The second is a holographic keyboard that emits a three ‐dimensional 
--projection of a keyboard and recognizes virtual key presses from the typist.

--OUTLINE EXAMPLE OF A SP

CREATE OR REPLACE PROCEDURE DeleteQuiz
	(qID NUMBER)
AS
  BEGIN
    DELETE FROM Quiz_Question
    WHERE quizID = qID;

    DELETE FROM Quiz
    WHERE quizID = qID;
  END;
 
CREATE OR REPLACE PROCEDURE ADD_CUSTOMER( 
cus_id_arg IN NUMBER, 
first_name_arg IN VARCHAR, 
last_name_arg IN VARCHAR,
cust_balance_arg IN NUMBER) 
IS 
BEGIN
INSERT INTO CUSTOMER
(customer_id,customer_first,customer_last,customer_total)
VALUES(cus_id_arg,first_name_arg,last_name_arg,cust_balance_arg);
END;
  
  --1ST
  
CREATE OR REPLACE PROCEDURE AddNewProduct( 
  product_id_arg IN NUMBER,
  category_id_arg IN NUMBER,
  inventory_id_arg IN NUMBER,
  listing_id_arg IN NUMBER,
  seller_id_arg NUMBER,
  product_name_arg IN VARCHAR,
  product_description_arg IN VARCHAR,
  product_price_arg IN NUMBER)
IS 
BEGIN
INSERT INTO PRODUCT (product_id,category_id,inventory_id,listing_id,
            seller_id, product_name,product_description,product_price)
VALUES(product_id_arg,category_id_arg,inventory_id_arg,listing_id_arg,seller_id_arg,
            product_name_arg,product_description_arg,product_price_arg);
END;
  
--Execute the SP

BEGIN
AddNewProduct(product_id,category_id,inventory_id,listing_id,
            seller_id, product_name,product_description,product_price);
END;
/

--ACTUAL PARAMETERS TO RUN
--REQUIREMENT 1

BEGIN
AddNewProduct(1,2,1,1,1, 'Auto-Cam Recorder','Self driving video camera that 
			automatically follows a subject that is being recorded',350.98);
END;
/

--REQUIREMENT 2

BEGIN
AddNewProduct(2,2,2,2,1, 'Holographic Keyboard','Holographic keyboard that 
			emits a three-dimensional projection of a keyboard and recognizes virtual 
			key presses from the typist',1755.50);
END;
/

--RUN SP QUERY

SELECT * FROM PRODUCT;

--ROUNDING ISSUE- how do I remove the auto rounding feature??

ALTER TABLE PRODUCT  
MODIFY (PRODUCT_PRICE DECIMAL(6,2) );

--QUERY TO PULL PRODUCTS IN “Computers” or “Electronics” categories that cost $30 or less

ALTER TABLE PRODUCT  
MODIFY (PRODUCT_description VARCHAR(400) );

--use sp to insert two additional products

BEGIN
AddNewProduct(product_id,category_id,inventory_id,listing_id,
            seller_id, product_name,product_description,product_price);
END;
/

--REQUIREMENT 1

BEGIN
AddNewProduct(3,1,1,3,5, 'Logitech S150 USB Speakers with Digital Sound',
			'Simple USB Connectivity for music, movies and MP3s on 
			quality digital audio system',13.37);
END;
/

COMMIT;


--REQUIREMENT 2

BEGIN
AddNewProduct(4,1,1,4,4, 'TaoTronics Computer Speakers','Wired 
			Computer Sound Bar, Stereo USB Powered Mini Soundbar Speaker for
			PC Cellphone Tablets Desktop Laptop',29.99);
END;
/

COMMIT;


--create and run query
--PULL PRODUCTS IN “Computers” or “Electronics” categories that cost $30 or less

--no rows returned DID NOT WORK
SELECT PRODUCT.product_id, PRODUCT.product_name
WHERE PRODUCT.category_id = 1 or 2
	AND PRODUCT.product_price < 30;
	
	
--TRY AGAIN

--COUNT WORKED 
SELECT COUNT (product_price)
FROM PRODUCT
WHERE product.product_price <30;

--GOOD BUT NEEDS TO BE MORE SPECIFIC WITH THE CATEGORIES

SELECT Product.product_price, Product.product_name
FROM PRODUCT
WHERE product.product_price <30;

--categories added

SELECT Product.category_id,Product.product_price, Product.product_name
FROM PRODUCT
WHERE product.product_price <30;


--BUT I NEED THE CATEGORIES AND NAME OF PRODUCTS
--need a JOIN ON category id and category name

SELECT Product.category_id,CATEGORY.category_name, Product.product_price, Product.product_name
FROM PRODUCT
JOIN CATEGORY on PRODUCT.category_id = CATEGORY.category_id
WHERE product.product_price <30;

-ALL DONE IT WORKED!!


SELECT (product_price, product_name)
FROM PRODUCT
WHERE (product.category_id = 1, product.category_id = 2, product.product_price <30);
















	




