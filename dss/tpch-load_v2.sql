BEGIN;

	CREATE EXTERNAL  TABLE EXT_PART (
                P_PARTKEY               SERIAL8,
                P_NAME                  VARCHAR(55),
                P_MFGR                  CHAR(25),
                P_BRAND                 CHAR(10),
                P_TYPE                  VARCHAR(25),
                P_SIZE                  INTEGER,
                P_CONTAINER             CHAR(10),
                P_RETAILPRICE   DECIMAL,
                P_COMMENT               VARCHAR(23)
        ) location('gpfdist://172.31.6.47:8080/part.csv') format 'TEXT' (DELIMITER as '|') encoding 'utf8';

        CREATE TABLE PART (
                P_PARTKEY               SERIAL8,
                P_NAME                  VARCHAR(55),
                P_MFGR                  CHAR(25),
                P_BRAND                 CHAR(10),
                P_TYPE                  VARCHAR(25),
                P_SIZE                  INTEGER,
                P_CONTAINER             CHAR(10),
                P_RETAILPRICE   DECIMAL,
                P_COMMENT               VARCHAR(23)
        ) with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (p_partkey);
      
      INSERT INTO PART select * from EXT_PART;

COMMIT;

BEGIN;
	CREATE EXTERNAL TABLE EXT_REGION (
                R_REGIONKEY     SERIAL8,
                R_NAME          CHAR(25),
                R_COMMENT       VARCHAR(152)
        ) location('gpfdist://172.31.6.47:8080/region.csv') format 'TEXT' (DELIMITER as '|') encoding 'utf8';

        CREATE TABLE REGION (
                R_REGIONKEY     SERIAL8,
                R_NAME          CHAR(25),
                R_COMMENT       VARCHAR(152)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (r_regionkey);

      INSERT INTO REGION select * from EXT_REGION;

COMMIT;

BEGIN;
         CREATE EXTERNAL TABLE EXT_NATION (
                N_NATIONKEY             SERIAL8,
                N_NAME                  CHAR(25),
                N_REGIONKEY             BIGINT,
                N_COMMENT               VARCHAR(152)
        ) location('gpfdist://172.31.6.47:8080/nation.csv') format 'TEXT' (DELIMITER as '|') encoding 'utf8';

        CREATE TABLE NATION (
                N_NATIONKEY             SERIAL8,
                N_NAME                  CHAR(25),
                N_REGIONKEY             BIGINT NOT NULL,  -- references R_REGIONKEY
                N_COMMENT               VARCHAR(152)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (n_nationkey);

      INSERT INTO NATION select * from EXT_NATION;

COMMIT;

BEGIN;

	CREATE EXTERNAL TABLE EXT_SUPPLIER (
                S_SUPPKEY               SERIAL8,
                S_NAME                  CHAR(25),
                S_ADDRESS               VARCHAR(40),
                S_NATIONKEY             BIGINT , 
                S_PHONE                 CHAR(15),
                S_ACCTBAL               DECIMAL,
                S_COMMENT               VARCHAR(101)
        )  location('gpfdist://172.31.6.47:8080/supplier.csv') format 'TEXT' (DELIMITER as '|') encoding 'utf8';


        CREATE TABLE SUPPLIER (
                S_SUPPKEY               SERIAL8,
                S_NAME                  CHAR(25),
                S_ADDRESS               VARCHAR(40),
                S_NATIONKEY             BIGINT NOT NULL, -- references N_NATIONKEY
                S_PHONE                 CHAR(15),
                S_ACCTBAL               DECIMAL,
                S_COMMENT               VARCHAR(101)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (s_suppkey);


      INSERT INTO SUPPLIER select * from EXT_SUPPLIER;

COMMIT;

BEGIN;

	CREATE EXTERNAL TABLE EXT_CUSTOMER (
                C_CUSTKEY               SERIAL8,
                C_NAME                  VARCHAR(25),
                C_ADDRESS               VARCHAR(40),
                C_NATIONKEY             BIGINT , 
                C_PHONE                 CHAR(15),
                C_ACCTBAL               DECIMAL,
                C_MKTSEGMENT    CHAR(10),
                C_COMMENT               VARCHAR(117)
        )  location('gpfdist://172.31.6.47:8080/customer.csv') format 'TEXT' (DELIMITER as '|') encoding 'utf8';


        CREATE TABLE CUSTOMER (
                C_CUSTKEY               SERIAL8,
                C_NAME                  VARCHAR(25),
                C_ADDRESS               VARCHAR(40),
                C_NATIONKEY             BIGINT NOT NULL, -- references N_NATIONKEY
                C_PHONE                 CHAR(15),
                C_ACCTBAL               DECIMAL,
                C_MKTSEGMENT    CHAR(10),
                C_COMMENT               VARCHAR(117)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (c_custkey);


      	INSERT INTO CUSTOMER select * from EXT_CUSTOMER;

COMMIT;

BEGIN;

	CREATE EXTERNAL TABLE EXT_PARTSUPP (
                PS_PARTKEY              BIGINT, -- references P_PARTKEY
                PS_SUPPKEY              BIGINT, -- references S_SUPPKEY
                PS_AVAILQTY             INTEGER,
                PS_SUPPLYCOST   DECIMAL,
                PS_COMMENT              VARCHAR(199)
        ) location('gpfdist://172.31.6.47:8080/partsupp.csv') format 'TEXT' (DELIMITER as '|') encoding 'utf8';


        CREATE TABLE PARTSUPP (
                PS_PARTKEY              BIGINT NOT NULL, -- references P_PARTKEY
                PS_SUPPKEY              BIGINT NOT NULL, -- references S_SUPPKEY
                PS_AVAILQTY             INTEGER,
                PS_SUPPLYCOST   DECIMAL,
                PS_COMMENT              VARCHAR(199)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (ps_partkey,ps_suppkey);

      	INSERT INTO PARTSUPP select * from EXT_PARTSUPP;

COMMIT;

BEGIN;

	CREATE EXTERNAL TABLE EXT_ORDERS (
                O_ORDERKEY              SERIAL8,
                O_CUSTKEY               BIGINT, -- references C_CUSTKEY
                O_ORDERSTATUS   CHAR(1),
                O_TOTALPRICE    DECIMAL,
                O_ORDERDATE             DATE,
                O_ORDERPRIORITY CHAR(15),
                O_CLERK                 CHAR(15),
                O_SHIPPRIORITY  INTEGER,
                O_COMMENT               VARCHAR(79)
        ) location('gpfdist://172.31.6.47:8080/orders.csv') format 'TEXT' (DELIMITER as '|') encoding 'utf8';


        CREATE TABLE ORDERS (
                O_ORDERKEY              SERIAL8,
                O_CUSTKEY               BIGINT NOT NULL, -- references C_CUSTKEY
                O_ORDERSTATUS   CHAR(1),
                O_TOTALPRICE    DECIMAL,
                O_ORDERDATE             DATE,
                O_ORDERPRIORITY CHAR(15),
                O_CLERK                 CHAR(15),
                O_SHIPPRIORITY  INTEGER,
                O_COMMENT               VARCHAR(79)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (o_orderkey);

      	INSERT INTO ORDERS select * from EXT_ORDERS;
COMMIT;

BEGIN;
	
	CREATE EXTERNAL TABLE EXT_LINEITEM (
                L_ORDERKEY              BIGINT , -- references O_ORDERKEY
                L_PARTKEY               BIGINT , -- references P_PARTKEY (compound fk to PARTSUPP)
                L_SUPPKEY               BIGINT, -- references S_SUPPKEY (compound fk to PARTSUPP)
                L_LINENUMBER    INTEGER,
                L_QUANTITY              DECIMAL,
                L_EXTENDEDPRICE DECIMAL,
                L_DISCOUNT              DECIMAL,
                L_TAX                   DECIMAL,
                L_RETURNFLAG    CHAR(1),
                L_LINESTATUS    CHAR(1),
                L_SHIPDATE              DATE,
                L_COMMITDATE    DATE,
                L_RECEIPTDATE   DATE,
                L_SHIPINSTRUCT  CHAR(25),
                L_SHIPMODE              CHAR(10),
                L_COMMENT               VARCHAR(44)
        ) location('gpfdist://172.31.6.47:8080/lineitem.csv') format 'TEXT' (DELIMITER as '|') encoding 'utf8';


        CREATE TABLE LINEITEM (
                L_ORDERKEY              BIGINT NOT NULL, -- references O_ORDERKEY
                L_PARTKEY               BIGINT NOT NULL, -- references P_PARTKEY (compound fk to PARTSUPP)
                L_SUPPKEY               BIGINT NOT NULL, -- references S_SUPPKEY (compound fk to PARTSUPP)
                L_LINENUMBER    INTEGER,
                L_QUANTITY              DECIMAL,
                L_EXTENDEDPRICE DECIMAL,
                L_DISCOUNT              DECIMAL,
                L_TAX                   DECIMAL,
                L_RETURNFLAG    CHAR(1),
                L_LINESTATUS    CHAR(1),
                L_SHIPDATE              DATE,
                L_COMMITDATE    DATE,
                L_RECEIPTDATE   DATE,
                L_SHIPINSTRUCT  CHAR(25),
                L_SHIPMODE              CHAR(10),
                L_COMMENT               VARCHAR(44)
        )  with (APPENDONLY=true,BLOCKSIZE=2097152,ORIENTATION=COLUMN,CHECKSUM=true,OIDS=false) DISTRIBUTED BY (l_orderkey, l_linenumber);

      	INSERT INTO LINEITEM select * from EXT_LINEITEM;
COMMIT;
