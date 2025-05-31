--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: store; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA store;


ALTER SCHEMA store OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Categories; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Categories" (
    id integer NOT NULL,
    name character varying NOT NULL,
    parent_cat_id integer,
    description text
);


ALTER TABLE store."Categories" OWNER TO postgres;

--
-- Name: Customers; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Customers" (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    middle_name character varying(50),
    email character varying(100)
);


ALTER TABLE store."Customers" OWNER TO postgres;

--
-- Name: Order_Items; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Order_Items" (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,0) NOT NULL,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT order_items_unit_price_check CHECK ((unit_price > (0)::numeric))
);


ALTER TABLE store."Order_Items" OWNER TO postgres;

--
-- Name: Orders; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Orders" (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_amount numeric NOT NULL,
    status character varying DEFAULT 'Processing'::character varying,
    shipping_address text NOT NULL,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['Processing'::character varying, 'Shipped'::character varying, 'Delivered'::character varying, 'Cancelled'::character varying])::text[]))),
    CONSTRAINT orders_total_amount CHECK ((total_amount > (0)::numeric))
);


ALTER TABLE store."Orders" OWNER TO postgres;

--
-- Name: Payments; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Payments" (
    id integer NOT NULL,
    order_id integer NOT NULL,
    payment_method character varying(30) NOT NULL,
    amount numeric(12,0) NOT NULL,
    payment_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'Pending'::character varying,
    CONSTRAINT payments_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT payments_payment_method_check CHECK (((payment_method)::text = ANY ((ARRAY['Credit Card'::character varying, 'PayPal'::character varying, 'Bank Transfer'::character varying, 'Cash on Delivery'::character varying])::text[]))),
    CONSTRAINT payments_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Completed'::character varying, 'Failed'::character varying, 'Refunded'::character varying])::text[])))
);


ALTER TABLE store."Payments" OWNER TO postgres;

--
-- Name: Products; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Products" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    category_id integer NOT NULL,
    price numeric(10,0),
    stock_quantity integer DEFAULT 0 NOT NULL,
    supplier_id integer NOT NULL,
    CONSTRAINT products_price_check CHECK ((price > (0)::numeric)),
    CONSTRAINT products_stock_quantity_check CHECK ((stock_quantity >= 0))
);


ALTER TABLE store."Products" OWNER TO postgres;

--
-- Name: Suppliers; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store."Suppliers" (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    address text NOT NULL
);


ALTER TABLE store."Suppliers" OWNER TO postgres;

--
-- Data for Name: Categories; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Categories" (id, name, parent_cat_id, description) FROM stdin;
\.


--
-- Data for Name: Customers; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Customers" (id, first_name, last_name, middle_name, email) FROM stdin;
\.


--
-- Data for Name: Order_Items; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Order_Items" (id, order_id, product_id, quantity, unit_price) FROM stdin;
\.


--
-- Data for Name: Orders; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Orders" (id, customer_id, order_date, total_amount, status, shipping_address) FROM stdin;
\.


--
-- Data for Name: Payments; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Payments" (id, order_id, payment_method, amount, payment_date, status) FROM stdin;
\.


--
-- Data for Name: Products; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Products" (id, name, category_id, price, stock_quantity, supplier_id) FROM stdin;
\.


--
-- Data for Name: Suppliers; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store."Suppliers" (id, name, email, address) FROM stdin;
\.


--
-- Name: Categories Categories_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Categories"
    ADD CONSTRAINT "Categories_pkey" PRIMARY KEY (id);


--
-- Name: Customers Customers_email_key; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Customers"
    ADD CONSTRAINT "Customers_email_key" UNIQUE (email);


--
-- Name: Customers Customers_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Customers"
    ADD CONSTRAINT "Customers_pkey" PRIMARY KEY (id);


--
-- Name: Order_Items Order_Items_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Order_Items"
    ADD CONSTRAINT "Order_Items_pkey" PRIMARY KEY (id);


--
-- Name: Orders Orders_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Orders"
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- Name: Payments Payments_order_id_key; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Payments"
    ADD CONSTRAINT "Payments_order_id_key" UNIQUE (order_id);


--
-- Name: Payments Payments_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Payments"
    ADD CONSTRAINT "Payments_pkey" PRIMARY KEY (id);


--
-- Name: Products Products_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Products"
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (id);


--
-- Name: Suppliers Suppliers_email_key; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Suppliers"
    ADD CONSTRAINT "Suppliers_email_key" UNIQUE (email);


--
-- Name: Suppliers Suppliers_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Suppliers"
    ADD CONSTRAINT "Suppliers_pkey" PRIMARY KEY (id);


--
-- Name: Categories Categories_parent_cat_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Categories"
    ADD CONSTRAINT "Categories_parent_cat_id_fkey" FOREIGN KEY (parent_cat_id) REFERENCES store."Categories"(id) NOT VALID;


--
-- Name: Order_Items Order_Items_order_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Order_Items"
    ADD CONSTRAINT "Order_Items_order_id_fkey" FOREIGN KEY (order_id) REFERENCES store."Orders"(id);


--
-- Name: Order_Items Order_Items_product_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Order_Items"
    ADD CONSTRAINT "Order_Items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES store."Products"(id);


--
-- Name: Orders Orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Orders"
    ADD CONSTRAINT "Orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES store."Customers"(id);


--
-- Name: Payments Payments_order_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Payments"
    ADD CONSTRAINT "Payments_order_id_fkey" FOREIGN KEY (order_id) REFERENCES store."Orders"(id);


--
-- Name: Products Products_category_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Products"
    ADD CONSTRAINT "Products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES store."Categories"(id);


--
-- Name: Products Products_supplier_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store."Products"
    ADD CONSTRAINT "Products_supplier_id_fkey" FOREIGN KEY (supplier_id) REFERENCES store."Suppliers"(id);


--
-- PostgreSQL database dump complete
--

