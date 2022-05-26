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