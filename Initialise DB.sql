--Create all tables
CREATE TABLE CUSTOMER
(
    Cust_ID numeric(10) NOT NULL,
    Cust_FName varchar(50) NOT NULL,
    Cust_SName varchar(50) NOT NULL,
    Cust_Email varchar(50) NOT NULL,
    Cust_Phone varchar(50) NOT NULL,
    CONSTRAINT CUSTOMER_PK PRIMARY KEY (Cust_ID)
);

CREATE TABLE EMPLOYEE_TYPE
(
    Emp_Type_ID numeric(10) NOT NULL,
    Emp_Type_Description varchar(50) NOT NULL,
    CONSTRAINT EMPLOYEE_TYPE_PK PRIMARY KEY (Emp_Type_ID)
);

CREATE TABLE EMPLOYEE
(
    Emp_ID numeric(10) NOT NULL,
    Emp_Name varchar(50) NOT NULL,
    Emp_Date date NOT NULL,
    Emp_Standard_Rate varchar(50) NOT NULL,
    Emp_Overtime_Rate varchar(50) NOT NULL,
    Emp_Weekly_Hours numeric(10) NOT NULL,
    Emp_Manager_ID numeric(10),
    Emp_Type_ID numeric(10) NOT NULL,
    CONSTRAINT EMPLOYEE_PK PRIMARY KEY (Emp_ID),
    CONSTRAINT EMP_TYPE_FK FOREIGN KEY (Emp_Type_ID) REFERENCES EMPLOYEE_TYPE(Emp_Type_ID)
);

CREATE TABLE SUPPORT_TICKET
(
    Tic_ID numeric(10) NOT NULL,
    Tic_Date date NOT NULL,
    Tic_Status varchar(50) NOT NULL,
    CONSTRAINT SUPPORT_TICKET_PK PRIMARY KEY (Tic_ID),
    Emp_ID numeric(10),
    CONSTRAINT SUPP_EMPLOYEE_FK FOREIGN KEY (Emp_ID) REFERENCES EMPLOYEE(Emp_ID),
    Cust_ID numeric(10) NOT NULL,
    CONSTRAINT SUPP_CUSTOMER_FK FOREIGN KEY (Cust_ID) REFERENCES CUSTOMER(Cust_ID)
);

CREATE TABLE CUST_ADDRESS
(
    Cust_ID numeric(10) NOT NULL,
    CONSTRAINT ADD_CUSTOMER_FK FOREIGN KEY (Cust_ID) REFERENCES CUSTOMER(Cust_ID),
    Add_City varchar(50) NOT NULL,
    Add_Street varchar(50) NOT NULL,
    Add_StreetNr varchar(50) NOT NULL,
    Add_Suburb varchar(50) NOT NULL,
    Add_Province varchar(50) NOT NULL
);

CREATE TABLE PAYMENT
(
    Pay_ID numeric(10) NOT NULL,
    Pay_Ammount numeric(10) NOT NULL,
    Pay_Status varchar(50) NOT NULL,
    CONSTRAINT PAYMENT_PK PRIMARY KEY (Pay_ID),
    Cust_ID numeric(10) NOT NULL,
    CONSTRAINT PAY_CUSTOMER_FK FOREIGN KEY (Cust_ID) REFERENCES CUSTOMER(Cust_ID)
);

CREATE TABLE CUST_ORDER
(
    Order_ID numeric(10) NOT NULL,
    Order_Type varchar(50) NOT NULL,
    Pay_Confirmed varchar(50) NOT NULL,
    Pay_Date date NOT NULL,
    Order_Total numeric(10) NOT NULL,
    CONSTRAINT ORDER_PK PRIMARY KEY (Order_ID),
    Pay_ID numeric(10) NOT NULL,
    CONSTRAINT ORDER_PAYMENT_FK FOREIGN KEY (Pay_ID) REFERENCES PAYMENT(Pay_ID)
);

CREATE TABLE PARCEL
(
    Par_ID numeric(10) NOT NULL,
    Par_Date date NOT NULL,
    Par_TrackingNo varchar(50) NOT NULL,
    CONSTRAINT PARCEL_PK PRIMARY KEY (Par_ID),
    Order_ID numeric(10) NOT NULL,
    CONSTRAINT PARCEL_CUST_ORDER_FK FOREIGN KEY (Order_ID) REFERENCES CUST_ORDER(Order_ID)
);

CREATE TABLE PRODUCT_CATEGORY
(
    Category_ID numeric(10) NOT NULL,
    Category_Name varchar(50) NOT NULL,
    CONSTRAINT CATEGORY_PK PRIMARY KEY (Category_ID)
);

CREATE TABLE PRODUCT
(
    Product_ID numeric(10) NOT NULL,
    Product_Name varchar(50) NOT NULL,
    Product_Weight numeric(10) NOT NULL,
    Product_Price numeric(10) NOT NULL,
    Product_Quantity numeric(10) NOT NULL,
    CONSTRAINT PRODUCT_PK PRIMARY KEY (Product_ID),
    Category_ID numeric(10) NOT NULL,
    CONSTRAINT PROD_CATEGORY_FK FOREIGN KEY (Category_ID) REFERENCES PRODUCT_CATEGORY(Category_ID)

);

CREATE TABLE SUPPLIER
(
    Supplier_ID numeric(10) NOT NULL,
    Order_Date date NOT NULL,
    CONSTRAINT SUPPLIER_PK PRIMARY KEY (Supplier_ID),
    Product_ID numeric(10) NOT NULL,
    CONSTRAINT SUPPLIER_PRODUCT_FK FOREIGN KEY (Product_ID) REFERENCES PRODUCT(Product_id)
);

CREATE TABLE ORDER_CONTENT
(
    Order_ID numeric(10) NOT NULL,
    CONSTRAINT CONTENT_CUST_ORDER_FK FOREIGN KEY (Order_ID) REFERENCES CUST_ORDER(Order_ID),
    Product_ID numeric(10) NOT NULL,
    CONSTRAINT CONTENT_PROD_FK FOREIGN KEY (Product_ID) REFERENCES PRODUCT(Product_ID)
);

--Sequences
CREATE SEQUENCE "Cust_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Emp_Type_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Emp_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Tic_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Pay_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Order_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Par_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Category_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Product_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

CREATE SEQUENCE "Supplier_ID_SEQ"
MINVALUE 1 MAXVALUE 999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

--Views
CREATE OR REPLACE VIEW Open_Unasigned_Tickets AS
SELECT * FROM SUPPORT_TICKET
WHERE Emp_ID IS NULL AND Tic_Status = 'Open';

CREATE OR REPLACE VIEW MANAGERS AS
SELECT Emp_ID, Emp_Name FROM EMPLOYEE
WHERE Emp_Manager_ID IS NOT NULL;

CREATE OR REPLACE VIEW COMPLETED_PAYMENTS AS
SELECT * FROM PAYMENT
WHERE Pay_Status = 'Confirmed';

CREATE OR REPLACE VIEW Customer_Service AS
SELECT Emp_Name FROM EMPLOYEE
WHERE Emp_Type_ID = 1;

CREATE OR REPLACE VIEW NO_STOCK AS
SELECT * FROM PRODUCT
WHERE Product_Quantity = 0;

--Input Data
--CUSTOMER
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (1, 'Kalli', 'Clubley', 'kclubley0@liveinternet.ru', '+2768910883');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (2, 'Meir', 'Orfeur', 'morfeur1@usnews.com', '+2765094608');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (3, 'Bordy', 'Habbershon', 'bhabbershon2@google.com.au', '+2771293604');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (4, 'Paolina', 'Monks', 'pmonks3@sitemeter.com', '+2793285756');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (5, 'Hayley', 'Saltman', 'hsaltman4@wp.com', '+2767887178');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (6, 'Anatole', 'Jessel', 'ajessel5@sbwire.com', '+2703787263');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (7, 'Audrey', 'Pinckard', 'apinckard6@xrea.com', '+2761791411');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (8, 'Nero', 'Lorey', 'nlorey7@uol.com.br', '+2717307002');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (9, 'Marchelle', 'Dahlen', 'mdahlen8@soup.io', '+2748615345');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (10, 'Darrelle', 'Feasey', 'dfeasey9@examiner.com', '+2795427783');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (11, 'Kendell', 'Cowthart', 'kcowtharta@ameblo.jp', '+2791810577');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (12, 'Janina', 'Aldis', 'jaldisb@shutterfly.com', '+2707144111');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (13, 'Phil', 'Barlas', 'pbarlasc@hhs.gov', '+2757889581');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (14, 'Robinette', 'Jellyman', 'rjellymand@google.pl', '+2762376334');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (15, 'Bayard', 'Carryer', 'bcarryere@liveinternet.ru', '+2725559412');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (16, 'Rhetta', 'Assel', 'rasself@about.me', '+2769120632');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (17, 'Reade', 'Borth', 'rborthg@imgur.com', '+2767182007');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (18, 'Debbi', 'Angliss', 'danglissh@zimbio.com', '+2769498179');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (19, 'Merola', 'Powder', 'mpowderi@cmu.edu', '+2747754794');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (20, 'Neala', 'Vasilyonok', 'nvasilyonokj@opensource.org', '+2769478904');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (21, 'Jillene', 'Futcher', 'jfutcherk@blog.com', '+2761362957');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (22, 'Clerkclaude', 'Emilien', 'cemilienl@i2i.jp', '+2709319311');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (23, 'Jaquenette', 'Hagard', 'jhagardm@tmall.com', '+2707767475');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (24, 'Sascha', 'Scroyton', 'sscroytonn@sbwire.com', '+2701831075');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (25, 'Cecilius', 'Carlet', 'ccarleto@posterous.com', '+2759133161');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (26, 'Ingaberg', 'Colisbe', 'icolisbep@livejournal.com', '+2793502575');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (27, 'Malinda', 'Lonsbrough', 'mlonsbroughq@adobe.com', '+2791603401');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (28, 'Adi', 'Bissill', 'abissillr@ebay.co.uk', '+2767182046');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (29, 'Putnem', 'Limpricht', 'plimprichts@google.com.hk', '+2725600965');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (30, 'Haroun', 'Garthside', 'hgarthsidet@t.co', '+2796012465');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (31, 'Obadiah', 'Wraith', 'owraithu@ebay.com', '+2714072076');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (32, 'Tim', 'Summersett', 'tsummersettv@usda.gov', '+2791109497');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (33, 'Vannie', 'Sambidge', 'vsambidgew@dailymotion.com', '+2787594474');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (34, 'Kilian', 'Crusham', 'kcrushamx@yale.edu', '+2747815173');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (35, 'Codi', 'Eslemont', 'ceslemonty@salon.com', '+2711278943');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (36, 'Brook', 'Cowlas', 'bcowlasz@icio.us', '+2764621554');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (37, 'Paulo', 'Le Noury', 'plenoury10@mozilla.com', '+2776153815');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (38, 'Charles', 'Fossick', 'cfossick11@nasa.gov', '+2779162114');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (39, 'Monika', 'Orae', 'morae12@ucsd.edu', '+2744246351');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (40, 'Yank', 'Caroline', 'ycaroline13@nbcnews.com', '+2754416516');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (41, 'Mord', 'Daingerfield', 'mdaingerfield14@aboutads.info', '+2721004602');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (42, 'Opalina', 'Bartaloni', 'obartaloni15@usatoday.com', '+2758736259');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (43, 'Trina', 'Madrell', 'tmadrell16@photobucket.com', '+2706530139');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (44, 'Melvin', 'Curtain', 'mcurtain17@qq.com', '+2731030228');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (45, 'Garnette', 'Boylan', 'gboylan18@yahoo.co.jp', '+2776623245');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (46, 'Stewart', 'Halsworth', 'shalsworth19@hibu.com', '+2765616164');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (47, 'Penelopa', 'Morstatt', 'pmorstatt1a@fema.gov', '+2703617325');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (48, 'Leonie', 'Snowding', 'lsnowding1b@gizmodo.com', '+2747699854');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (49, 'Odessa', 'Redit', 'oredit1c@ycombinator.com', '+2714284902');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (50, 'Kale', 'Strover', 'kstrover1d@paginegialle.it', '+2714788728');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (51, 'Corny', 'Scardafield', 'cscardafield1e@oakley.com', '+2724927040');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (52, 'Farleigh', 'Robecon', 'frobecon1f@google.it', '+2795135973');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (53, 'Carolus', 'Galego', 'cgalego1g@photobucket.com', '+2705866266');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (54, 'Godfry', 'Leggs', 'gleggs1h@ca.gov', '+2757923021');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (55, 'Dyan', 'Brickham', 'dbrickham1i@deliciousdays.com', '+2708580892');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (56, 'Steffie', 'Phil', 'sphil1j@oakley.com', '+2796185282');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (57, 'Shellysheldon', 'Parmiter', 'sparmiter1k@un.org', '+2793764036');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (58, 'Wayne', 'Hallifax', 'whallifax1l@smh.com.au', '+2793011676');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (59, 'Gratia', 'Overil', 'goveril1m@nytimes.com', '+2767823056');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (60, 'Anica', 'McIlroy', 'amcilroy1n@jimdo.com', '+2731944636');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (61, 'Sauncho', 'Flood', 'sflood1o@gizmodo.com', '+2739805228');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (62, 'Matthus', 'Braunston', 'mbraunston1p@sbwire.com', '+2778721514');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (63, 'Blondie', 'Mallabar', 'bmallabar1q@comsenz.com', '+2794691873');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (64, 'Ellen', 'Ivashintsov', 'eivashintsov1r@storify.com', '+2784218942');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (65, 'Whitney', 'Midgley', 'wmidgley1s@instagram.com', '+2762174749');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (66, 'Casey', 'Fetherstonhaugh', 'cfetherstonhaugh1t@de.vu', '+2724320474');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (67, 'Tremaine', 'Hassey', 'thassey1u@networksolutions.com', '+2759164772');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (68, 'Sterne', 'Pech', 'spech1v@shareasale.com', '+2744968261');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (69, 'Ronnica', 'Ridewood', 'rridewood1w@purevolume.com', '+2739697592');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (70, 'Dale', 'Troop', 'dtroop1x@foxnews.com', '+2739275317');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (71, 'Darin', 'Touret', 'dtouret1y@lulu.com', '+2768882655');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (72, 'Bunnie', 'Zanneli', 'bzanneli1z@indiatimes.com', '+2711105400');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (73, 'Tiena', 'Jumeau', 'tjumeau20@trellian.com', '+2731771230');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (74, 'Cynde', 'Pagett', 'cpagett21@ycombinator.com', '+2707893335');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (75, 'Gabby', 'Eshelby', 'geshelby22@digg.com', '+2717231873');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (76, 'Keary', 'Issacof', 'kissacof23@apache.org', '+2784864271');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (77, 'Odo', 'Calvie', 'ocalvie24@army.mil', '+2741466783');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (78, 'Kimmi', 'Durrell', 'kdurrell25@webmd.com', '+2754466475');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (79, 'Maura', 'Paolo', 'mpaolo26@oakley.com', '+2729280698');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (80, 'Vivian', 'Palffrey', 'vpalffrey27@slate.com', '+2771309182');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (81, 'Whitby', 'Morrallee', 'wmorrallee28@clickbank.net', '+2753897602');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (82, 'Winona', 'Martelet', 'wmartelet29@bravesites.com', '+2769633728');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (83, 'Veronica', 'Tague', 'vtague2a@privacy.gov.au', '+2793284724');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (84, 'Curr', 'Stailey', 'cstailey2b@google.es', '+2732431724');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (85, 'Alina', 'Midgely', 'amidgely2c@house.gov', '+2756703651');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (86, 'Irv', 'Priddy', 'ipriddy2d@comsenz.com', '+2796063138');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (87, 'Thibaud', 'Yorston', 'tyorston2e@hibu.com', '+2713995986');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (88, 'Tamarra', 'Luker', 'tluker2f@1und1.de', '+2711813619');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (89, 'Sada', 'Epsley', 'sepsley2g@foxnews.com', '+2788069125');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (90, 'Betsey', 'Selley', 'bselley2h@linkedin.com', '+2781418798');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (91, 'Bryana', 'Geeritz', 'bgeeritz2i@timesonline.co.uk', '+2761822269');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (92, 'Kendell', 'Cranmor', 'kcranmor2j@elegantthemes.com', '+2765095261');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (93, 'Ailey', 'Yousef', 'ayousef2k@smugmug.com', '+2714986505');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (94, 'Ilyse', 'Inchboard', 'iinchboard2l@elpais.com', '+2701070605');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (95, 'Karl', 'Grand', 'kgrand2m@cyberchimps.com', '+2752480507');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (96, 'Keen', 'Spencook', 'kspencook2n@auda.org.au', '+2702329595');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (97, 'Lilli', 'Agates', 'lagates2o@jugem.jp', '+2762570467');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (98, 'Lucky', 'Dalling', 'ldalling2p@webmd.com', '+2792067635');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (99, 'Tyrus', 'Bannard', 'tbannard2q@posterous.com', '+2754442570');
INSERT INTO CUSTOMER (Cust_ID, Cust_FName, Cust_SName, Cust_Email, Cust_Phone) VALUES (100, 'Kippar', 'Alves', 'kalves2r@macromedia.com', '+2774449978');

--EMP_TYPE
INSERT INTO EMPLOYEE_TYPE (Emp_Type_ID, Emp_Type_Description) VALUES (1, 'Customer Service');
INSERT INTO EMPLOYEE_TYPE (Emp_Type_ID, Emp_Type_Description) VALUES (2, 'Finance');
INSERT INTO EMPLOYEE_TYPE (Emp_Type_ID, Emp_Type_Description) VALUES (3, 'Logistics');
INSERT INTO EMPLOYEE_TYPE (Emp_Type_ID, Emp_Type_Description) VALUES (4, 'Warehouse Controller');
INSERT INTO EMPLOYEE_TYPE (Emp_Type_ID, Emp_Type_Description) VALUES (5, 'Human Resouces');
INSERT INTO EMPLOYEE_TYPE (Emp_Type_ID, Emp_Type_Description) VALUES (6, 'Sales');

--EMPLOYEE
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (1, 'Oliviero', '19-May-2021', 26.38, 39.86, 34, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (2, 'Pavla', '13-Dec-2021', 25.05, 39.55, 41, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (3, 'Lindsey', '15-Apr-2021', 28.29, 39.31, 43, NULL, 2);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (4, 'Delmar', '12-May-2021', 26.83, 35.66, 30, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (5, 'Erica', '14-May-2021', 29.0, 39.43, 41, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (6, 'Britte', '09-Mar-2022', 29.29, 36.24, 32, NULL, 5);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (7, 'Camila', '30-Apr-2022', 26.32, 35.41, 38, 7, 5);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (8, 'Rice', '17-Sep-2021', 28.91, 36.51, 43, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (9, 'Kelcy', '24-Sep-2021', 27.63, 35.23, 31, NULL, 4);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (10, 'Boote', '29-Oct-2021', 27.48, 36.77, 40, NULL, 5);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (11, 'Aharon', '31-Mar-2022', 27.3, 37.77, 30, NULL, 4);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (12, 'Georgeanne', '10-Feb-2021', 29.79, 38.25, 35, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (13, 'Myca', '25-Jan-2021', 29.97, 37.04, 42, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (14, 'Deerdre', '28-Jan-2022', 28.99, 39.49, 37, 14, 5);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (15, 'Grover', '16-Mar-2022', 27.78, 39.8, 42, NULL, 4);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (16, 'Broddy', '26-Nov-2021', 29.13, 39.94, 38, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (17, 'Sherlock', '25-Mar-2022', 29.95, 36.07, 45, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (18, 'Aron', '13-Dec-2021', 28.11, 35.41, 38, 18, 2);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (19, 'Dixie', '19-Mar-2021', 29.95, 37.74, 40, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (20, 'Darren', '17-Sep-2021', 27.37, 35.08, 38, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (21, 'Beale', '06-Mar-2021', 27.03, 38.38, 34, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (22, 'Maible', '05-Apr-2022', 28.51, 39.01, 38, 22, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (23, 'Merlina', '07-Jan-2021', 25.84, 35.77, 38, NULL, 5);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (24, 'Nanny', '04-Feb-2021', 25.95, 37.96, 31, NULL, 4);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (25, 'Kial', '29-Oct-2021', 26.37, 36.06, 40, NULL, 5);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (26, 'Tally', '05-Mar-2021', 26.4, 39.34, 38, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (27, 'Bryanty', '11-Oct-2021', 25.86, 35.33, 33, NULL, 4);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (28, 'Oran', '13-Feb-2021', 27.16, 37.84, 37, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (29, 'Sloan', '08-Jun-2021', 29.88, 37.85, 40, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (30, 'Florenza', '15-Jan-2021', 27.59, 38.98, 32, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (31, 'Stephanie', '01-Feb-2021', 28.84, 38.07, 43, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (32, 'Godfry', '23-May-2021', 29.5, 35.59, 30, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (33, 'Myrna', '09-Feb-2021', 27.97, 36.73, 32, NULL, 2);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (34, 'Alicia', '13-Jan-2022', 26.19, 37.29, 30, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (35, 'Phyllis', '26-Jul-2021', 29.88, 39.25, 45, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (36, 'Izabel', '07-Oct-2021', 28.8, 38.54, 30, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (37, 'Carissa', '07-Mar-2022', 29.35, 35.86, 35, NULL, 5);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (38, 'Katharina', '27-Mar-2022', 27.17, 38.99, 45, 38, 2);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (39, 'Cherianne', '05-Jun-2021', 28.63, 38.63, 32, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (40, 'Jasmin', '17-Sep-2021', 27.96, 35.8, 45, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (41, 'Ethelin', '26-Jun-2021', 25.45, 35.19, 34, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (42, 'Cilka', '10-Feb-2021', 29.6, 38.89, 38, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (43, 'Charline', '08-Jan-2021', 26.37, 37.57, 31, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (44, 'Cecil', '11-Jun-2021', 28.41, 37.6, 34, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (45, 'Noami', '19-Feb-2021', 28.52, 38.32, 37, NULL, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (46, 'Albertina', '05-Jan-2021', 29.03, 35.78, 35, NULL, 3);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (47, 'Marijn', '11-Oct-2021', 26.06, 36.05, 44, 47, 6);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (48, 'Hall', '16-Sep-2021', 29.84, 35.48, 45, 48, 5);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (49, 'Haydon', '02-Feb-2021', 28.95, 37.24, 31, NULL, 1);
INSERT INTO EMPLOYEE (Emp_ID, Emp_Name, Emp_Date, Emp_Standard_Rate, Emp_Overtime_Rate, Emp_Weekly_Hours, Emp_Manager_ID, Emp_Type_ID) VALUES (50, 'Georgianne', '23-Jun-2021', 26.81, 39.42, 43, NULL, 6);

--SUPPORT_TICKET
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (1, '15-Feb-2021', 'Closed', 35, 6);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (2, '26-Nov-2021', 'Closed', 13, 79);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (3, '16-Jun-2021', 'Closed', 22, 5);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (4, '13-Jan-2021', 'Open', NULL, 51);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (5, '13-Jun-2021', 'Closed', NULL, 80);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (6, '04-Jun-2021', 'Open', NULL, 57);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (7, '03-Jun-2021', 'Closed', 22, 55);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (8, '10-Apr-2021', 'Open', 49, 82);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (9, '07-Jan-2022', 'Closed', NULL, 71);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (10, '27-Jun-2021', 'Closed', 36, 94);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (11, '09-Feb-2022', 'Closed', NULL, 25);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (12, '29-Jun-2021', 'Open', 27, 65);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (13, '26-Mar-2021', 'Closed', NULL, 86);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (14, '12-Apr-2022', 'Open', 20, 72);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (15, '19-Jan-2021', 'Closed', 13, 56);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (16, '22-Apr-2021', 'Open', NULL, 46);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (17, '09-Jan-2021', 'Open', 24, 19);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (18, '08-Dec-2021', 'Closed', NULL, 42);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (19, '08-Feb-2021', 'Open', 15, 48);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (20, '16-Jun-2021', 'Open', 1, 8);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (21, '17-May-2022', 'Closed', NULL, 37);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (22, '24-Jan-2021', 'Closed', 38, 40);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (23, '14-Jul-2021', 'Closed', 3, 10);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (24, '10-Mar-2021', 'Closed', 40, 80);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (25, '11-Jan-2021', 'Closed', NULL, 54);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (26, '08-Sep-2021', 'Closed', NULL, 24);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (27, '20-Jan-2022', 'Closed', NULL, 88);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (28, '31-Jan-2022', 'Closed', 2, 69);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (29, '02-May-2021', 'Closed', NULL, 84);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (30, '24-Oct-2021', 'Closed', 1, 20);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (31, '25-Jul-2021', 'Closed', 19, 38);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (32, '31-Mar-2021', 'Closed', 23, 46);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (33, '03-Jan-2022', 'Closed', 45, 52);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (34, '30-Mar-2022', 'Closed', 34, 76);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (35, '01-Jun-2021', 'Closed', NULL, 53);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (36, '16-Sep-2021', 'Closed', 47, 12);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (37, '27-Aug-2021', 'Open', NULL, 89);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (38, '19-Apr-2022', 'Closed', NULL, 10);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (39, '09-Apr-2022', 'Open', 30, 26);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (40, '31-Dec-2021', 'Closed', NULL, 83);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (41, '03-May-2022', 'Open', 28, 6);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (42, '17-May-2021', 'Closed', NULL, 79);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (43, '06-Jan-2022', 'Open', NULL, 82);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (44, '25-Mar-2021', 'Closed', NULL, 24);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (45, '27-Apr-2021', 'Closed', 1, 73);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (46, '13-Mar-2022', 'Closed', 16, 50);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (47, '23-Nov-2021', 'Open', 28, 60);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (48, '22-Jan-2022', 'Closed', NULL, 19);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (49, '14-Jun-2021', 'Open', 30, 53);
INSERT INTO SUPPORT_TICKET (Tic_ID, Tic_Date, Tic_Status, Emp_ID, Cust_ID) VALUES (50, '29-Nov-2021', 'Closed', 11, 34);

--CUST_ADDRESS
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (1, 'Vereeniging', 'Village Green', '73778', 7154, 'Limpopo');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (2, 'Kimberly', 'Del Mar', '94435', 8248, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (3, 'Kimberly', 'Sycamore', '661', 3596, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (4, 'Paarl', 'Aberg', '5650', 4572, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (5, 'Potchefstroom', 'Maryland', '53', 3556, 'North West');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (6, 'Paarl', 'Golden Leaf', '2', 7411, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (7, 'Kimberly', 'Daystar', '166', 3790, 'North West');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (8, 'Kimberly', 'Schlimgen', '51', 1285, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (9, 'Paarl', 'Fulton', '9', 7622, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (10, 'Paarl', 'Clove', '5', 5724, 'North West');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (11, 'Paarl', 'Fieldstone', '47', 3953, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (12, 'Kimberly', 'Alpine', '09', 7303, 'Mpumalanga');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (13, 'Kimberly', 'Center', '23', 5182, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (14, 'Kimberly', 'Dennis', '03063', 4165, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (15, 'Paarl', '7th', '262', 7217, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (16, 'Paarl', 'Mariners Cove', '5', 3480, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (17, 'Paarl', 'Hoard', '67065', 2874, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (18, 'Paarl', 'Lotheville', '02', 1153, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (19, 'Paarl', 'Esch', '287', 4365, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (20, 'Kimberly', 'Delaware', '533', 3203, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (21, 'Kimberly', 'Paget', '18930', 4803, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (22, 'Kimberly', 'Lien', '7', 7404, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (23, 'Paarl', 'Carey', '3', 1823, 'North West');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (24, 'Paarl', 'Grover', '80', 1599, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (25, 'Paarl', 'Twin Pines', '531', 6192, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (26, 'Kimberly', 'Kedzie', '102', 8766, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (27, 'Kimberly', 'Lighthouse Bay', '093', 2421, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (28, 'Newcastle', 'Leroy', '9943', 6900, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (29, 'Paarl', 'Ronald Regan', '49', 9810, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (30, 'Paarl', 'American Ash', '38', 2805, 'North West');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (31, 'Paarl', 'Caliangt', '18754', 3528, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (32, 'Polokwane', 'Bellgrove', '4', 8074, 'Mpumalanga');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (33, 'Paarl', 'Dawn', '667', 7796, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (34, 'Paarl', 'Reindahl', '34', 8420, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (35, 'Secunda', 'Clyde Gallagher', '40645', 2771, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (36, 'Kimberly', 'Daystar', '1876', 5605, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (37, 'Paarl', 'Westport', '0', 2980, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (38, 'Potchefstroom', 'Marcy', '5663', 7812, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (39, 'Kimberly', 'Eliot', '6421', 8690, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (40, 'Potchefstroom', 'Graedel', '2', 8914, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (41, 'Paarl', 'Coleman', '8', 6557, 'Mpumalanga');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (42, 'Paarl', 'Farragut', '6', 3735, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (43, 'Paarl', 'Kipling', '6', 2480, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (44, 'Paarl', 'Clyde Gallagher', '516', 8427, 'Limpopo');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (45, 'Paarl', 'Waywood', '0830', 1102, 'Western Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (46, 'Secunda', '5th', '6', 3961, 'North West');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (47, 'Paarl', 'Coleman', '2', 1958, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (48, 'Kimberly', 'Anniversary', '32599', 3849, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (49, 'Paarl', 'Thompson', '15509', 2216, 'Northen Cape');
INSERT INTO CUST_ADDRESS (Cust_ID, Add_City, Add_Street, Add_StreetNr, Add_Suburb, Add_Province) VALUES (50, 'Paarl', 'Old Shore', '09', 8928, 'Western Cape');

--PAYMENT
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (1, 3995.1, 'In Progress', 8);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (2, 2284.65, 'In Progress', 38);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (3, 1860.6, 'In Progress', 14);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (4, 228.57, 'Cancelled', 38);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (5, 747.71, 'Cancelled', 51);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (6, 851.11, 'In Progress', 29);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (7, 3801.19, 'In Progress', 49);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (8, 2559.34, 'Cancelled', 88);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (9, 3512.0, 'Cancelled', 12);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (10, 3857.98, 'Cancelled', 99);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (11, 1683.6, 'Confirmed', 66);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (12, 1241.85, 'Cancelled', 84);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (13, 273.6, 'Cancelled', 10);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (14, 3433.39, 'Cancelled', 78);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (15, 1711.14, 'In Progress', 63);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (16, 2184.7, 'Confirmed', 10);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (17, 2552.52, 'Confirmed', 94);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (18, 4510.32, 'In Progress', 13);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (19, 2292.12, 'In Progress', 74);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (20, 3290.2, 'Confirmed', 74);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (21, 714.41, 'Cancelled', 60);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (22, 3300.43, 'In Progress', 98);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (23, 4482.16, 'Cancelled', 29);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (24, 2041.64, 'Cancelled', 94);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (25, 3784.14, 'Cancelled', 38);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (26, 4047.59, 'In Progress', 87);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (27, 1790.77, 'Cancelled', 11);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (28, 1871.99, 'Confirmed', 6);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (29, 4880.67, 'Cancelled', 58);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (30, 231.35, 'Confirmed', 72);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (31, 1761.27, 'Cancelled', 75);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (32, 459.83, 'Confirmed', 86);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (33, 842.21, 'Confirmed', 9);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (34, 134.44, 'Cancelled', 70);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (35, 1207.69, 'Cancelled', 68);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (36, 2671.38, 'Cancelled', 84);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (37, 256.37, 'Cancelled', 91);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (38, 2381.83, 'In Progress', 31);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (39, 4660.74, 'Confirmed', 31);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (40, 1323.67, 'In Progress', 32);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (41, 3647.6, 'Cancelled', 11);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (42, 4242.31, 'Cancelled', 76);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (43, 3484.02, 'Cancelled', 12);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (44, 1452.69, 'Cancelled', 15);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (45, 81.8, 'Cancelled', 34);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (46, 4368.85, 'Cancelled', 15);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (47, 3621.23, 'Cancelled', 56);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (48, 1240.14, 'Confirmed', 93);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (49, 570.16, 'Cancelled', 99);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (50, 1904.66, 'Confirmed', 13);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (51, 3758.23, 'In Progress', 72);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (52, 1502.77, 'Cancelled', 3);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (53, 3033.22, 'In Progress', 37);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (54, 4723.03, 'Confirmed', 25);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (55, 2375.17, 'Confirmed', 7);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (56, 1808.96, 'In Progress', 8);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (57, 2702.11, 'Cancelled', 9);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (58, 4668.08, 'Confirmed', 81);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (59, 2131.26, 'Confirmed', 83);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (60, 3363.89, 'Cancelled', 27);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (61, 1928.37, 'Confirmed', 69);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (62, 3493.85, 'Cancelled', 72);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (63, 2274.66, 'In Progress', 9);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (64, 740.16, 'In Progress', 6);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (65, 2538.17, 'Cancelled', 24);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (66, 2306.21, 'In Progress', 2);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (67, 1521.62, 'Cancelled', 71);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (68, 4167.88, 'Cancelled', 64);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (69, 3359.52, 'In Progress', 86);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (70, 1683.51, 'Cancelled', 29);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (71, 3740.99, 'Cancelled', 66);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (72, 4694.2, 'Confirmed', 100);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (73, 931.47, 'Cancelled', 86);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (74, 1715.13, 'Confirmed', 67);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (75, 4940.89, 'Cancelled', 65);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (76, 2682.89, 'Cancelled', 99);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (77, 2389.91, 'In Progress', 99);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (78, 4589.91, 'Cancelled', 19);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (79, 268.33, 'Confirmed', 86);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (80, 1146.23, 'Cancelled', 80);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (81, 4401.76, 'Confirmed', 78);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (82, 3300.39, 'Cancelled', 15);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (83, 4936.11, 'Cancelled', 90);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (84, 3543.76, 'Cancelled', 46);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (85, 2438.54, 'Cancelled', 49);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (86, 4180.47, 'In Progress', 97);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (87, 4555.23, 'Cancelled', 67);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (88, 2890.04, 'Confirmed', 54);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (89, 3504.16, 'Confirmed', 61);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (90, 2336.81, 'Cancelled', 86);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (91, 339.04, 'Confirmed', 41);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (92, 2198.22, 'Cancelled', 51);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (93, 4121.35, 'Confirmed', 26);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (94, 2148.53, 'Cancelled', 83);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (95, 2135.9, 'In Progress', 30);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (96, 4295.9, 'In Progress', 81);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (97, 3778.67, 'Cancelled', 59);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (98, 1122.74, 'In Progress', 25);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (99, 4991.38, 'Confirmed', 3);
INSERT INTO PAYMENT (Pay_ID, Pay_Ammount, Pay_Status, Cust_ID) VALUES (100, 326.77, 'Cancelled', 73);

--CUST_ORDER
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (1, 'Customer', 'Confrmed', '13-Aug-2021', 1470.2, 71);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (2, 'Customer', 'In Progress', '17-Apr-2021', 1634.1, 62);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (3, 'Customer', 'In Progress', '18-May-2022', 1821.21, 34);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (4, 'Customer', 'In Progress', '22-May-2021', 1040.2, 3);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (5, 'Customer', 'Confrmed', '16-Feb-2021', 3715.44, 29);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (6, 'Customer', 'In Progress', '11-Mar-2022', 1142.95, 79);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (7, 'Customer', 'In Progress', '07-Jan-2022', 1765.48, 28);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (8, 'Customer', 'In Progress', '17-Feb-2022', 1253.37, 6);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (9, 'Customer', 'Confrmed', '09-Feb-2021', 1018.88, 42);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (10, 'Customer', 'In Progress', '06-Apr-2021', 2209.5, 70);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (11, 'Customer', 'In Progress', '05-Jan-2022', 100.57, 8);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (12, 'Customer', 'In Progress', '24-Jan-2022', 2287.36, 72);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (13, 'Customer', 'In Progress', '22-Sep-2021', 4784.06, 45);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (14, 'Customer', 'In Progress', '24-Feb-2021', 1039.05, 97);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (15, 'Customer', 'In Progress', '16-Jul-2021', 291.67, 2);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (16, 'Customer', 'Confrmed', '27-Dec-2021', 1817.53, 47);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (17, 'Customer', 'Confrmed', '08-Jul-2021', 261.86, 67);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (18, 'Customer', 'In Progress', '01-May-2022', 4210.21, 3);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (19, 'Customer', 'In Progress', '13-Jan-2021', 4612.82, 9);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (20, 'Customer', 'In Progress', '28-Nov-2021', 4758.1, 9);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (21, 'Customer', 'In Progress', '26-Feb-2022', 3496.71, 49);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (22, 'Customer', 'In Progress', '08-Aug-2021', 3744.98, 35);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (23, 'Customer', 'Confrmed', '31-Oct-2021', 1935.82, 1);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (24, 'Customer', 'Confrmed', '01-Feb-2021', 3785.07, 8);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (25, 'Customer', 'In Progress', '16-Nov-2021', 708.34, 97);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (26, 'Customer', 'In Progress', '15-Aug-2021', 622.22, 66);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (27, 'Customer', 'In Progress', '01-May-2021', 1298.66, 54);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (28, 'Customer', 'Confrmed', '22-Mar-2021', 3864.66, 8);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (29, 'Customer', 'In Progress', '30-Oct-2021', 4387.03, 51);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (30, 'Customer', 'Confrmed', '05-Aug-2021', 991.24, 36);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (31, 'Customer', 'Confrmed', '27-Mar-2021', 1449.64, 50);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (32, 'Customer', 'Confrmed', '24-Mar-2021', 4310.72, 93);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (33, 'Customer', 'Confrmed', '24-Jan-2022', 85.77, 74);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (34, 'Customer', 'Confrmed', '07-Mar-2022', 1162.54, 8);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (35, 'Customer', 'In Progress', '22-May-2021', 4577.27, 27);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (36, 'Customer', 'Confrmed', '19-Mar-2022', 1609.03, 22);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (37, 'Customer', 'In Progress', '19-Mar-2021', 2324.13, 86);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (38, 'Customer', 'In Progress', '21-Jan-2022', 1064.81, 23);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (39, 'Customer', 'In Progress', '16-Jan-2022', 1571.99, 27);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (40, 'Customer', 'In Progress', '05-Nov-2021', 3428.22, 48);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (41, 'Customer', 'In Progress', '12-May-2022', 3907.32, 56);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (42, 'Customer', 'In Progress', '07-Mar-2021', 4508.58, 17);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (43, 'Customer', 'Confrmed', '10-May-2022', 4654.82, 34);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (44, 'Customer', 'In Progress', '27-Jan-2022', 2383.41, 85);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (45, 'Customer', 'Confrmed', '24-Nov-2021', 1623.19, 84);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (46, 'Customer', 'In Progress', '13-Sep-2021', 4129.43, 30);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (47, 'Customer', 'Confrmed', '23-Sep-2021', 1166.44, 67);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (48, 'Customer', 'In Progress', '14-Jul-2021', 3592.64, 6);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (49, 'Customer', 'In Progress', '19-Jul-2021', 1239.7, 52);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (50, 'Customer', 'In Progress', '12-Mar-2021', 2003.81, 65);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (51, 'Customer', 'Confrmed', '08-Dec-2021', 3885.38, 88);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (52, 'Customer', 'Confrmed', '01-Jul-2021', 4335.57, 66);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (53, 'Customer', 'Confrmed', '08-Dec-2021', 2638.04, 55);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (54, 'Customer', 'In Progress', '24-Oct-2021', 2186.52, 45);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (55, 'Customer', 'In Progress', '07-Apr-2022', 4954.31, 72);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (56, 'Customer', 'In Progress', '26-May-2022', 3503.09, 80);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (57, 'Customer', 'Confrmed', '23-Oct-2021', 4708.59, 57);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (58, 'Customer', 'In Progress', '11-Jun-2021', 3480.03, 21);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (59, 'Customer', 'Confrmed', '18-Jan-2022', 3199.22, 67);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (60, 'Customer', 'In Progress', '18-May-2022', 236.44, 26);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (61, 'Customer', 'In Progress', '25-Jan-2022', 3648.92, 98);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (62, 'Customer', 'Confrmed', '26-Mar-2021', 481.3, 58);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (63, 'Customer', 'Confrmed', '23-Apr-2021', 1895.78, 17);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (64, 'Customer', 'In Progress', '25-Apr-2022', 1604.63, 74);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (65, 'Customer', 'In Progress', '29-Nov-2021', 2218.71, 28);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (66, 'Customer', 'In Progress', '14-Apr-2021', 3898.3, 74);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (67, 'Customer', 'Confrmed', '10-Jul-2021', 1567.27, 81);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (68, 'Customer', 'In Progress', '17-May-2021', 4639.09, 9);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (69, 'Customer', 'Confrmed', '01-Feb-2021', 3029.21, 49);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (70, 'Customer', 'In Progress', '29-Nov-2021', 4267.23, 62);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (71, 'Customer', 'In Progress', '18-Feb-2021', 665.55, 62);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (72, 'Customer', 'Confrmed', '21-Nov-2021', 292.41, 38);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (73, 'Customer', 'Confrmed', '19-Dec-2021', 324.96, 29);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (74, 'Customer', 'Confrmed', '31-Jan-2022', 147.67, 59);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (75, 'Customer', 'In Progress', '28-Nov-2021', 4489.27, 23);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (76, 'Customer', 'Confrmed', '02-Apr-2022', 4380.98, 95);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (77, 'Customer', 'In Progress', '04-Nov-2021', 1795.41, 30);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (78, 'Customer', 'In Progress', '13-Jul-2021', 3466.44, 85);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (79, 'Customer', 'In Progress', '17-Mar-2021', 1688.61, 61);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (80, 'Customer', 'Confrmed', '17-Jan-2021', 2273.15, 20);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (81, 'Customer', 'Confrmed', '24-Feb-2022', 2781.7, 54);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (82, 'Customer', 'Confrmed', '24-Apr-2022', 3054.71, 60);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (83, 'Customer', 'Confrmed', '09-Feb-2022', 4825.31, 51);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (84, 'Customer', 'Confrmed', '22-Jul-2021', 1114.83, 39);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (85, 'Customer', 'Confrmed', '28-Jul-2021', 2035.38, 38);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (86, 'Customer', 'In Progress', '14-Mar-2022', 2649.01, 30);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (87, 'Customer', 'Confrmed', '31-Jan-2022', 1576.07, 69);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (88, 'Customer', 'Confrmed', '30-Apr-2022', 2150.73, 7);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (89, 'Customer', 'Confrmed', '14-Jul-2021', 1987.54, 33);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (90, 'Customer', 'Confrmed', '20-Oct-2021', 1017.46, 35);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (91, 'Customer', 'Confrmed', '06-Apr-2022', 1272.36, 86);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (92, 'Customer', 'In Progress', '12-Jan-2022', 1838.85, 23);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (93, 'Customer', 'In Progress', '12-Dec-2021', 2638.81, 18);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (94, 'Customer', 'In Progress', '01-Sep-2021', 2162.82, 45);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (95, 'Customer', 'In Progress', '01-May-2021', 1655.05, 62);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (96, 'Customer', 'Confrmed', '09-May-2022', 4921.34, 54);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (97, 'Customer', 'In Progress', '03-Aug-2021', 1752.23, 82);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (98, 'Customer', 'Confrmed', '29-Apr-2022', 4139.32, 100);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (99, 'Customer', 'Confrmed', '24-Feb-2021', 3200.91, 76);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (100, 'Customer', 'In Progress', '22-Apr-2021', 1640.57, 100);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (101, 'Customer', 'In Progress', '10-Apr-2022', 1957.56, 42);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (102, 'Customer', 'In Progress', '01-Dec-2021', 3777.98, 21);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (103, 'Customer', 'In Progress', '09-Nov-2021', 3143.7, 92);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (104, 'Customer', 'In Progress', '11-May-2022', 2695.38, 54);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (105, 'Customer', 'Confrmed', '16-Apr-2022', 214.81, 70);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (106, 'Customer', 'Confrmed', '11-Feb-2021', 2408.64, 98);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (107, 'Customer', 'In Progress', '10-Jun-2021', 4601.84, 1);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (108, 'Customer', 'In Progress', '13-May-2022', 4934.23, 64);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (109, 'Customer', 'In Progress', '15-Jan-2021', 3691.9, 2);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (110, 'Customer', 'Confrmed', '25-May-2022', 222.86, 50);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (111, 'Customer', 'In Progress', '18-Dec-2021', 1585.98, 7);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (112, 'Customer', 'Confrmed', '31-Jul-2021', 748.23, 37);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (113, 'Customer', 'In Progress', '04-Jun-2021', 1833.32, 97);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (114, 'Customer', 'In Progress', '22-Feb-2022', 1147.14, 81);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (115, 'Customer', 'Confrmed', '03-Apr-2021', 4788.39, 22);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (116, 'Customer', 'Confrmed', '29-Jan-2022', 2788.88, 1);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (117, 'Customer', 'Confrmed', '27-Apr-2022', 4667.94, 94);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (118, 'Customer', 'In Progress', '03-Jan-2022', 4272.81, 97);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (119, 'Customer', 'In Progress', '23-Apr-2022', 623.08, 81);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (120, 'Customer', 'In Progress', '12-Feb-2022', 895.98, 44);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (121, 'Customer', 'In Progress', '25-Feb-2021', 1068.34, 40);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (122, 'Customer', 'In Progress', '19-Jun-2021', 231.59, 54);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (123, 'Customer', 'Confrmed', '30-Dec-2021', 1096.78, 45);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (124, 'Customer', 'In Progress', '24-May-2022', 872.86, 93);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (125, 'Customer', 'In Progress', '28-Mar-2022', 1437.51, 93);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (126, 'Customer', 'In Progress', '25-May-2022', 1533.72, 86);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (127, 'Customer', 'Confrmed', '26-Apr-2022', 2868.4, 75);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (128, 'Customer', 'In Progress', '08-Mar-2022', 1548.54, 13);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (129, 'Customer', 'In Progress', '12-Jan-2021', 910.59, 38);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (130, 'Customer', 'In Progress', '03-Apr-2022', 3529.43, 11);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (131, 'Customer', 'Confrmed', '28-Aug-2021', 4092.0, 77);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (132, 'Customer', 'In Progress', '27-Jan-2022', 3760.03, 87);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (133, 'Customer', 'In Progress', '25-Feb-2022', 2352.87, 65);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (134, 'Customer', 'In Progress', '26-May-2021', 4024.91, 59);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (135, 'Customer', 'In Progress', '13-Apr-2022', 4529.24, 58);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (136, 'Customer', 'Confrmed', '18-May-2021', 2621.2, 62);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (137, 'Customer', 'Confrmed', '10-Apr-2022', 1439.55, 46);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (138, 'Customer', 'Confrmed', '26-Sep-2021', 2025.69, 95);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (139, 'Customer', 'Confrmed', '15-Nov-2021', 2995.32, 33);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (140, 'Customer', 'Confrmed', '16-Aug-2021', 513.06, 61);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (141, 'Customer', 'Confrmed', '12-Apr-2021', 4087.01, 48);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (142, 'Customer', 'In Progress', '02-Apr-2021', 2021.09, 9);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (143, 'Customer', 'In Progress', '20-May-2021', 473.39, 75);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (144, 'Customer', 'Confrmed', '13-Dec-2021', 4860.55, 42);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (145, 'Customer', 'In Progress', '17-Sep-2021', 3762.94, 73);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (146, 'Customer', 'In Progress', '23-Apr-2021', 784.52, 89);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (147, 'Customer', 'Confrmed', '21-Jan-2022', 4411.08, 33);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (148, 'Customer', 'Confrmed', '24-Feb-2021', 4635.01, 1);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (149, 'Customer', 'In Progress', '06-Jun-2021', 4544.56, 77);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (150, 'Customer', 'Confrmed', '21-Apr-2022', 3049.61, 58);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (151, 'Customer', 'In Progress', '05-Oct-2021', 1214.24, 59);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (152, 'Customer', 'In Progress', '13-Aug-2021', 810.6, 20);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (153, 'Customer', 'Confrmed', '04-May-2021', 3459.12, 79);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (154, 'Customer', 'Confrmed', '01-Jan-2021', 406.67, 56);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (155, 'Customer', 'In Progress', '29-Oct-2021', 3911.58, 99);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (156, 'Customer', 'Confrmed', '18-Jun-2021', 3224.31, 60);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (157, 'Customer', 'In Progress', '13-Oct-2021', 3887.43, 37);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (158, 'Customer', 'Confrmed', '28-Sep-2021', 3312.57, 71);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (159, 'Customer', 'Confrmed', '01-Jul-2021', 1298.72, 4);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (160, 'Customer', 'In Progress', '21-May-2022', 66.2, 34);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (161, 'Customer', 'Confrmed', '18-Apr-2022', 4780.81, 77);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (162, 'Customer', 'In Progress', '02-Jul-2021', 2247.47, 79);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (163, 'Customer', 'In Progress', '11-Feb-2021', 232.35, 67);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (164, 'Customer', 'In Progress', '30-Apr-2021', 1229.19, 50);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (165, 'Customer', 'Confrmed', '23-Dec-2021', 3789.49, 44);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (166, 'Customer', 'In Progress', '12-May-2022', 1504.33, 58);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (167, 'Customer', 'Confrmed', '13-Apr-2021', 2963.44, 23);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (168, 'Customer', 'Confrmed', '30-Apr-2022', 565.45, 65);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (169, 'Customer', 'Confrmed', '09-Oct-2021', 1408.92, 30);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (170, 'Customer', 'Confrmed', '20-Dec-2021', 4985.37, 86);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (171, 'Customer', 'Confrmed', '10-Jan-2022', 670.41, 70);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (172, 'Customer', 'In Progress', '16-Jul-2021', 4352.83, 72);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (173, 'Customer', 'In Progress', '05-Jan-2022', 2181.01, 27);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (174, 'Customer', 'In Progress', '11-Aug-2021', 4198.59, 77);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (175, 'Customer', 'In Progress', '21-Mar-2021', 4980.68, 57);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (176, 'Customer', 'In Progress', '11-Oct-2021', 3976.81, 87);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (177, 'Customer', 'In Progress', '13-Oct-2021', 3633.13, 87);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (178, 'Customer', 'In Progress', '17-Feb-2021', 2016.56, 76);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (179, 'Customer', 'In Progress', '17-May-2021', 1744.1, 31);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (180, 'Customer', 'In Progress', '21-Jul-2021', 561.8, 21);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (181, 'Customer', 'In Progress', '15-Mar-2021', 4357.41, 67);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (182, 'Customer', 'Confrmed', '17-Mar-2022', 646.66, 23);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (183, 'Customer', 'In Progress', '21-Feb-2022', 2681.95, 12);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (184, 'Customer', 'In Progress', '09-Oct-2021', 1492.02, 30);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (185, 'Customer', 'In Progress', '30-Oct-2021', 759.52, 32);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (186, 'Customer', 'Confrmed', '11-Dec-2021', 3811.04, 97);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (187, 'Customer', 'Confrmed', '06-May-2021', 627.53, 34);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (188, 'Customer', 'Confrmed', '20-Aug-2021', 4216.54, 93);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (189, 'Customer', 'In Progress', '03-Jul-2021', 3110.12, 48);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (190, 'Customer', 'In Progress', '15-Feb-2022', 1047.51, 77);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (191, 'Customer', 'In Progress', '24-Aug-2021', 4938.51, 86);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (192, 'Customer', 'Confrmed', '23-Nov-2021', 3494.15, 23);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (193, 'Customer', 'In Progress', '18-May-2022', 1107.51, 29);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (194, 'Customer', 'In Progress', '12-Jan-2022', 3602.7, 99);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (195, 'Customer', 'Confrmed', '13-Oct-2021', 703.04, 91);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (196, 'Customer', 'Confrmed', '17-Jul-2021', 2552.05, 84);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (197, 'Customer', 'In Progress', '07-Aug-2021', 2423.78, 36);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (198, 'Customer', 'In Progress', '29-Nov-2021', 258.22, 59);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (199, 'Customer', 'In Progress', '17-Aug-2021', 2057.19, 61);
INSERT INTO CUST_ORDER (Order_ID, Order_Type, Pay_Confirmed, Pay_Date, Order_Total, Pay_ID) VALUES (200, 'Customer', 'Confrmed', '07-Aug-2021', 2412.76, 35);

--Parcel
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (1, '30-Apr-2022', 'BN32193683', 33);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (2, '03-Jun-2021', 'BN91285841', 24);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (3, '03-Feb-2022', 'DH78960728', 59);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (4, '19-Jul-2021', 'BN77855733', 58);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (5, '04-Apr-2021', 'AC02044370', 86);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (6, '13-Mar-2022', 'BN12223646', 62);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (7, '30-Jan-2022', 'DH66116871', 47);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (8, '01-Jan-2022', 'AC44619386', 44);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (9, '10-Feb-2022', 'AC13183248', 49);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (10, '29-Oct-2021', 'AC83778925', 88);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (11, '07-Aug-2021', 'BN39091100', 42);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (12, '13-Jun-2021', 'DH66928190', 37);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (13, '11-Jul-2021', 'AC68559879', 70);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (14, '04-May-2021', 'AC67258845', 99);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (15, '18-May-2022', 'BN91279450', 18);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (16, '15-Jul-2021', 'AC51845375', 34);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (17, '09-Jan-2022', 'AC83542783', 17);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (18, '18-Jul-2021', 'BN30205694', 43);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (19, '22-Oct-2021', 'AC83399174', 56);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (20, '22-Mar-2021', 'DH80164788', 53);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (21, '21-May-2022', 'AC97008897', 82);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (22, '18-Nov-2021', 'DH15817978', 85);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (23, '14-Mar-2022', 'DH74693069', 20);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (24, '19-Nov-2021', 'BN86192286', 61);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (25, '03-Jul-2021', 'DH33157541', 49);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (26, '10-Apr-2021', 'AC16049570', 60);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (27, '12-Jun-2021', 'AC67463914', 50);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (28, '31-Jan-2022', 'AC18437851', 18);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (29, '18-May-2021', 'AC36937396', 66);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (30, '15-Apr-2021', 'AC24922074', 76);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (31, '23-Apr-2022', 'BN74619849', 53);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (32, '05-Feb-2022', 'AC30078530', 85);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (33, '07-Apr-2021', 'AC75584601', 12);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (34, '13-May-2021', 'AC61011115', 80);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (35, '29-Jan-2022', 'AC94855763', 79);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (36, '23-Jan-2021', 'AC06187722', 65);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (37, '07-Mar-2021', 'BN23186526', 69);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (38, '02-May-2022', 'AC59157310', 39);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (39, '02-Apr-2022', 'TN02584850', 68);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (40, '03-Feb-2021', 'BN80789147', 96);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (41, '06-Apr-2022', 'AC22361435', 84);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (42, '08-Oct-2021', 'DH65074712', 59);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (43, '14-Nov-2021', 'TN47954280', 59);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (44, '30-Jul-2021', 'DH79536098', 93);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (45, '27-Apr-2022', 'DH86406655', 70);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (46, '21-Dec-2021', 'TN90553626', 13);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (47, '24-Mar-2021', 'AC28220386', 41);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (48, '02-Dec-2021', 'BN86780325', 88);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (49, '04-Apr-2021', 'BN32524891', 6);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (50, '07-Jul-2021', 'BN35837514', 86);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (51, '07-Sep-2021', 'BN48904400', 93);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (52, '23-Sep-2021', 'TN25025070', 79);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (53, '30-Mar-2022', 'BN65671291', 85);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (54, '15-Oct-2021', 'BN18123617', 44);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (55, '13-Dec-2021', 'DH93090707', 81);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (56, '29-Jan-2021', 'AC26500116', 74);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (57, '10-Jan-2022', 'BN66940081', 93);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (58, '16-Dec-2021', 'AC48811031', 98);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (59, '22-Jul-2021', 'AC49363580', 69);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (60, '16-Apr-2021', 'AC42127492', 5);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (61, '24-May-2021', 'AC36902126', 26);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (62, '02-Apr-2022', 'AC27876073', 10);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (63, '15-Feb-2022', 'BN88114148', 22);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (64, '26-Aug-2021', 'BN76338107', 24);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (65, '23-Sep-2021', 'TN56739194', 15);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (66, '30-Apr-2022', 'DH15996404', 32);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (67, '14-Jul-2021', 'AC43125889', 65);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (68, '28-Jun-2021', 'DH27559536', 1);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (69, '29-Apr-2021', 'DH36684903', 40);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (70, '23-Aug-2021', 'AC19533325', 2);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (71, '26-Sep-2021', 'TN53023547', 24);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (72, '02-Jan-2021', 'AC10561589', 97);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (73, '03-Jun-2021', 'DH61705406', 22);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (74, '22-Mar-2022', 'AC47682883', 37);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (75, '29-Aug-2021', 'AC01375015', 87);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (76, '05-Apr-2022', 'AC95166913', 47);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (77, '17-Jan-2021', 'AC41085613', 41);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (78, '10-May-2021', 'BN14095067', 46);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (79, '09-Jan-2022', 'TN69858980', 47);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (80, '19-Mar-2022', 'BN74992067', 62);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (81, '30-Sep-2021', 'AC81247828', 78);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (82, '04-Mar-2021', 'TN66130984', 94);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (83, '20-Mar-2022', 'TN73789045', 46);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (84, '01-Apr-2022', 'DH83311771', 74);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (85, '14-Mar-2021', 'AC65366148', 42);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (86, '21-May-2022', 'DH54755576', 77);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (87, '28-Mar-2021', 'BN10473030', 64);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (88, '24-Sep-2021', 'BN89633818', 50);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (89, '21-Aug-2021', 'DH85353450', 79);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (90, '29-Nov-2021', 'TN29352205', 86);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (91, '27-Jan-2021', 'BN68459647', 52);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (92, '09-Dec-2021', 'BN94158417', 85);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (93, '29-May-2021', 'TN43634489', 99);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (94, '07-Nov-2021', 'BN58058947', 2);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (95, '03-Dec-2021', 'DH93181192', 81);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (96, '11-Dec-2021', 'BN69926142', 60);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (97, '21-Apr-2022', 'BN73548792', 26);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (98, '13-Sep-2021', 'AC78112437', 5);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (99, '08-Apr-2021', 'BN94431363', 6);
INSERT INTO PARCEL (Par_ID, Par_Date, Par_TrackingNo, Order_ID) VALUES (100, '19-Jul-2021', 'AC74881367', 35);

--Product Category
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (1, 'Books');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (2, 'Appliances');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (3, 'Kitchen');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (4, 'Outdoor');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (5, 'Makeup');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (6, 'Electronics');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (7, 'Furniture');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (8, 'Snacks');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (9, 'Bathroom');
INSERT INTO PRODUCT_CATEGORY (Category_ID, Category_Name) VALUES (10, 'Travel');

--Product
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (1, 'Lobster - Live', 1.9, 402.57, 7, 3);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (2, 'Five Alive Citrus', 9.98, 2989.27, 7, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (3, 'Nori Sea Weed', 11.65, 1745.86, 4, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (4, 'Chicken - Whole', 10.4, 2114.38, 8, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (5, 'Alize Gold Passion', 9.82, 478.67, 6, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (6, 'French Kiss Vanilla', 8.47, 1087.8, 10, 7);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (7, 'Whmis Spray Bottle Graduated', 5.86, 873.69, 13, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (8, 'Beans - French', 7.33, 2993.6, 3, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (9, 'Parsley - Fresh', 10.73, 25.81, 4, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (10, 'Trout - Hot Smkd, Dbl Fillet', 6.04, 618.86, 7, 2);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (11, 'Ocean Spray - Ruby Red', 12.45, 434.52, 11, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (12, 'Tea - Lemon Scented', 10.61, 292.65, 2, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (13, 'Cheese - Swiss Sliced', 3.36, 1267.92, 10, 7);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (14, 'Napkin - Cocktail,beige 2 - Ply', 13.11, 1182.41, 6, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (15, 'Bread - Sour Sticks With Onion', 15.53, 534.84, 14, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (16, 'Nestea - Ice Tea, Diet', 18.31, 2130.03, 6, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (17, 'Beef - Outside, Round', 12.68, 1509.53, 4, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (18, 'Cake - Pancake', 6.48, 524.22, 1, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (19, 'Sea Urchin', 5.26, 1437.45, 2, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (20, 'Appetizer - Mini Egg Roll, Shrimp', 10.17, 2999.5, 15, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (21, 'Chicken - Leg - Back Attach', 19.33, 2112.27, 5, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (22, 'Transfer Sheets', 1.45, 1505.36, 13, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (23, 'Chocolate Bar - Reese Pieces', 10.75, 2325.46, 4, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (24, 'Fuji Apples', 10.45, 152.29, 12, 2);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (25, 'Bread - Multigrain, Loaf', 9.28, 2257.18, 14, 2);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (26, 'Wine - Gato Negro Cabernet', 17.86, 1005.86, 14, 2);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (27, 'Wine - Cave Springs Dry Riesling', 2.9, 1282.32, 2, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (28, 'Snapple - Iced Tea Peach', 7.14, 534.37, 4, 5);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (29, 'Petit Baguette', 16.17, 2700.46, 14, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (30, 'Soup Campbells Split Pea And Ham', 6.15, 2431.53, 3, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (31, 'Cocoa Powder - Dutched', 11.15, 2637.86, 9, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (32, 'Otomegusa Dashi Konbu', 18.93, 2918.06, 9, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (33, 'Duck - Breast', 5.34, 323.67, 1, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (34, 'Lamb - Shoulder', 15.99, 1871.89, 12, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (35, 'Kumquat', 1.03, 140.66, 1, 7);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (36, 'Vodka - Moskovskaya', 3.83, 1000.93, 11, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (37, 'Beef - Tongue, Cooked', 7.96, 1644.6, 15, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (38, 'Cookie - Oreo 100x2', 4.13, 2378.38, 6, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (39, 'Wine - Kwv Chenin Blanc South', 0.67, 230.1, 6, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (40, 'Chip - Potato Dill Pickle', 14.39, 2992.02, 5, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (41, 'Juice - Ocean Spray Kiwi', 16.82, 2370.28, 5, 5);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (42, 'Chocolate - Milk', 9.55, 1440.9, 4, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (43, 'Russian Prince', 3.68, 1489.28, 15, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (44, 'Pastry - Baked Scones - Mini', 3.44, 1180.43, 8, 3);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (45, 'Mince Meat - Filling', 4.05, 1039.1, 7, 5);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (46, 'Dill Weed - Dry', 17.3, 411.21, 7, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (47, 'Lamb - Whole, Frozen', 16.69, 615.4, 14, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (48, 'Asparagus - White, Fresh', 6.92, 2253.5, 11, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (49, 'Cheese - Grie Des Champ', 5.1, 520.45, 7, 3);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (50, 'Oil - Food, Lacquer Spray', 14.86, 1524.15, 10, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (51, 'Crackers - Graham', 10.65, 2542.98, 1, 5);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (52, 'Lamb - Bones', 4.36, 2619.09, 7, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (53, 'Beef - Ox Tail, Frozen', 8.93, 239.91, 6, 5);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (54, 'Cloves - Ground', 8.69, 1830.82, 11, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (55, 'Tendrils - Baby Pea, Organic', 12.09, 976.65, 12, 3);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (56, 'Calaloo', 18.82, 1539.55, 15, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (57, 'Russian Prince', 4.3, 2742.66, 7, 3);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (58, 'Apple - Northern Spy', 19.89, 503.47, 12, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (59, 'Nut - Almond, Blanched, Ground', 13.51, 1028.31, 1, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (60, 'Beer - Blue Light', 18.59, 2292.19, 3, 2);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (61, 'Pork - Loin, Boneless', 13.39, 2893.67, 9, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (62, 'Mushroom - Porcini Frozen', 10.18, 2236.81, 1, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (63, 'Pie Filling - Apple', 4.04, 1427.3, 7, 2);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (64, 'Roe - Lump Fish, Black', 3.56, 2725.37, 5, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (65, 'Dikon', 2.53, 1286.81, 2, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (66, 'Pectin', 4.5, 642.1, 6, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (67, 'Cheese - Comte', 17.25, 442.11, 12, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (68, 'Container Clear 8 Oz', 14.44, 428.9, 4, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (69, 'Liners - Banana, Paper', 13.5, 2114.94, 1, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (70, 'Pork - Sausage, Medium', 10.75, 2457.4, 1, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (71, 'Vaccum Bag - 14x20', 12.53, 1110.39, 14, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (72, 'Cheese - Roquefort Pappillon', 18.09, 279.25, 9, 7);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (73, 'Flour - So Mix Cake White', 4.27, 492.42, 1, 5);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (74, 'Pastry - Cheese Baked Scones', 9.07, 1669.27, 1, 3);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (75, 'Lamb - Racks, Frenched', 18.8, 319.27, 15, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (76, 'Yogurt - Cherry, 175 Gr', 17.68, 2152.34, 4, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (77, 'Salt - Seasoned', 11.83, 792.61, 7, 3);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (78, 'Greens Mustard', 16.59, 1582.1, 11, 5);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (79, 'Steam Pan Full Lid', 4.59, 2583.24, 9, 3);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (80, 'Clam - Cherrystone', 1.84, 464.51, 15, 7);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (81, 'Red Snapper - Fillet, Skin On', 11.13, 2750.07, 15, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (82, 'Bar Special K', 12.93, 2944.77, 11, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (83, 'Cocktail Napkin Blue', 5.62, 2513.2, 12, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (84, 'Chervil - Fresh', 2.14, 65.22, 15, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (85, 'Flour - Bran, Red', 7.65, 2958.44, 9, 7);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (86, 'Mcguinness - Blue Curacao', 6.15, 2053.76, 1, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (87, 'Pizza Pizza Dough', 9.27, 88.91, 6, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (88, 'Chicken - Thigh, Bone In', 13.07, 1716.34, 15, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (89, 'Strawberries', 14.96, 57.48, 11, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (90, 'Coffee - Decaffeinato Coffee', 6.88, 339.07, 2, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (91, 'Veal - Bones', 17.93, 819.9, 9, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (92, 'Olives - Black, Pitted', 4.97, 682.18, 14, 2);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (93, 'Apricots - Halves', 14.94, 5.55, 3, 8);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (94, 'Calypso - Pineapple Passion', 16.57, 424.98, 14, 5);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (95, 'Wine - Cave Springs Dry Riesling', 6.1, 37.25, 11, 1);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (96, 'Salt And Pepper Mix - Black', 11.04, 252.3, 2, 10);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (97, 'Bread - French Baquette', 6.79, 1672.69, 2, 9);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (98, 'Water - Spring 1.5lit', 10.07, 986.16, 11, 6);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (99, 'Ice Cream Bar - Hagen Daz', 14.79, 1138.96, 12, 4);
INSERT INTO PRODUCT (Product_ID, Product_Name, Product_Weight, Product_Price, Product_Quantity, Category_ID) VALUES (100, 'Chicken - Thigh, Bone In', 10.6, 2541.08, 7, 3);

--SUPPLIER
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (1, '29-Nov-2021', 1);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (2, '07-Dec-2021', 2);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (3, '29-Jun-2021', 3);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (4, '01-Jun-2021', 4);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (5, '24-May-2022', 5);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (6, '24-Jan-2022', 6);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (7, '28-Sep-2021', 7);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (8, '12-Nov-2021', 8);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (9, '13-Jul-2021', 9);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (10, '05-Nov-2021', 10);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (11, '06-Nov-2021', 11);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (12, '03-Oct-2021', 12);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (13, '24-Feb-2021', 13);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (14, '09-Mar-2021', 14);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (15, '15-May-2021', 15);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (16, '23-Jan-2021', 16);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (17, '09-Jan-2022', 17);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (18, '23-Jun-2021', 18);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (19, '29-Sep-2021', 19);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (20, '14-Oct-2021', 20);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (21, '04-Oct-2021', 21);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (22, '11-Feb-2021', 22);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (23, '19-Apr-2022', 23);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (24, '04-Oct-2021', 24);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (25, '28-Feb-2021', 25);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (26, '25-Aug-2021', 26);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (27, '26-May-2021', 27);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (28, '17-Mar-2022', 28);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (29, '23-Jan-2021', 29);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (30, '10-Dec-2021', 30);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (31, '27-Mar-2022', 31);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (32, '09-May-2022', 32);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (33, '12-May-2022', 33);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (34, '07-Feb-2021', 34);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (35, '11-Jun-2021', 35);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (36, '19-Apr-2021', 36);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (37, '28-May-2021', 37);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (38, '12-Jan-2021', 38);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (39, '28-Jun-2021', 39);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (40, '15-Mar-2022', 40);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (41, '19-Dec-2021', 41);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (42, '11-Feb-2021', 42);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (43, '05-Feb-2021', 43);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (44, '20-Nov-2021', 44);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (45, '21-Mar-2021', 45);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (46, '25-Dec-2021', 46);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (47, '23-Aug-2021', 47);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (48, '07-Jul-2021', 48);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (49, '19-Feb-2022', 49);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (50, '12-Apr-2021', 50);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (51, '26-Jun-2021', 51);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (52, '07-Apr-2021', 52);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (53, '17-Mar-2022', 53);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (54, '17-Feb-2022', 54);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (55, '16-Jul-2021', 55);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (56, '08-Apr-2022', 56);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (57, '14-Feb-2021', 57);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (58, '19-Sep-2021', 58);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (59, '10-Nov-2021', 59);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (60, '18-Jan-2022', 60);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (61, '17-May-2022', 61);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (62, '03-Apr-2022', 62);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (63, '10-Apr-2022', 63);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (64, '05-Jan-2021', 64);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (65, '26-Jan-2021', 65);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (66, '02-Mar-2021', 66);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (67, '13-Nov-2021', 67);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (68, '02-Apr-2021', 68);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (69, '15-Feb-2022', 69);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (70, '24-Mar-2022', 70);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (71, '27-Jan-2021', 71);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (72, '25-Mar-2021', 72);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (73, '25-Mar-2021', 73);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (74, '07-Apr-2021', 74);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (75, '04-Sep-2021', 75);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (76, '26-Dec-2021', 76);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (77, '28-Apr-2022', 77);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (78, '29-Apr-2021', 78);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (79, '03-Jan-2022', 79);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (80, '08-Feb-2021', 80);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (81, '20-May-2021', 81);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (82, '21-Oct-2021', 82);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (83, '09-Apr-2022', 83);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (84, '16-Apr-2022', 84);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (85, '29-Apr-2021', 85);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (86, '17-Mar-2022', 86);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (87, '03-Jan-2022', 87);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (88, '01-Jan-2021', 88);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (89, '17-Dec-2021', 89);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (90, '13-Apr-2022', 90);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (91, '13-Dec-2021', 91);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (92, '23-Feb-2021', 92);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (93, '11-Apr-2021', 93);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (94, '23-Feb-2022', 94);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (95, '10-Mar-2021', 95);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (96, '20-Nov-2021', 96);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (97, '28-Jun-2021', 97);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (98, '04-Mar-2021', 98);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (99, '05-Jan-2022', 99);
INSERT INTO SUPPLIER (Supplier_ID, Order_date, Product_ID) VALUES (100, '11-Jul-2021', 100);

--ORDER CONTENT
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (55, 36);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (67, 44);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (38, 67);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (30, 12);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (7, 41);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 74);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (2, 42);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 24);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (94, 20);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (62, 75);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (94, 59);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (29, 43);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (89, 5);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (31, 6);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (7, 67);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (58, 50);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (89, 69);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 76);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (26, 19);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 92);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (50, 96);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (63, 83);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (81, 70);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (53, 20);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (37, 98);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (44, 69);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (89, 6);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (95, 99);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (1, 74);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (39, 13);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (52, 92);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (56, 83);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (27, 98);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (58, 3);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (26, 52);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (36, 31);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (86, 48);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (36, 73);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (63, 14);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (11, 80);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (3, 42);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (80, 71);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (31, 12);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (1, 80);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (93, 56);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (48, 13);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (44, 78);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (43, 43);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (7, 15);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (70, 97);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (53, 54);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (99, 57);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (18, 8);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (81, 90);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (35, 36);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (11, 39);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 95);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (61, 97);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (83, 80);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (65, 9);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (17, 31);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 56);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (12, 75);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (86, 23);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (52, 56);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (96, 48);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (66, 46);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (33, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (75, 35);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (71, 97);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (78, 33);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (55, 33);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (7, 82);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (49, 78);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (57, 93);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (16, 81);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (33, 26);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (2, 50);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (51, 63);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (10, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (95, 67);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (39, 56);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (5, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (99, 22);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (80, 63);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 18);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (56, 91);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (86, 9);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (42, 17);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (12, 39);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (35, 80);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (67, 27);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (3, 94);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 63);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 54);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (43, 56);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (100, 54);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (23, 13);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (25, 55);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (74, 73);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (9, 6);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (42, 76);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (32, 68);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (57, 53);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 89);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 50);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (18, 67);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (38, 87);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (58, 96);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (34, 52);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (21, 17);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (81, 10);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (75, 27);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (82, 96);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (35, 40);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (95, 64);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (74, 35);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (70, 19);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (85, 65);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (20, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (42, 81);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (3, 25);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (40, 56);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (80, 82);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (50, 41);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (85, 94);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (32, 55);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 47);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 91);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (35, 35);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 34);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (98, 5);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (21, 31);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (47, 3);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (83, 62);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (76, 42);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (91, 96);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 75);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (49, 92);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (95, 78);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (25, 23);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (14, 20);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (5, 68);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (39, 80);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 95);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (23, 91);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (36, 99);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (86, 82);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 88);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (12, 49);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 40);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (49, 75);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 6);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (98, 79);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (91, 50);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (11, 71);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (35, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (83, 82);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (65, 82);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (40, 57);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (11, 65);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (92, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (51, 40);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (42, 69);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (15, 98);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (95, 2);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (53, 83);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (23, 100);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (53, 81);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (12, 53);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (58, 57);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 33);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (74, 84);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (33, 4);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (34, 85);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (98, 5);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 42);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 28);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (1, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (91, 14);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 23);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (37, 75);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (93, 63);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (71, 89);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (27, 67);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (33, 45);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (82, 48);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 71);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (84, 48);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 70);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (16, 73);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (84, 31);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (87, 87);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (2, 81);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (74, 15);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (48, 62);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (63, 68);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 73);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (33, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (32, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (62, 64);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 55);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (57, 43);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (64, 11);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (25, 44);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 7);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (25, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (82, 77);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 100);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (41, 13);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (32, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (76, 1);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (42, 1);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 91);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (94, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (60, 61);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (24, 11);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (16, 2);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (36, 21);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (67, 98);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (96, 91);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (30, 13);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (1, 69);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 42);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (47, 64);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (11, 92);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 93);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (32, 9);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (81, 46);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (82, 41);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (14, 14);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (6, 45);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 6);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (93, 49);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (31, 19);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (48, 18);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (45, 5);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (88, 51);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 37);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (44, 38);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (96, 85);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (82, 62);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (67, 90);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (39, 79);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (94, 47);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (71, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (20, 1);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 18);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (89, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (66, 100);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (2, 38);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (5, 33);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 14);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (79, 19);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (52, 54);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (20, 2);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (69, 85);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 19);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (3, 24);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (72, 41);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (96, 1);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (100, 63);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (8, 38);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (21, 54);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (18, 78);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (93, 73);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 1);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (61, 90);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (1, 27);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (60, 25);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 6);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (40, 37);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (62, 32);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (26, 79);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (47, 63);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (87, 28);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (81, 41);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (41, 28);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 93);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (80, 41);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (42, 37);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (89, 57);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (3, 18);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (95, 35);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (83, 65);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (60, 29);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (24, 62);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 18);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 99);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (12, 96);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 10);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 29);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (69, 57);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (18, 31);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (27, 2);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (30, 56);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (12, 54);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (21, 8);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (24, 100);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (78, 38);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (52, 95);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (57, 37);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (88, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (92, 78);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (40, 25);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (7, 54);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (1, 77);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 85);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 15);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (41, 94);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (100, 89);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 26);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (56, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (52, 85);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (78, 53);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (57, 91);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (63, 71);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (33, 27);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (15, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (98, 26);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (56, 45);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (3, 39);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (58, 92);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 26);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (64, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (30, 97);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 21);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (70, 35);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (67, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (37, 32);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (24, 17);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (40, 67);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (65, 2);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (24, 48);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (10, 78);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 96);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (1, 59);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 40);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (88, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (46, 52);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 91);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (41, 28);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (92, 39);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (74, 92);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 69);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (52, 27);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (38, 20);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (67, 93);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (61, 21);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (87, 87);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (24, 62);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (56, 91);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (36, 4);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (88, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (44, 23);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (16, 13);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (89, 62);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (39, 16);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (95, 81);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (58, 72);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (45, 10);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (72, 19);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (12, 71);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (92, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (46, 3);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (81, 14);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (57, 7);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 48);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (96, 55);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (91, 69);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (46, 84);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (92, 11);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (56, 65);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (19, 25);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (46, 97);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (53, 95);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 54);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (32, 8);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (42, 27);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (36, 95);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (4, 35);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (98, 45);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (4, 47);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (30, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (16, 100);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (85, 25);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (54, 82);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (79, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (37, 78);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (54, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (13, 26);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (30, 25);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (71, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (79, 9);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (16, 59);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (70, 42);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (85, 15);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (5, 53);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (93, 40);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (84, 59);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (56, 29);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (68, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (72, 4);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (74, 27);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (25, 59);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 100);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (36, 90);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 12);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (37, 10);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (21, 72);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (76, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (43, 22);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (67, 35);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (29, 64);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (20, 93);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (26, 58);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (25, 42);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (37, 43);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 97);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (65, 84);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (100, 66);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (70, 88);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (57, 58);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (42, 79);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (81, 56);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (83, 44);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (100, 11);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (37, 68);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (70, 55);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (29, 10);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (86, 64);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (20, 100);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (63, 26);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (94, 5);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (28, 68);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (55, 63);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (74, 85);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (35, 12);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (38, 62);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (57, 92);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 28);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (24, 76);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (59, 68);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (93, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (25, 63);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (85, 40);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (15, 39);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (72, 3);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (44, 11);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (72, 74);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (8, 17);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (95, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (78, 14);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (92, 67);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (65, 60);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (94, 65);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (31, 75);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (87, 76);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (9, 95);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (15, 84);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (29, 98);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (53, 64);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (47, 22);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (7, 27);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (77, 7);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (51, 85);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (6, 30);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (60, 93);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (51, 73);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (48, 19);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (73, 80);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (1, 2);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (41, 88);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (23, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (10, 84);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (44, 3);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (84, 78);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (15, 11);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (66, 25);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (63, 61);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (35, 44);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (88, 65);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (9, 83);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (97, 71);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (14, 42);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (82, 73);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (6, 39);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (22, 72);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (61, 29);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (98, 2);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (15, 51);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (93, 86);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (52, 58);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (65, 57);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (58, 28);
INSERT INTO ORDER_CONTENT (Order_ID, Product_ID) VALUES (92, 86);