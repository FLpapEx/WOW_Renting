-- Table address
CREATE TABLE zzz_address (
    addrid  BIGINT NOT NULL COMMENT 'Unique ID for address.',
    street  VARCHAR(30) NOT NULL COMMENT 'Street info for address.',
    state   VARCHAR(30) NOT NULL COMMENT 'State info for address.',
    country VARCHAR(30) NOT NULL COMMENT 'Country info for address.',
    zipcode INT NOT NULL COMMENT 'Zipcode for address.',
    PRIMARY KEY ( addrid )
);
ALTER TABLE zzz_address MODIFY addrid BIGINT AUTO_INCREMENT;

-- Table office
CREATE TABLE zzz_office (
    officeid INT NOT NULL COMMENT 'Unique ID for office.',
    phone    VARCHAR(20) NOT NULL COMMENT 'Office''s phone number.',
    addrid   BIGINT NOT NULL,
    PRIMARY KEY ( officeid )
);
CREATE UNIQUE INDEX zzz_office__idx ON zzz_office ( addrid ASC );
ALTER TABLE zzz_office MODIFY officeid INT AUTO_INCREMENT;

-- Table car
CREATE TABLE zzz_car (
    carid     INT NOT NULL COMMENT 'Unique ID for each car.',
    cartype   VARCHAR(20) NOT NULL COMMENT 'Class of the car.',
    dailyrate DECIMAL(5, 2) NOT NULL COMMENT 'Regular rental rate per day of the rental service for the car.',
    overrate  DECIMAL(5, 2) NOT NULL COMMENT 'Extra fees per mile that exceeds the limit.',
    officeid  INT,
    vin       VARCHAR(20) NOT NULL,
    PRIMARY KEY ( carid )
);
CREATE UNIQUE INDEX zzz_car__idx ON zzz_car ( vin ASC );
ALTER TABLE zzz_car MODIFY carid INT AUTO_INCREMENT;

-- Table vehicle
CREATE TABLE zzz_vehicle (
    vin   VARCHAR(20) NOT NULL COMMENT 'Vehicle identification number.',
    make  VARCHAR(30) NOT NULL COMMENT 'Brand of the vehicle.',
    model VARCHAR(30) NOT NULL COMMENT 'Name of a product or a range of products.',
    year  SMALLINT NOT NULL COMMENT 'Manufacture year of the vehicle.',
    lpn   VARCHAR(15) NOT NULL COMMENT 'The registration identifier is a numeric or alphanumeric ID that uniquely identifies the vehicle or vehicle owner within the issuing region''s vehicle register.',
    PRIMARY KEY ( vin )
);

-- Table customer
CREATE TABLE zzz_customer (
    custid   INT NOT NULL COMMENT 'Unique ID for customer.',
    custtype CHAR(1) NOT NULL COMMENT 'Customer type.',
    email    VARCHAR(20) NOT NULL COMMENT 'Email address for customer.',
    phone    VARCHAR(20) NOT NULL COMMENT 'Phone number for customers.',
    addrid   BIGINT NOT NULL,
    PRIMARY KEY ( custid, custtype )
);
CREATE UNIQUE INDEX zzz_customer__idx ON zzz_customer ( addrid ASC );
ALTER TABLE zzz_customer MODIFY custid INT AUTO_INCREMENT;
ALTER TABLE zzz_customer
    ADD CONSTRAINT ch_inh_zzz_customer CHECK ( custtype IN ( 'C', 'I' ) );

-- Table corporate
CREATE TABLE zzz_corporate (
    custid   INT NOT NULL COMMENT 'Unique ID for customer.',
    custtype CHAR(1) NOT NULL COMMENT 'Customer type.',
    corpname VARCHAR(20) NOT NULL COMMENT 'Corporation''s name.',
    regnum   VARCHAR(20) NOT NULL COMMENT 'Registration number of the corporation.',
    empid    VARCHAR(20) NOT NULL COMMENT 'Employee ID of the customer who rents the car on a corporate account.',
    PRIMARY KEY ( custid, custtype )
);

-- Table individual
CREATE TABLE zzz_individual (
    custid     INT NOT NULL COMMENT 'Unique ID for customer.',
    custtype   CHAR(1) NOT NULL COMMENT 'Customer type.',
    lname      VARCHAR(20) NOT NULL COMMENT 'Last name for individual customer.',
    fname      VARCHAR(20) NOT NULL COMMENT 'First Name for individual customer.',
    licensenum BIGINT NOT NULL COMMENT 'Drive license number.',
    insname    VARCHAR(20) NOT NULL COMMENT 'Insurance company name.',
    insnum     DECIMAL(20) NOT NULL COMMENT 'Insurance policy number.',
    PRIMARY KEY ( custid, custtype )
);

-- Table discount
CREATE TABLE zzz_discount (
    discid     BIGINT NOT NULL COMMENT 'Uinque ID for discount.',
    disctype   CHAR(1) NOT NULL COMMENT 'Discriminator of discount type.',
    discpercen DECIMAL(5, 2) NOT NULL COMMENT 'Discount percentage %.',
    PRIMARY KEY ( discid, disctype )
);
ALTER TABLE zzz_discount MODIFY discid BIGINT AUTO_INCREMENT;
ALTER TABLE zzz_discount
    ADD CONSTRAINT ch_inh_zzz_discount CHECK ( disctype IN ( 'C', 'I' ) );

-- Table disccorp
CREATE TABLE zzz_disccorp (
    discid   BIGINT NOT NULL COMMENT 'Uinque ID for discount.',
    disctype CHAR(1) NOT NULL COMMENT 'Discriminator of discount type.',
    setnum   DECIMAL(20) NOT NULL COMMENT 'Number for indentifying corporation',
    PRIMARY KEY ( disctype, discid )
);

-- Table discindi
CREATE TABLE zzz_discindi (
    discid     BIGINT NOT NULL COMMENT 'Uinque ID for discount.',
    disctype   CHAR(1) NOT NULL COMMENT 'Discriminator of discount type.',
    coupnum    VARCHAR(10) NOT NULL COMMENT 'Coupon number.',
    validstart DATETIME NOT NULL COMMENT 'Coupon valid start date.',
    validend   DATETIME NOT NULL COMMENT 'Coupon valid end date.',
    PRIMARY KEY ( disctype, discid )
);

-- Table order
CREATE TABLE zzz_order (
    orderid   BIGINT NOT NULL COMMENT 'Unique ID for each order.',
    startodo  BIGINT NOT NULL COMMENT 'Start odometer.',
    endodo    BIGINT COMMENT 'End Odometer.',
    odolimit  BIGINT COMMENT 'Daily odometer limit for the rental service.',
    startdate DATETIME NOT NULL COMMENT 'Date when the customer starts the service.',
    enddate   DATETIME NOT NULL COMMENT 'Date when the customer ends the service.',
    custid    INT NOT NULL,
    custtype  CHAR(1) NOT NULL,
    pickup    BIGINT NOT NULL,
    dropoff   BIGINT NOT NULL,
    carid     INT NOT NULL,
    discid    BIGINT,
    disctype  CHAR(1),
    PRIMARY KEY ( orderid )
);
CREATE UNIQUE INDEX zzz_order__idx ON zzz_order ( disctype ASC, discid ASC );
ALTER TABLE zzz_order MODIFY orderid BIGINT AUTO_INCREMENT;

-- Table payment
CREATE TABLE zzz_payment (
    paymid    BIGINT NOT NULL COMMENT 'Unique ID for payment.',
    method    VARCHAR(20) NOT NULL COMMENT 'Payment method.',
    amount    DECIMAL(5, 2) NOT NULL COMMENT 'Payment amount.',
    paymdate  DATETIME NOT NULL COMMENT 'Payment date.',
    cardnum   DECIMAL(20) NOT NULL COMMENT 'Card number.',
    invoiceid BIGINT NOT NULL,
    PRIMARY KEY ( paymid )
);
ALTER TABLE zzz_payment MODIFY paymid BIGINT AUTO_INCREMENT;

-- Table invoice
CREATE TABLE zzz_invoice (
    invoiceid   BIGINT NOT NULL COMMENT 'Unique ID for invoice.',
    invoicedate DATETIME NOT NULL COMMENT 'Invoice data.',
    amount      DECIMAL(10, 2) NOT NULL COMMENT 'Invoice amount.',
    ispaid      CHAR(1) DEFAULT 'N' NOT NULL,
    orderid     BIGINT NOT NULL,
    PRIMARY KEY ( invoiceid )
);

-- Set FK
ALTER TABLE zzz_car
    ADD CONSTRAINT zzz_car_zzz_office_fk FOREIGN KEY ( officeid )
        REFERENCES zzz_office ( officeid );

ALTER TABLE zzz_car
    ADD CONSTRAINT zzz_car_zzz_vehicle_fk FOREIGN KEY ( vin )
        REFERENCES zzz_vehicle ( vin );

ALTER TABLE zzz_disccorp
    ADD CONSTRAINT zzz_corp_zzz_discount_fk FOREIGN KEY ( discid,
                                                          disctype )
        REFERENCES zzz_discount ( discid,
                                  disctype );

ALTER TABLE zzz_corporate
    ADD CONSTRAINT zzz_corporate_zzz_customer_fk FOREIGN KEY ( custid,
                                                               custtype )
        REFERENCES zzz_customer ( custid,
                                  custtype );

ALTER TABLE zzz_customer
    ADD CONSTRAINT zzz_customer_zzz_address_fk FOREIGN KEY ( addrid )
        REFERENCES zzz_address ( addrid );

ALTER TABLE zzz_discindi
    ADD CONSTRAINT zzz_indi_zzz_discount_fk FOREIGN KEY ( discid,
                                                          disctype )
        REFERENCES zzz_discount ( discid,
                                  disctype );

ALTER TABLE zzz_individual
    ADD CONSTRAINT zzz_individual_zzz_customer_fk FOREIGN KEY ( custid,
                                                                custtype )
        REFERENCES zzz_customer ( custid,
                                  custtype );

ALTER TABLE zzz_invoice
    ADD CONSTRAINT zzz_invoice_zzz_order_fk FOREIGN KEY ( orderid )
        REFERENCES zzz_order ( orderid );

ALTER TABLE zzz_office
    ADD CONSTRAINT zzz_office_zzz_address_fk FOREIGN KEY ( addrid )
        REFERENCES zzz_address ( addrid );

ALTER TABLE zzz_order
    ADD CONSTRAINT zzz_order_zzz_address_fk FOREIGN KEY ( dropoff )
        REFERENCES zzz_address ( addrid );

ALTER TABLE zzz_order
    ADD CONSTRAINT zzz_order_zzz_address_fkv2 FOREIGN KEY ( pickup )
        REFERENCES zzz_address ( addrid );

ALTER TABLE zzz_order
    ADD CONSTRAINT zzz_order_zzz_car_fk FOREIGN KEY ( carid )
        REFERENCES zzz_car ( carid );

ALTER TABLE zzz_order
    ADD CONSTRAINT zzz_order_zzz_customer_fk FOREIGN KEY ( custid,
                                                           custtype )
        REFERENCES zzz_customer ( custid,
                                  custtype );

ALTER TABLE zzz_order
    ADD CONSTRAINT zzz_order_zzz_discount_fk FOREIGN KEY ( discid,
                                                           disctype )
        REFERENCES zzz_discount ( discid,
                                  disctype );

ALTER TABLE zzz_payment
    ADD CONSTRAINT zzz_payment_zzz_invoice_fk FOREIGN KEY ( invoiceid )
        REFERENCES zzz_invoice ( invoiceid );

-- Trigger used to generate invoice
delimiter |
CREATE TRIGGER UpdateInvoice AFTER UPDATE ON zzz_order
    FOR EACH ROW
BEGIN
    IF NOT(NEW.endOdo <=> OLD.endOdo) THEN
        -- Calcuate amount before discount
        Set @RegularAmount := DATEDIFF(new.endDate, new.startDate) * (select dailyrate from zzz_car where new.carid = zzz_car.carid);
        Set @OverAmount := 0;
        Set @LimitOdo := DATEDIFF(new.endDate, new.startDate) * new.OdoLimit;
        IF new.endOdo - new.startOdo > @LimitOdo THEN
            Set @OverAmount := (new.endOdo - new.startOdo - @LimitOdo)
                                * (select overrate from zzz_car where new.carid = zzz_car.carid);
        END IF;
        
        -- Calcuate discount
        Set @DiscountPerc = 1;
        IF NOT(NEW.disctype <=> NULL) THEN
            IF (NEW.disctype = 'I') THEN
                Set @ValidStart := (select validstart from zzz_discindi where new.discid = zzz_discindi.discid);
                Set @ValidEnd := (select validend from zzz_discindi where new.discid = zzz_discindi.discid);
                IF (@ValidStart < new.enddate AND @ValidEnd > new.endDate) THEN 
                    Set @DiscountPerc = 1 - 0.01 * (select discpercen from zzz_discount where new.discid = zzz_discount.discid);
                END IF;
            ELSEIF (NEW.disctype = 'C') THEN
                Set @DiscountPerc = 1 - 0.01 * (select discpercen from zzz_discount where new.discid = zzz_discount.discid);
            END IF;
        END IF;

        -- Insert the new record to invoice
        IF (NEW.OdoLimit <=> NULL) THEN
            INSERT INTO zzz_invoice(invoiceid, invoicedate, amount, orderid) values 
                (NEW.orderid, CURDATE(), @RegularAmount, NEW.orderid);
        ELSE
            INSERT INTO zzz_invoice(invoiceid, invoicedate, amount, orderid) values 
                (NEW.orderid, CURDATE(), (@RegularAmount + @OverAmount) * @DiscountPerc, NEW.orderid);
        END IF;
        
    END IF;
END;
|
delimiter ;

