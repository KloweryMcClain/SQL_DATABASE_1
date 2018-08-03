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

--ALL DONE IT WORKED!!


SELECT (product_price, product_name)
FROM PRODUCT
WHERE (product.category_id = 1, product.category_id = 2, product.product_price <30);





--WEEK 5 ADDITIONS START HERE

--I need a TRIGGER to execute when a new product is entered and update all associated tables
--Start with the LISTING TABLE

--Trigger template

CREATE OR REPLACE TRIGGER UpdatePVChangeLog 
	AFTER UPDATE ON Quiz_Question
  FOR EACH ROW
BEGIN
	INSERT INTO QQ_PV_ChangeLog (chgID, chgDate, quizId, questionNbr,
									oldValue, newValue)
	VALUES (chgID_seq.NEXTVAL, SYSDATE(), :NEW.quizID, :NEW.questionNbr, 
          :OLD.pointValue, :NEW.pointValue);
END;	

-- Listing Trigger

CREATE OR REPLACE TRIGGER UpdateAllForNewProduct 
	AFTER UPDATE ON AddNewProduct
  FOR EACH ROW
BEGIN
	INSERT INTO LISTING (product_id)
	VALUES (:NEW.product_id);
END;

COMMIT;


--practice- remove PRODUCT_ID = 1 ' Speakers' and re-add it with the NewProduct SP AFTER
--AFTER the new above TRIGGER has been complied and commited.

--DONE

--add back the speakers

--TRY AGAIN

CREATE OR REPLACE TRIGGER TriggerAfterInsertForNewProduct
AFTER INSERT ON PRODUCT
FOR EACH ROW
DECLARE
	

--MARILU SAID NO ADDITIONAL BENEFIT TO THIS TRIGGER - ADD MANUALLY


--REQUIREMENT 2

BEGIN
AddNewProduct(4,1,1,4,4, 'TaoTronics Computer Speakers','Wired 
			Computer Sound Bar, Stereo USB Powered Mini Soundbar Speaker for
			PC Cellphone Tablets Desktop Laptop',29.99);
END;
/

COMMIT;

-----------------------------------------------------------------------------------------------------------------

--20180801 Recreate tables 

--DROP OLD TABLESPACE

--SELLER ENTITY

CREATE TABLE SELLER (
  SELLER_ID NUMBER (10)  NOT NULL PRIMARY KEY,
  SELLER_FIRST_NAME VARCHAR(100),
  SELLER_LAST_NAME VARCHAR(100),
  SELLER_ADDRESS1 VARCHAR (120),
  SELLER_ADDRESS2 VARCHAR (120),
  SELLER_CITY VARCHAR (50),
  SELLER_STATE VARCHAR (50),
  SELLER_ZIPCODE NUMBER (10),
  SELLER_PHONE NUMBER (10)
);

COMMIT;

--TIME TO INSERT DATA!
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name, SELLER_ADDRESS1, SELLER_ADDRESS2, SELLER_CITY, SELLER_STATE, SELLER_ZIPCODE, SELLER_PHONE) 
	VALUES (1,'Ship24', NULL, '31 Forsyth St.', 'Suite 1711b', 'Atlanta','GA', 30303, 4045849483);
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name, SELLER_ADDRESS1, SELLER_CITY, SELLER_STATE, SELLER_ZIPCODE, SELLER_PHONE) 
	VALUES (2,'ReliableMarketplace', NULL, '767 Fifth Avenue','New York', 'NY', 10153, 2123361440 );
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name, SELLER_ADDRESS1, SELLER_ADDRESS2, SELLER_CITY, SELLER_STATE, SELLER_ZIPCODE, SELLER_PHONE) 
	VALUES (3,'MaryAnn', 'JohnsonINC', '1130 Pine St.', 'Suite 7002', 'Louisville', 'CO', 80027,3036656850);
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name, SELLER_ADDRESS1, SELLER_CITY, SELLER_STATE, SELLER_ZIPCODE, SELLER_PHONE) 
	VALUES (4,'UnlimitedAppliance', 'Parts', '6671 Las Vegas Boulevard South', 'LAS VEGAS', 'NV', 89119, 7022218826);
INSERT INTO SELLER (seller_id,seller_first_name,seller_last_name, SELLER_ADDRESS1, SELLER_ADDRESS2, SELLER_CITY, SELLER_STATE, SELLER_ZIPCODE, SELLER_PHONE) 
	VALUES (5,'UnbeatableSale,INC', NULL, '110 S. 36th St.', 'Suite 19', 'Philadelphia', 'PA', 19082, 2158743479);


--CATEGORY ENTITY

CREATE TABLE CATEGORY (
  CATEGORY_ID NUMBER (10)  NOT NULL PRIMARY KEY,
  CATEGORY_NAME VARCHAR(50)
  );
  

  --TIME TO INSERT DATA!
INSERT INTO CATEGORY (category_id, category_name) VALUES (1,'Computers');
INSERT INTO CATEGORY (category_id, category_name) VALUES (2,'Electronics');
INSERT INTO CATEGORY (category_id, category_name) VALUES (3,'Appliances');
INSERT INTO CATEGORY (category_id, category_name) VALUES (4,'Beauty');
INSERT INTO CATEGORY (category_id, category_name) VALUES (5,'Clothing');
INSERT INTO CATEGORY (category_id, category_name) VALUES (6,'Furniture');
INSERT INTO CATEGORY (category_id, category_name) VALUES (7,'Food');



--LISTING ENTITY

CREATE TABLE LISTING (
  LISTING_ID NUMBER (10)  NOT NULL PRIMARY KEY,
  SELLER_ID NUMBER (10) NOT NULL,
 );
 
 --TIME TO INSERT DATA!
INSERT INTO LISTING (listing_id, seller_id) VALUES (1,1);
INSERT INTO LISTING (listing_id, seller_id) VALUES (2,1);
INSERT INTO LISTING (listing_id, seller_id) VALUES (3,5);
INSERT INTO LISTING (listing_id, seller_id) VALUES (4,4);
INSERT INTO LISTING (listing_id, seller_id) VALUES (5,3);
INSERT INTO LISTING (listing_id, seller_id) VALUES (6,2);
INSERT INTO LISTING (listing_id, seller_id) VALUES (7,5);
INSERT INTO LISTING (listing_id, seller_id) VALUES (8,5);
INSERT INTO LISTING (listing_id, seller_id) VALUES (9,1);
INSERT INTO LISTING (listing_id, seller_id) VALUES (10,2);
INSERT INTO LISTING (listing_id, seller_id) VALUES (11,2);
INSERT INTO LISTING (listing_id, seller_id) VALUES (12,4);
INSERT INTO LISTING (listing_id, seller_id) VALUES (13,3);
INSERT INTO LISTING (listing_id, seller_id) VALUES (14,4);

COMMIT;
--ADD 10 MORE FOR EACH PRODUCT --DONE 

--INVENTORY ENTITY

CREATE TABLE INVENTORY (
  INVENTORY_ID NUMBER (10)  NOT NULL PRIMARY KEY,
  BALANCE_ON_HAND NUMBER (10),
 );

--TIME TO INSERT DATA!
INSERT INTO INVENTORY (inventory_id) VALUES (1);
INSERT INTO INVENTORY (inventory_id) VALUES (2);

COMMIT;

--BALANCE_ON_HAND WILL BE A DERIVED ATTRIBUTE COMPRISED OF ALL PRODUCTS WITH MATCHING
--INVENTORY CODE (I.E. INVENTORY_CODE = 1, PRODUCTS 1,2,3 ARE IN THIS INVENTORY AND THEIR
--QUANTITIES TOTAL 54. A JOIN WILL NEED TO BE CREATED TO KNOW 
--WHICH PRODUCTS MAKE UP THE TOTAL)
--ALTER TABLE OR UPDATE TABLE CLAUSE TO CALCULATE THIS 

--PRODUCT ENTITY

CREATE TABLE PRODUCT (
  PRODUCT_ID NUMBER (10)  NOT NULL PRIMARY KEY,
  PRODUCT_NAME VARCHAR(50),
  PRODUCT_DESCRIPTION VARCHAR(400),
  PRODUCT_PRICE DECIMAL (8,2)
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

ALTER TABLE PRODUCT
ADD CONSTRAINT FK_PRODUCT_SHIPMENT
FOREIGN KEY (SHIPMENT_ID)
REFERENCES SHIPMENT (SHIPMENT_ID);

--NOT INCLUDING SHIPMENT_ID IN THE INSERT STATEMENTS, WILL ADD THESE AS A STORED PROCEDURE
--WHEN AN ORDER IS PLACED

--TIME TO INSERT DATA!

INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(1, 2, 1, 1, 1, 'Auto-Cam Recorder', 'Self driving video camera that 
			automatically follows a subject that is being recorded', 350.98);

INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(2, 2 ,2, 2, 2, 'Holographic Keyboard', 'Holographic keyboard that emits a 
			three-dimensional projection of a keyboard and recognizes virtual key 
			presses from the typist', 1755.50);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(3, 1, 2, 3, 5, 'Logitech S150 USB Speakers with Digital Sound', 'Simple 
			USB Connectivity for music, movies and MP3s on quality digital 
			audio system', 13.37);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(4, 1, 1, 4, 4, 'TaoTronics Computer Speakers', 'Wired Computer Sound 
			Bar, Stereo USB Powered Mini Soundbar Speaker for PC 
			Cellphone Tablets Desktop Laptop', 29.99);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(5, 3, 2, 5, 3, 'iRobot Roomba 690 Robot Vacuum with Wi-Fi Connectivity',
			 'Sleek, premium design complements your home décor; includes 1 
			 Dual Mode Virtual Wall Barrier for more control over where 
			 your robot cleans', 297.00);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(6, 3, 2, 6, 2, 'Kenmore Top Load Washer', 'With a 4.2 cu. ft. 
			capacity, this washer can clean up to 19 towels in a single load', 499.99);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(7, 4, 2, 7, 5, 'Burberry Women''s Classic Eau de parfum Spray, 3.3 Fl Oz',
			'The scent features fruity top notes of blackcurrant, fresh green 
			apple and bright bergamot. Heart notes of cedar wood, jasmine, moss 
			are intensified with warm notes of sandalwood for a rich and sensual 
			tone. Warm notes of musk and vanilla smooth the base.', 95);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(8, 4, 1, 8, 5, 'Jane Iredale Chisel Powder Brush','A full, plush 
			brush for applying loose powders. Available in goat hair 
			(graphite) or Naturon (rose gold).', 36);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(9, 5, 1, 9, 1, 'Glamorous Women''s Off The Shoulder Maxi Dress',
			'One and done outfit in this stunning floral maxi dress for comfort 
			and style',79);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(10, 5, 2, 10, 2, 'Mara Hoffman Women''s Mia One Piece Swimsuit', 
			'Mara Hoffman high cut maillot. Highlight a with a multi colored 
			floral print. Mid cut neckline with a low back feature. Made out 
			of Italian fabrics with UPF 50+. lined with 78 percent recycled 
			nylon, 22 percent spandex', 325);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(11, 6, 1, 11, 2, 'Divano Roma Furniture Mid-Century Modern Tufted Linen 
			Fabric Sofa (Light Blue)', 'Modern mid century sofa in various colors 
			- Includes 2 bolster side pillows and 2 square pillows in the same 
			fabric', 229.99);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(12, 6, 1, 12, 4, 'Universal Rugs Tonya Transitional Paisley Ivory Round 
			Area Rug, 5'' Round'' ','Stylish paisley pattern with a lively appeal.
			Snowy ivory background with teal blue, pear green, cranberry red, 
			russet, ecru gold, mushroom taupe, and espresso brown.', 43.84);


INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(13, 7, 2, 13, 3, 'Boca Meatless Soy Protein Ground Crumbles, 12 oz 
			(Frozen)', 'These tasty ground crumbles are as versatile as they are 
			nutritious. Made withnon-gmo soy protein, it becomes the centerpiece 
			of any delicious meal', 4.19);

INSERT INTO PRODUCT (PRODUCT_ID, CATEGORY_ID, INVENTORY_ID, LISTING_ID, SELLER_ID, 
			PRODUCT_NAME, PRODUCT_DESCRIPTION, PRODUCT_PRICE)
	VALUES(14, 7, 1, 14, 4, 'Sabra, Chunky Pico De Gallo Salsa, Medium 16 oz',
			'Fiesta like there’s no mañana with our authentic Pico de Gallo 
			salsa. We use chunky-cut tomatoes, onions and peppers...so every 
			bite is bursting with flavor.', 2.83);


--SHIPPING SPEED ENTITY

CREATE TABLE SHIPPING_SPEED (
	SHIPPING_SPEED_ID NUMBER(10) NOT NULL PRIMARY KEY,
	SPEED_NAME VARCHAR (50),
	SHIPPING_SPEED_DESCRIPTION VARCHAR (100),
	SPEED_COST NUMBER (6,2)
);

--TIME TO INSERT DATA!

INSERT INTO SHIPPING_SPEED (SHIPPING_SPEED_ID,SPEED_NAME,SHIPPING_SPEED_DESCRIPTION, SPEED_COST)
VALUES (1,'STANDARD', '3 to 5 Business Days', 5.99);


INSERT INTO SHIPPING_SPEED (SHIPPING_SPEED_ID,SPEED_NAME,SHIPPING_SPEED_DESCRIPTION, SPEED_COST)
VALUES (2,'2-DAY', '2 Business Days', 15.99);

INSERT INTO SHIPPING_SPEED (SHIPPING_SPEED_ID,SPEED_NAME,SHIPPING_SPEED_DESCRIPTION, SPEED_COST)
VALUES (3,'OVERNIGHT', 'If purchased before 12pm, delivered next Business Day', 26.95);


INSERT INTO SHIPPING_SPEED (SHIPPING_SPEED_ID,SPEED_NAME,SHIPPING_SPEED_DESCRIPTION, SPEED_COST)
VALUES (4,'SAME-DAY', 'If purchased before 9am, delivered same day by 8pm', 45.85);


--CUSTOMER ENTITY

CREATE TABLE CUSTOMER (
  CUSTOMER_ID NUMBER (10)  NOT NULL PRIMARY KEY,
  CUSTOMER_FIRST_NAME VARCHAR(100),
  CUSTOMER_LAST_NAME VARCHAR(100),
  CUSTOMER_ADDRESS1 VARCHAR (120),
  CUSTOMER_ADDRESS2 VARCHAR (120),
  CUSTOMER_CITY VARCHAR (50),
  CUSTOMER_STATE VARCHAR (50),
  CUSTOMER_ZIPCODE NUMBER (10),
  CUSTOMER_PHONE NUMBER (10)
);

COMMIT;

--INSERT SOME DATA!

INSERT INTO CUSTOMER

 
 --ACCOUNT ENTITY
 
CREATE TABLE ACCOUNT (
	ACCOUNT_ID NUMBER(10) NOT NULL PRIMARY KEY,
);

ALTER TABLE ACCOUNT
ADD CONSTRAINT FK_ACCOUNTCUSTOMER
FOREIGN KEY (CUSTOMER_ID)
REFERENCES CUSTOMER (CUSTOMER_ID);


--INSERT SOME DATA!

INSERT INTO ACCOUNT (ACCOUNT_ID)
VALUES (1);

INSERT INTO ACCOUNT (ACCOUNT_ID)
VALUES (2);


--ORDER ENTITY

CREATE TABLE CUSTOMER_ORDER (
	ORDER_ID NUMBER (10) NOT NULL PRIMARY KEY,
	ORDER_TOTAL DECIMAL (6,2),
	ORDER_DATE DATE
);

ALTER TABLE CUSTOMER_ORDER
ADD CONSTRAINT FK_CUSTOMER_ORDER_ACCOUNT
FOREIGN KEY (ACCOUNT_ID)
REFERENCES ACCOUNT (ACCOUNT_ID);

ALTER TABLE CUSTOMER_ORDER
ADD CONSTRAINT FK_CUSTOMER_ORDER_SHIP_SPEED
FOREIGN KEY (SHIPPING_SPEED_ID)
REFERENCES SHIPPING_SPEED (SHIPPING_SPEED_ID);


--ORDER_LINE_ITEM ENTITY

CREATE TABLE ORDER_LINE_ITEM (
	ORDER_LINE_ITEM_ID NUMBER (10) NOT NULL PRIMARY KEY,
	LINE_PRICE DECIMAL (6,2)
	PRODUCT_QUANTITY NUMBER (10)
);

ALTER TABLE ORDER_LINE_ITEM
ADD CONSTRAINT FK_ORDER_LINE_ITEM_PRODUCT
FOREIGN KEY (PRODUCT_ID)
REFERENCES PRODUCT (PRODUCT_ID);

ALTER TABLE ORDER_LINE_ITEM
ADD CONSTRAINT FK_ORDER_LINE_ITEM_CUS_ORDER
FOREIGN KEY (ORDER_ID)
REFERENCES CUSTOMER_ORDER (ORDER_ID);


-- SHIPMENT ENTITY

CREATE TABLE SHIPMENT (
	SHIPMENT_ID NUMBER (10) NOT NULL PRIMARY KEY,
	SHIPMENT_DATE DATE
);


--WAREHOUSE ENTITY

CREATE TABLE WAREHOUSE (
	WAREHOUSE_ID NUMBER(10) NOT NULL PRIMARY KEY,
	WAREHOUSE_ARRIVAL_DATE DATE,
	WAREHOUSE_DEPARTURE_DATE DATE
);

ALTER TABLE WAREHOUSE
ADD CONSTRAINT FK_WAREHOUSE_SHIPMENT
FOREIGN KEY (SHIPMENT_ID)
REFERENCES SHIPMENT (SHIPMENT_ID);

ALTER TABLE WAREHOUSE
ADD CONSTRAINT FK_WAREHOUSE_INVENTORY
FOREIGN KEY (INVENTORY_ID)
REFERENCES INVENTORY(INVENTORY_ID);




--ASPECT #1

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


--CREATE AND RUN QUERY
--PULL PRODUCTS IN “Computers” or “Electronics” categories that cost $30 or less
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

--ALL DONE IT WORKED!!


SELECT (product_price, product_name)
FROM PRODUCT
WHERE (product.category_id = 1, product.category_id = 2, product.product_price <30);
	

--DROP ALL TABLES AND DATA USE THE FOLLOWING CODE

DROP TABLE CASCADE CONSTRAINTS;

COMMIT;



--ASPECT #2
--Product Delivery – This aspect is based upon the Product Delivery Use Case in Section 1.
--a. Create the tables, constraints, and data needed to support product delivery as described in the use case.
--b. Develop a parameterized stored procedure that is used when any seller delivers any product to Amazon’s warehouse.
--c. A seller delivers four each of the two new products added in Aspect 1 (the self‐driving video camera and 
--the holographic keyboard). Invoke the stored procedure twice to update the inventory of these products 
--for a seller of your choosing.

UPDATE

--d. The seller from b above requests a listing of all of its products that have an inventory of 11 or
--less. Develop and execute a single query that provides this information (the self‐driving video
--camera and holographic keyboard should be among those listed).


--ASPECT #3
	
--New Customer Accounts – This aspect is based upon the New Customer Account Use Case in
--Section 1.
--a. Create the tables, constraints, and data needed to support customer accounts as described in the use case.
--b. Develop a parameterized stored procedure that is used when any new customer signs up for a
--new account on Amazon.
--c. You and your facilitator sign up for new accounts on Amazon. Invoke the stored procedure twice
--to add you and your facilitator as customers.
--d. For research purposes, Amazon requests the last names of customers where there are least 4
--accounts associated with the last name. Amazon would like to see the actual number of
--accounts associated with those last names. Develop and execute a single query that provides
--this information.
	
	
	
	
	
	
	
	
	
	
