CREATE TABLE "Addresses" (
  "CustomerId" serial,
  "Address" varchar(255) NOT NULL,
  "Id" serial,
  "GeoLocation" point,
  PRIMARY KEY ("Id")
);

CREATE TABLE "BikeTypes" (
  "Id" serial,
  "Name" varchar(255) NOT NULL,
  PRIMARY KEY ("Id")
);

CREATE TABLE "Branch" (
  "BranchSerialNumber" varchar(255) NOT NULL,
  "ForResturant" serial,
  "Name" varchar(255) NOT NULL,
  "IsClosed" bool NOT NULL,
  "Details" text,
  "ResturantType" serial,
  "Address" varchar(255) NOT NULL,
  PRIMARY KEY ("BranchSerialNumber", "ForResturant"),
  CONSTRAINT "u_serial" UNIQUE ("BranchSerialNumber")
);

CREATE TABLE "Customer" (
  "Id" serial,
  PRIMARY KEY ("Id")
);

CREATE TABLE "Default" (

);

CREATE TABLE "Delivery" (
  "Id" serial,
  "BikeType" serial,
  "PlateNumber" varchar(10) NOT NULL,
  PRIMARY KEY ("Id")
);

CREATE TABLE "DiscountCode" (
  "Id" varchar NOT NULL,
  "UsableTimes" int2 NOT NULL,
  "ExpireDate" date NOT NULL,
  "IsPercentage" bool NOT NULL,
  "DiscountPercentage" int2,
  "CeilDiscount" int4,
  "CeilPercentage" int2,
  PRIMARY KEY ("Id"),
  CONSTRAINT "C_DiscountPercentage" CHECK (DiscountPercentage > 0 AND DiscountPercentage <= 100),
  CONSTRAINT "C_CeilPercentage" CHECK (CeilPercentage > 0 AND CeilPercentage  <= 100)
);

CREATE TABLE "Food" (
  "id" serial,
  "ForResturant" serial,
  "ForBranch" varchar(255) NOT NULL,
  "Name" varchar(255) NOT NULL,
  "Pirce" int4 NOT NULL,
  "InStock" int2,
  "DiscountedPrice" int4,
  "Type" serial,
  PRIMARY KEY ("id", "ForResturant", "ForBranch")
);
COMMENT ON COLUMN "Food"."InStock" IS 'Is null if no limits';
COMMENT ON COLUMN "Food"."DiscountedPrice" IS 'Null if no discount';

CREATE TABLE "FoodType" (
  "id" serial,
  "Name" varchar(255) NOT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "Order" (
  "id" serial,
  "ForCustomer" serial,
  "DeliveredBy" serial,
  "DeliveryPrice" int4,
  "DeliveredTime" date,
  "DiscountCode" varchar(255),
  "DeliveryAddress" serial,
  "FinalPriceNoDiscount" int4 NOT NULL,
  "FinalPriceAfterDiscount" int4,
  "OrderDate" date NOT NULL,
  "OrderStatus" bool NOT NULL,
  PRIMARY KEY ("id")
);
COMMENT ON COLUMN "Order"."DeliveredBy" IS 'Null if no bikes has yet accepted this food delivery';
COMMENT ON COLUMN "Order"."FinalPriceAfterDiscount" IS 'Null if no discount is used';
COMMENT ON COLUMN "Order"."OrderStatus" IS 'True if delivered, otherwise false';

CREATE TABLE "OrderFoods" (
  "OrderID" serial,
  "FoodID" serial,
  PRIMARY KEY ("OrderID", "FoodID")
);

CREATE TABLE "Resturant" (
  "id" serial,
  "Name" varchar(255) NOT NULL,
  "StartDate" date NOT NULL,
  "Logo" bytea,
  "OwnerID" serial,
  PRIMARY KEY ("id")
);
CREATE TRIGGER "insert_add_start_date" AFTER INSERT ON "Resturant"
FOR EACH ROW
EXECUTE PROCEDURE;
COMMENT ON TRIGGER "insert_add_start_date" ON "Resturant" IS 'Adds the start date of the resturant';

CREATE TABLE "ResturantOwner" (
  "Id" serial,
  PRIMARY KEY ("Id")
);

CREATE TABLE "ResturantTypes" (
  "id" serial,
  "Name" varchar(255) NOT NULL,
  PRIMARY KEY ("id")
);

CREATE TABLE "Review" (
  "id" serial,
  "ForOrder" serial,
  "Rating" int2 NOT NULL,
  "Content" text NOT NULL,
  "DeliveryRate" bool NOT NULL,
  "ReviewDate" date NOT NULL,
  "ResurantAnswer" text,
  "ResurantAnswerDate" date,
  "SnapfoodAnswer" text,
  "SnapfoodAnswerDate" date,
  PRIMARY KEY ("id", "ForOrder"),
  CONSTRAINT "c_rate_range" CHECK (Rating >= 1 AND Rating <= 5)
);
COMMENT ON COLUMN "Review"."DeliveryRate" IS 'True if positive otherwise false';

CREATE TABLE "User" (
  "Id" serial,
  "LastName" varchar(255) NOT NULL,
  "FirstName" varchar(255) NOT NULL,
  "BirthDate" date NOT NULL,
  "Sex" bool[][][] NOT NULL,
  "Password" varchar(255) NOT NULL,
  "PhoneNumber" varchar(11) NOT NULL,
  "Username" varchar(255) NOT NULL,
  PRIMARY KEY ("Id")
);
CREATE UNIQUE INDEX "Username" ON "User" (
  "Username"
);

ALTER TABLE "Addresses" ADD CONSTRAINT "fk_Addresses_Customer_1" FOREIGN KEY ("CustomerId") REFERENCES "Customer" ("Id") ON DELETE CASCADE;
ALTER TABLE "Branch" ADD CONSTRAINT "fk_Branch_ResturantTypes_1" FOREIGN KEY ("ResturantType") REFERENCES "ResturantTypes" ("id");
ALTER TABLE "Branch" ADD CONSTRAINT "fk_Branch_Resturant_1" FOREIGN KEY ("ForResturant") REFERENCES "Resturant" ("id") ON DELETE CASCADE;
ALTER TABLE "Customer" ADD CONSTRAINT "fk_Customer_User_1" FOREIGN KEY ("Id") REFERENCES "User" ("Id");
ALTER TABLE "Delivery" ADD CONSTRAINT "fk_Delivery_BikeTypes_1" FOREIGN KEY ("BikeType") REFERENCES "BikeTypes" ("Id");
ALTER TABLE "Delivery" ADD CONSTRAINT "fk_Delivery_User_1" FOREIGN KEY ("Id") REFERENCES "User" ("Id");
ALTER TABLE "Food" ADD CONSTRAINT "fk_Food_FoodType_1" FOREIGN KEY ("Type") REFERENCES "FoodType" ("id");
ALTER TABLE "Food" ADD CONSTRAINT "fk_Branch" FOREIGN KEY ("ForResturant", "ForBranch") REFERENCES "Branch" ("BranchSerialNumber", "ForResturant") ON DELETE CASCADE;
ALTER TABLE "Order" ADD CONSTRAINT "fk_Order_Customer_1" FOREIGN KEY ("ForCustomer") REFERENCES "Customer" ("Id");
ALTER TABLE "Order" ADD CONSTRAINT "fk_Order_Delivery_1" FOREIGN KEY ("DeliveredBy") REFERENCES "Delivery" ("Id");
ALTER TABLE "Order" ADD CONSTRAINT "fk_Order_Addresses_1" FOREIGN KEY ("DeliveryAddress") REFERENCES "Addresses" ("Id");
ALTER TABLE "Order" ADD CONSTRAINT "fk_Order_DiscountCode_1" FOREIGN KEY ("DiscountCode") REFERENCES "DiscountCode" ("Id");
ALTER TABLE "OrderFoods" ADD CONSTRAINT "fk_OrderFoods_Order_1" FOREIGN KEY ("OrderID") REFERENCES "Order" ("id");
ALTER TABLE "OrderFoods" ADD CONSTRAINT "fk_OrderFoods_Food_1" FOREIGN KEY ("FoodID") REFERENCES "Food" ("id");
ALTER TABLE "Resturant" ADD CONSTRAINT "fk_Resturant_ResturantOwner_1" FOREIGN KEY ("OwnerID") REFERENCES "ResturantOwner" ("Id");
ALTER TABLE "ResturantOwner" ADD CONSTRAINT "fk_ResturantOwner_User_1" FOREIGN KEY ("Id") REFERENCES "User" ("Id");
ALTER TABLE "Review" ADD CONSTRAINT "fk_Review_Order_1" FOREIGN KEY ("ForOrder") REFERENCES "Order" ("id") ON DELETE CASCADE;

