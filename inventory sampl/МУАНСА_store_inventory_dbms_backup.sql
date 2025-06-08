--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8
-- Dumped by pg_dump version 16.8

-- Started on 2025-06-09 02:11:43

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
-- TOC entry 6 (class 2615 OID 16592)
-- Name: store; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA store;


ALTER SCHEMA store OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16609)
-- Name: categories; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.categories (
    id integer NOT NULL,
    name character varying NOT NULL,
    parent_cat_id integer,
    description text
);


ALTER TABLE store.categories OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16700)
-- Name: customer_order_history; Type: VIEW; Schema: store; Owner: postgres
--

CREATE VIEW store.customer_order_history AS
SELECT
    NULL::integer AS id,
    NULL::text AS customer_name,
    NULL::bigint AS total_orders,
    NULL::numeric AS total_spent,
    NULL::timestamp without time zone AS last_order_date;


ALTER VIEW store.customer_order_history OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16593)
-- Name: customers; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.customers (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    middle_name character varying(50),
    email character varying(100)
);


ALTER TABLE store.customers OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16661)
-- Name: order_items; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,0) NOT NULL,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT order_items_unit_price_check CHECK ((unit_price > (0)::numeric))
);


ALTER TABLE store.order_items OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16645)
-- Name: orders; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.orders (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_amount numeric NOT NULL,
    status character varying DEFAULT 'Processing'::character varying,
    shipping_address text NOT NULL,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['Processing'::character varying, 'Shipped'::character varying, 'Delivered'::character varying, 'Cancelled'::character varying])::text[]))),
    CONSTRAINT orders_total_amount CHECK ((total_amount > (0)::numeric))
);


ALTER TABLE store.orders OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16678)
-- Name: payments; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.payments (
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


ALTER TABLE store.payments OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16705)
-- Name: product_sales_report; Type: VIEW; Schema: store; Owner: postgres
--

CREATE VIEW store.product_sales_report AS
SELECT
    NULL::integer AS id,
    NULL::character varying(100) AS product_name,
    NULL::bigint AS total_sold,
    NULL::numeric AS total_revenue,
    NULL::character varying(100) AS supplier_name;


ALTER VIEW store.product_sales_report OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16624)
-- Name: products; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.products (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    category_id integer NOT NULL,
    price numeric(10,0),
    stock_quantity integer DEFAULT 0 NOT NULL,
    supplier_id integer NOT NULL,
    CONSTRAINT products_price_check CHECK ((price > (0)::numeric)),
    CONSTRAINT products_stock_quantity_check CHECK ((stock_quantity >= 0))
);


ALTER TABLE store.products OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16600)
-- Name: suppliers; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.suppliers (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    address text NOT NULL
);


ALTER TABLE store.suppliers OWNER TO postgres;

--
-- TOC entry 4983 (class 0 OID 16609)
-- Dependencies: 218
-- Data for Name: categories; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.categories (id, name, parent_cat_id, description) FROM stdin;
1	Electronics	\N	Devices and gadgets
2	Clothing	\N	Apparel and fashion items
3	Home & Kitchen	\N	Household essentials
4	Books	\N	Printed and digital media
5	Sports & Outdoors	\N	Equipment for active lifestyles
6	Smartphones	1	Mobile communication devices
7	Laptops	1	Portable computers
8	Headphones	1	Audio listening devices
9	Men's Clothing	2	Apparel for men
10	Women's Clothing	2	Apparel for women
11	Cookware	3	Pots, pans, and cooking tools
12	Furniture	3	Home furnishings
13	Fiction	4	Novels and stories
14	Non-Fiction	4	Fact-based literature
15	Fitness	5	Exercise equipment
16	Camping	5	Outdoor adventure gear
17	Tablets	1	Portable touchscreen devices
18	Smartwatches	1	Wearable technology
19	TVs	1	Television sets
20	Cameras	1	Photography equipment
21	Kids' Clothing	2	Apparel for children
22	Footwear	2	Shoes and boots
23	Jewelry	2	Accessories and adornments
24	Bedding	3	Bed linens and pillows
25	Bath	3	Bathroom essentials
26	Lighting	3	Lamps and fixtures
27	Science Fiction	13	Futuristic and speculative fiction
28	Mystery	13	Crime and detective stories
29	Romance	13	Love and relationship stories
30	Biography	14	Life stories of real people
31	History	14	Accounts of past events
32	Self-Help	14	Personal development books
33	Yoga	15	Mind-body exercise equipment
34	Cycling	15	Bikes and accessories
35	Running	15	Jogging and marathon gear
36	Tents	16	Portable shelters
37	Sleeping Bags	16	Outdoor bedding
38	Hiking	16	Trail equipment
39	Printers	1	Document printing devices
40	Gaming	1	Video game consoles and accessories
41	Accessories	1	Electronic add-ons
42	Underwear	2	Lingerie and undergarments
43	Swimwear	2	Beach and pool clothing
44	Pet Supplies	\N	Products for animals
45	Toys & Games	\N	Entertainment products
46	Automotive	\N	Vehicle accessories
47	Tools	\N	Hardware and DIY equipment
48	Groceries	\N	Food and beverages
49	Health	\N	Wellness products
50	Beauty	\N	Cosmetics and skincare
\.


--
-- TOC entry 4981 (class 0 OID 16593)
-- Dependencies: 216
-- Data for Name: customers; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.customers (id, first_name, last_name, middle_name, email) FROM stdin;
1	John	Smith	\N	john.smith@example.com
2	Emily	Johnson	Anne	emily.johnson@example.com
3	Michael	Williams	James	michael.williams@example.com
4	Sarah	Brown	Marie	sarah.brown@example.com
5	David	Jones	Robert	david.jones@example.com
6	Jennifer	Garcia	Louise	jennifer.garcia@example.com
7	Robert	Miller	Thomas	robert.miller@example.com
8	Lisa	Davis	Ann	lisa.davis@example.com
9	James	Rodriguez	Patrick	james.rodriguez@example.com
10	Jessica	Martinez	Grace	jessica.martinez@example.com
11	Daniel	Hernandez	Joseph	daniel.hernandez@example.com
12	Amanda	Lopez	Rose	amanda.lopez@example.com
13	Christopher	Gonzalez	Michael	christopher.gonzalez@example.com
14	Ashley	Wilson	Nicole	ashley.wilson@example.com
15	Matthew	Anderson	Paul	matthew.anderson@example.com
16	Nicole	Thomas	Elizabeth	nicole.thomas@example.com
17	Andrew	Taylor	Scott	andrew.taylor@example.com
18	Stephanie	Moore	Michelle	stephanie.moore@example.com
19	Joshua	Jackson	Ryan	joshua.jackson@example.com
20	Megan	Martin	Kayla	megan.martin@example.com
21	Kevin	Lee	Alexander	kevin.lee@example.com
22	Rachel	Perez	Danielle	rachel.perez@example.com
23	Brian	Thompson	William	brian.thompson@example.com
24	Lauren	White	Victoria	lauren.white@example.com
25	Justin	Harris	Daniel	justin.harris@example.com
26	Kayla	Sanchez	Alexis	kayla.sanchez@example.com
27	Brandon	Clark	Christopher	brandon.clark@example.com
28	Rebecca	Ramirez	Samantha	rebecca.ramirez@example.com
29	Ryan	Lewis	Matthew	ryan.lewis@example.com
30	Samantha	Robinson	Amber	samantha.robinson@example.com
31	Nathan	Walker	Jonathan	nathan.walker@example.com
32	Hannah	Young	Brittany	hannah.young@example.com
33	Jacob	Allen	Nicholas	jacob.allen@example.com
34	Victoria	King	Olivia	victoria.king@example.com
35	Tyler	Wright	Samuel	tyler.wright@example.com
36	Amber	Scott	Taylor	amber.scott@example.com
37	Nicholas	Torres	Ethan	nicholas.torres@example.com
38	Brittany	Nguyen	Maria	brittany.nguyen@example.com
39	Jonathan	Hill	Christian	jonathan.hill@example.com
40	Olivia	Flores	Julia	olivia.flores@example.com
41	Samuel	Green	Austin	samuel.green@example.com
42	Taylor	Adams	Cody	taylor.adams@example.com
43	Ethan	Nelson	Brandon	ethan.nelson@example.com
44	Alexis	Baker	Justin	alexis.baker@example.com
45	Cody	Hall	Nathan	cody.hall@example.com
46	Allison	Rivera	Joshua	allison.rivera@example.com
47	Austin	Campbell	Andrew	austin.campbell@example.com
48	Maria	Mitchell	Kevin	maria.mitchell@example.com
49	Christian	Carter	Jacob	christian.carter@example.com
50	Julia	Roberts	Tyler	julia.roberts@example.com
\.


--
-- TOC entry 4986 (class 0 OID 16661)
-- Dependencies: 221
-- Data for Name: order_items; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.order_items (id, order_id, product_id, quantity, unit_price) FROM stdin;
1	1	1	1	1000
2	2	30	1	130
3	3	5	1	350
4	4	6	1	60
5	5	3	1	2500
6	6	7	1	50
7	7	9	1	900
8	8	10	1	13
9	9	11	1	30
10	10	12	1	200
11	11	13	1	600
12	12	14	1	400
13	13	15	1	1600
14	14	16	1	3500
15	15	17	1	25
16	16	18	1	90
17	17	19	1	80
18	18	20	1	40
19	19	21	1	11
20	20	22	1	12
21	21	23	1	10
22	22	24	1	15
23	23	25	1	19
24	24	26	1	14
25	25	27	1	20
26	26	28	1	500
27	27	29	1	80
28	28	30	1	130
29	29	31	1	90
30	30	32	1	250
31	31	33	1	140
32	32	34	1	130
33	33	35	1	90
34	34	36	1	200
35	35	37	1	500
36	36	38	1	20
37	37	39	1	25
38	38	40	1	40
39	39	41	1	50
40	40	42	1	60
41	41	43	1	70
42	42	44	1	80
43	43	45	1	90
44	44	46	1	100
45	45	47	1	110
46	46	48	1	120
47	47	49	1	130
48	48	50	1	140
49	49	1	1	150
50	50	2	1	160
51	51	6	1	60
52	51	7	1	50
53	52	5	1	350
54	52	11	2	30
55	53	3	1	2500
56	54	6	1	60
57	55	7	1	50
58	55	10	1	13
59	55	11	1	30
60	56	5	1	350
61	57	6	1	60
62	57	7	1	50
63	58	12	1	200
64	59	6	1	60
65	59	7	1	50
66	59	10	1	13
67	60	7	1	50
68	60	10	1	13
69	60	11	1	30
70	60	17	1	25
71	61	17	1	25
72	62	20	1	40
73	63	19	1	80
74	64	6	1	60
75	64	7	1	50
76	64	10	1	13
77	64	11	1	30
78	65	18	1	90
79	66	12	1	200
80	67	6	1	60
81	67	7	1	50
82	67	10	1	13
83	68	33	1	140
84	69	6	1	60
85	69	7	1	50
86	69	10	1	13
87	70	32	1	250
88	71	6	1	60
89	71	7	1	50
90	72	34	1	130
91	73	37	1	500
92	74	6	1	60
93	74	7	1	50
94	74	10	1	13
95	75	20	1	40
96	76	3	1	2500
97	76	5	1	350
98	76	11	1	30
99	77	6	1	60
100	77	7	1	50
101	78	18	1	90
102	79	45	1	110
103	80	7	1	50
104	80	10	1	13
105	80	11	1	30
106	80	17	1	25
107	81	46	1	140
108	82	6	1	60
109	82	7	1	50
110	82	10	1	13
111	83	6	1	60
112	83	7	1	50
113	84	6	1	60
114	84	7	1	50
115	84	10	1	13
116	85	17	3	25
117	86	20	1	40
118	87	6	1	60
119	87	7	1	50
120	87	10	1	13
121	88	6	1	60
122	88	7	1	50
123	89	6	1	60
124	89	7	1	50
125	89	10	1	13
126	90	12	1	200
127	91	33	1	140
128	92	6	1	60
129	92	7	1	50
130	93	32	1	250
131	94	6	1	60
132	94	7	1	50
133	95	34	1	130
134	96	37	1	500
135	97	6	1	60
136	97	7	1	50
137	97	10	1	13
138	98	20	1	40
139	99	3	1	2500
140	99	5	1	350
141	99	11	1	30
142	100	6	1	60
143	100	7	1	50
144	101	18	1	90
145	102	45	1	110
146	103	7	1	50
147	103	10	1	13
148	103	11	1	30
149	103	17	1	25
150	104	46	1	140
151	105	6	1	60
152	105	7	1	50
153	105	10	1	13
154	106	6	1	60
155	106	7	1	50
156	107	6	1	60
157	107	7	1	50
158	107	10	1	13
159	108	17	3	25
160	109	20	1	40
161	110	6	1	60
162	110	7	1	50
163	110	10	1	13
164	111	6	1	60
165	111	7	1	50
166	112	6	1	60
167	112	7	1	50
168	112	10	1	13
169	113	12	1	200
170	114	33	1	140
171	115	6	1	60
172	115	7	1	50
173	116	32	1	250
174	117	6	1	60
175	117	7	1	50
176	118	34	1	130
177	119	37	1	500
178	120	6	1	60
179	120	7	1	50
180	120	10	1	13
181	121	20	1	40
182	122	3	1	2500
183	122	5	1	350
184	122	11	1	30
185	123	6	1	60
186	123	7	1	50
187	124	18	1	90
188	125	45	1	110
\.


--
-- TOC entry 4985 (class 0 OID 16645)
-- Dependencies: 220
-- Data for Name: orders; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.orders (id, customer_id, order_date, total_amount, status, shipping_address) FROM stdin;
1	1	2023-01-10 09:15:00	999.99	Delivered	123 Main St, Anytown, USA
2	2	2023-01-12 14:30:00	129.99	Delivered	456 Oak Ave, Somewhere, USA
3	3	2023-01-15 11:45:00	349.99	Delivered	789 Pine Rd, Nowhere, USA
4	4	2023-01-18 16:20:00	59.99	Delivered	321 Elm St, Anywhere, USA
5	5	2023-01-20 13:10:00	2499.99	Delivered	654 Maple Dr, Everywhere, USA
6	6	2023-01-22 10:05:00	49.99	Delivered	987 Cedar Ln, Someplace, USA
7	7	2023-01-25 15:30:00	899.99	Delivered	159 Birch Blvd, Noplace, USA
8	8	2023-01-28 12:40:00	12.99	Delivered	753 Walnut Ave, Yourtown, USA
9	9	2023-02-01 09:55:00	29.99	Delivered	852 Spruce Way, Theirtown, USA
10	10	2023-02-03 14:15:00	199.99	Delivered	147 Cherry St, Ourville, USA
11	11	2023-02-05 11:25:00	599.99	Delivered	369 Apple Rd, Yourville, USA
12	12	2023-02-08 16:50:00	399.99	Delivered	741 Orange Dr, Theirville, USA
13	13	2023-02-10 13:35:00	1599.99	Delivered	963 Peach Ln, Thisplace, USA
14	14	2023-02-12 10:20:00	3499.99	Delivered	258 Plum Blvd, Thatplace, USA
15	15	2023-02-15 15:45:00	24.99	Delivered	654 Grape Ave, Hereville, USA
16	16	2023-02-18 12:55:00	89.99	Delivered	852 Lemon St, Thereville, USA
17	17	2023-02-20 09:10:00	79.99	Delivered	159 Lime Rd, Wherever, USA
18	18	2023-02-22 14:30:00	39.99	Delivered	753 Kiwi Dr, Elsewhere, USA
19	19	2023-02-25 11:40:00	10.99	Delivered	147 Mango Ln, Anywhere, USA
20	20	2023-02-28 16:05:00	11.99	Delivered	369 Berry Blvd, Nowhere, USA
21	21	2023-03-03 13:15:00	9.99	Delivered	741 Melon Ave, Somewhere, USA
22	22	2023-03-06 10:25:00	14.99	Delivered	963 Papaya St, Everywhere, USA
23	23	2023-03-09 15:50:00	18.99	Delivered	258 Coconut Rd, Yourtown, USA
24	24	2023-03-12 12:00:00	13.99	Delivered	654 Banana Dr, Theirtown, USA
25	25	2023-03-15 09:20:00	19.99	Delivered	852 Avocado Ln, Ourville, USA
26	26	2023-03-18 14:40:00	499.99	Delivered	159 Guava Blvd, Yourville, USA
27	27	2023-03-21 11:50:00	79.99	Delivered	753 Fig Ave, Theirville, USA
28	28	2023-03-24 16:15:00	129.99	Delivered	147 Date St, Thisplace, USA
29	29	2023-03-27 13:25:00	89.99	Delivered	369 Pear Rd, Thatplace, USA
30	30	2023-03-30 10:35:00	249.99	Delivered	741 Olive Dr, Hereville, USA
31	31	2023-04-02 15:00:00	139.99	Delivered	963 Peach St, Thereville, USA
32	32	2023-04-05 12:10:00	129.99	Delivered	258 Apricot Blvd, Wherever, USA
33	33	2023-04-08 09:30:00	89.99	Delivered	654 Nectarine Ave, Elsewhere, USA
34	34	2023-04-11 14:50:00	199.99	Delivered	852 Plum Rd, Anywhere, USA
35	35	2023-04-14 11:00:00	499.99	Delivered	159 Cherry Dr, Nowhere, USA
36	36	2023-04-17 16:25:00	19.99	Delivered	753 Apple Ln, Somewhere, USA
37	37	2023-04-20 13:35:00	24.99	Delivered	147 Orange Blvd, Everywhere, USA
38	38	2023-04-23 10:45:00	39.99	Delivered	369 Banana Ave, Yourtown, USA
39	39	2023-04-26 15:55:00	49.99	Delivered	741 Grape Rd, Theirtown, USA
40	40	2023-04-29 12:05:00	59.99	Delivered	963 Lemon Dr, Ourville, USA
41	41	2023-05-02 09:15:00	69.99	Delivered	258 Lime Ln, Yourville, USA
42	42	2023-05-05 14:25:00	79.99	Delivered	654 Kiwi Blvd, Theirville, USA
43	43	2023-05-08 11:35:00	89.99	Delivered	852 Mango Ave, Thisplace, USA
44	44	2023-05-11 16:45:00	99.99	Delivered	159 Berry St, Thatplace, USA
45	45	2023-05-14 13:55:00	109.99	Delivered	753 Melon Rd, Hereville, USA
46	46	2023-05-17 10:05:00	119.99	Delivered	147 Papaya Dr, Thereville, USA
47	47	2023-05-20 15:15:00	129.99	Delivered	369 Coconut Ln, Wherever, USA
48	48	2023-05-23 12:25:00	139.99	Delivered	741 Banana Blvd, Elsewhere, USA
49	49	2023-05-26 09:35:00	149.99	Delivered	963 Avocado Ave, Anywhere, USA
50	50	2023-05-29 14:45:00	159.99	Delivered	258 Guava Rd, Nowhere, USA
51	1	2023-06-05 09:30:00	89.98	Delivered	123 Main St, Anytown, USA
52	3	2023-06-07 14:15:00	179.97	Shipped	789 Pine Rd, Nowhere, USA
53	5	2023-06-10 11:20:00	249.99	Delivered	654 Maple Dr, Everywhere, USA
54	2	2023-06-12 16:45:00	59.99	Delivered	456 Oak Ave, Somewhere, USA
55	1	2023-06-15 13:10:00	129.98	Processing	123 Main St, Anytown, USA
56	7	2023-06-18 10:05:00	349.99	Delivered	159 Birch Blvd, Noplace, USA
57	4	2023-06-20 15:30:00	79.98	Shipped	321 Elm St, Anywhere, USA
58	10	2023-06-22 12:40:00	199.99	Delivered	147 Cherry St, Ourville, USA
59	1	2023-06-25 09:55:00	89.97	Delivered	123 Main St, Anytown, USA
60	12	2023-06-28 14:15:00	119.98	Processing	741 Orange Dr, Theirville, USA
61	15	2023-07-01 11:25:00	24.99	Delivered	654 Grape Ave, Hereville, USA
62	8	2023-07-03 16:50:00	39.99	Shipped	753 Walnut Ave, Yourtown, USA
63	20	2023-07-05 13:35:00	79.99	Delivered	369 Berry Blvd, Nowhere, USA
64	1	2023-07-08 10:20:00	149.97	Delivered	123 Main St, Anytown, USA
65	22	2023-07-10 15:45:00	89.99	Processing	963 Papaya St, Everywhere, USA
66	25	2023-07-12 12:55:00	199.99	Delivered	852 Avocado Ln, Ourville, USA
67	3	2023-07-15 09:10:00	129.98	Shipped	789 Pine Rd, Nowhere, USA
68	28	2023-07-18 14:30:00	139.99	Delivered	147 Date St, Thisplace, USA
69	5	2023-07-20 11:40:00	179.97	Delivered	654 Maple Dr, Everywhere, USA
70	30	2023-07-22 16:05:00	249.99	Processing	741 Olive Dr, Hereville, USA
71	1	2023-07-25 13:15:00	99.98	Delivered	123 Main St, Anytown, USA
72	32	2023-07-28 10:25:00	129.99	Shipped	258 Apricot Blvd, Wherever, USA
73	35	2023-07-30 15:50:00	499.99	Delivered	159 Cherry Dr, Nowhere, USA
74	7	2023-08-02 12:00:00	199.98	Delivered	159 Birch Blvd, Noplace, USA
75	38	2023-08-05 09:20:00	39.99	Processing	369 Banana Ave, Yourtown, USA
76	10	2023-08-08 14:40:00	299.97	Delivered	147 Cherry St, Ourville, USA
77	1	2023-08-10 11:50:00	89.98	Shipped	123 Main St, Anytown, USA
78	42	2023-08-13 16:15:00	79.99	Delivered	654 Kiwi Blvd, Theirville, USA
79	45	2023-08-15 13:25:00	109.99	Delivered	753 Melon Rd, Hereville, USA
80	12	2023-08-18 10:35:00	119.98	Processing	741 Orange Dr, Theirville, USA
81	48	2023-08-20 15:00:00	139.99	Delivered	741 Banana Blvd, Elsewhere, USA
82	3	2023-08-23 12:10:00	149.97	Shipped	789 Pine Rd, Nowhere, USA
83	1	2023-08-25 09:30:00	99.98	Delivered	123 Main St, Anytown, USA
84	5	2023-08-28 14:50:00	179.97	Delivered	654 Maple Dr, Everywhere, USA
85	15	2023-08-30 11:00:00	74.97	Processing	654 Grape Ave, Hereville, USA
86	18	2023-09-02 16:25:00	39.99	Delivered	753 Kiwi Dr, Elsewhere, USA
87	20	2023-09-05 13:35:00	159.98	Shipped	369 Berry Blvd, Nowhere, USA
88	1	2023-09-08 10:45:00	89.98	Delivered	123 Main St, Anytown, USA
89	22	2023-09-10 15:55:00	179.97	Delivered	963 Papaya St, Everywhere, USA
90	25	2023-09-13 12:05:00	199.99	Processing	852 Avocado Ln, Ourville, USA
91	28	2023-09-15 09:15:00	139.99	Delivered	147 Date St, Thisplace, USA
92	3	2023-09-18 14:25:00	129.98	Shipped	789 Pine Rd, Nowhere, USA
93	30	2023-09-20 11:35:00	249.99	Delivered	741 Olive Dr, Hereville, USA
94	1	2023-09-23 16:45:00	99.98	Delivered	123 Main St, Anytown, USA
95	32	2023-09-25 13:55:00	129.99	Processing	258 Apricot Blvd, Wherever, USA
96	35	2023-09-28 10:05:00	499.99	Delivered	159 Cherry Dr, Nowhere, USA
97	7	2023-09-30 15:15:00	199.98	Shipped	159 Birch Blvd, Noplace, USA
98	38	2023-10-03 12:25:00	39.99	Delivered	369 Banana Ave, Yourtown, USA
99	10	2023-10-05 09:35:00	299.97	Delivered	147 Cherry St, Ourville, USA
100	1	2023-10-08 14:45:00	89.98	Processing	123 Main St, Anytown, USA
101	42	2023-10-10 11:55:00	79.99	Delivered	654 Kiwi Blvd, Theirville, USA
102	45	2023-10-13 16:05:00	109.99	Shipped	753 Melon Rd, Hereville, USA
103	12	2023-10-15 13:15:00	119.98	Delivered	741 Orange Dr, Theirville, USA
104	48	2023-10-18 10:25:00	139.99	Delivered	741 Banana Blvd, Elsewhere, USA
105	3	2023-10-20 15:35:00	149.97	Processing	789 Pine Rd, Nowhere, USA
106	1	2023-10-23 12:45:00	99.98	Delivered	123 Main St, Anytown, USA
107	5	2023-10-25 09:55:00	179.97	Shipped	654 Maple Dr, Everywhere, USA
108	15	2023-10-28 14:05:00	74.97	Delivered	654 Grape Ave, Hereville, USA
109	18	2023-10-30 11:15:00	39.99	Delivered	753 Kiwi Dr, Elsewhere, USA
110	20	2023-11-02 16:25:00	159.98	Processing	369 Berry Blvd, Nowhere, USA
111	1	2023-11-05 13:35:00	89.98	Delivered	123 Main St, Anytown, USA
112	22	2023-11-08 10:45:00	179.97	Shipped	963 Papaya St, Everywhere, USA
113	25	2023-11-10 15:55:00	199.99	Delivered	852 Avocado Ln, Ourville, USA
114	28	2023-11-13 12:05:00	139.99	Delivered	147 Date St, Thisplace, USA
115	3	2023-11-16 09:15:00	129.98	Processing	789 Pine Rd, Nowhere, USA
116	30	2023-11-18 14:25:00	249.99	Delivered	741 Olive Dr, Hereville, USA
117	1	2023-11-21 11:35:00	99.98	Shipped	123 Main St, Anytown, USA
118	32	2023-11-23 16:45:00	129.99	Delivered	258 Apricot Blvd, Wherever, USA
119	35	2023-11-26 13:55:00	499.99	Delivered	159 Cherry Dr, Nowhere, USA
120	7	2023-11-29 10:05:00	199.98	Processing	159 Birch Blvd, Noplace, USA
121	38	2023-12-02 15:15:00	39.99	Delivered	369 Banana Ave, Yourtown, USA
122	10	2023-12-05 12:25:00	299.97	Shipped	147 Cherry St, Ourville, USA
123	1	2023-12-08 09:35:00	89.98	Delivered	123 Main St, Anytown, USA
124	42	2023-12-10 14:45:00	79.99	Delivered	654 Kiwi Blvd, Theirville, USA
125	45	2023-12-13 11:55:00	109.99	Processing	753 Melon Rd, Hereville, USA
\.


--
-- TOC entry 4987 (class 0 OID 16678)
-- Dependencies: 222
-- Data for Name: payments; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.payments (id, order_id, payment_method, amount, payment_date, status) FROM stdin;
51	51	Credit Card	90	2023-06-05 09:35:00	Completed
52	52	PayPal	180	2023-06-07 14:20:00	Completed
53	53	Credit Card	250	2023-06-10 11:25:00	Completed
54	54	Bank Transfer	60	2023-06-12 16:50:00	Completed
55	55	Credit Card	130	2023-06-15 13:15:00	Pending
56	56	PayPal	350	2023-06-18 10:10:00	Completed
57	57	Credit Card	80	2023-06-20 15:35:00	Completed
58	58	Bank Transfer	200	2023-06-22 12:45:00	Completed
59	59	Credit Card	90	2023-06-25 10:00:00	Completed
60	60	PayPal	120	2023-06-28 14:20:00	Pending
61	61	Credit Card	25	2023-07-01 11:30:00	Completed
62	62	Bank Transfer	40	2023-07-03 16:55:00	Completed
63	63	Credit Card	80	2023-07-05 13:40:00	Completed
64	64	PayPal	150	2023-07-08 10:25:00	Completed
65	65	Credit Card	90	2023-07-10 15:50:00	Pending
66	66	Bank Transfer	200	2023-07-12 13:00:00	Completed
67	67	Credit Card	130	2023-07-15 09:15:00	Completed
68	68	PayPal	140	2023-07-18 14:35:00	Completed
69	69	Credit Card	180	2023-07-20 11:45:00	Completed
70	70	Bank Transfer	250	2023-07-22 16:10:00	Pending
71	71	Credit Card	100	2023-07-25 13:20:00	Completed
72	72	PayPal	130	2023-07-28 10:30:00	Completed
73	73	Credit Card	500	2023-07-30 15:55:00	Completed
74	74	Bank Transfer	200	2023-08-02 12:05:00	Completed
75	75	Credit Card	40	2023-08-05 09:25:00	Pending
76	76	PayPal	300	2023-08-08 14:45:00	Completed
77	77	Credit Card	90	2023-08-10 11:55:00	Completed
78	78	Bank Transfer	80	2023-08-13 16:20:00	Completed
79	79	Credit Card	110	2023-08-15 13:30:00	Completed
80	80	PayPal	120	2023-08-18 10:40:00	Pending
81	81	Credit Card	140	2023-08-20 15:05:00	Completed
82	82	Bank Transfer	150	2023-08-23 12:15:00	Completed
83	83	Credit Card	100	2023-08-25 09:35:00	Completed
84	84	PayPal	180	2023-08-28 14:55:00	Completed
85	85	Credit Card	75	2023-08-30 11:05:00	Pending
86	86	Bank Transfer	40	2023-09-02 16:30:00	Completed
87	87	Credit Card	160	2023-09-05 13:40:00	Completed
88	88	PayPal	90	2023-09-08 10:50:00	Completed
89	89	Credit Card	180	2023-09-10 16:00:00	Completed
90	90	Bank Transfer	200	2023-09-13 12:10:00	Pending
91	91	Credit Card	140	2023-09-15 09:20:00	Completed
92	92	PayPal	130	2023-09-18 14:30:00	Completed
93	93	Credit Card	250	2023-09-20 11:40:00	Completed
94	94	Bank Transfer	100	2023-09-23 16:50:00	Completed
95	95	Credit Card	130	2023-09-25 13:00:00	Pending
96	96	PayPal	500	2023-09-28 10:10:00	Completed
97	97	Credit Card	200	2023-09-30 15:20:00	Completed
98	98	Bank Transfer	40	2023-10-03 12:30:00	Completed
99	99	Credit Card	300	2023-10-05 09:40:00	Completed
100	100	PayPal	90	2023-10-08 14:50:00	Pending
1	1	Credit Card	1000	2023-01-10 09:20:00	Completed
2	2	PayPal	130	2023-01-12 14:35:00	Completed
3	3	Bank Transfer	350	2023-01-15 11:50:00	Completed
4	4	Credit Card	60	2023-01-18 16:25:00	Completed
5	5	Credit Card	2500	2023-01-20 13:15:00	Completed
6	6	PayPal	50	2023-01-22 10:10:00	Completed
7	7	Bank Transfer	900	2023-01-25 15:35:00	Completed
8	8	Credit Card	13	2023-01-28 12:45:00	Completed
9	9	PayPal	30	2023-02-01 10:00:00	Completed
10	10	Credit Card	200	2023-02-03 14:20:00	Completed
11	11	Bank Transfer	600	2023-02-05 11:30:00	Completed
12	12	Credit Card	400	2023-02-08 16:55:00	Completed
13	13	PayPal	1600	2023-02-10 13:40:00	Completed
14	14	Credit Card	3500	2023-02-12 10:25:00	Completed
15	15	Bank Transfer	25	2023-02-15 15:50:00	Completed
16	16	Credit Card	90	2023-02-18 13:00:00	Completed
17	17	PayPal	80	2023-02-20 09:15:00	Completed
18	18	Credit Card	40	2023-02-22 14:35:00	Completed
19	19	Bank Transfer	11	2023-02-25 11:45:00	Completed
20	20	Credit Card	12	2023-02-28 16:10:00	Completed
21	21	PayPal	10	2023-03-03 13:20:00	Completed
22	22	Credit Card	15	2023-03-06 10:30:00	Completed
23	23	Bank Transfer	19	2023-03-09 15:55:00	Completed
24	24	Credit Card	14	2023-03-12 12:05:00	Completed
25	25	PayPal	20	2023-03-15 09:25:00	Completed
26	26	Credit Card	500	2023-03-18 14:45:00	Completed
27	27	Bank Transfer	80	2023-03-21 11:55:00	Completed
28	28	Credit Card	130	2023-03-24 16:20:00	Completed
29	29	PayPal	90	2023-03-27 13:30:00	Completed
30	30	Credit Card	250	2023-03-30 10:40:00	Completed
31	31	Bank Transfer	140	2023-04-02 15:05:00	Completed
32	32	Credit Card	130	2023-04-05 12:15:00	Completed
33	33	PayPal	90	2023-04-08 09:35:00	Completed
34	34	Credit Card	200	2023-04-11 14:55:00	Completed
35	35	Bank Transfer	500	2023-04-14 11:05:00	Completed
36	36	Credit Card	20	2023-04-17 16:30:00	Completed
37	37	PayPal	25	2023-04-20 13:40:00	Completed
38	38	Credit Card	40	2023-04-23 10:50:00	Completed
39	39	Bank Transfer	50	2023-04-26 16:00:00	Completed
40	40	Credit Card	60	2023-04-29 12:10:00	Completed
41	41	PayPal	70	2023-05-02 09:20:00	Completed
42	42	Credit Card	80	2023-05-05 14:30:00	Completed
43	43	Bank Transfer	90	2023-05-08 11:40:00	Completed
44	44	Credit Card	100	2023-05-11 16:50:00	Completed
45	45	PayPal	110	2023-05-14 14:00:00	Completed
46	46	Credit Card	120	2023-05-17 10:10:00	Completed
47	47	Bank Transfer	130	2023-05-20 15:20:00	Completed
48	48	Credit Card	140	2023-05-23 12:30:00	Completed
49	49	PayPal	150	2023-05-26 09:40:00	Completed
101	101	Credit Card	80	2023-10-10 12:00:00	Completed
50	50	Credit Card	160	2023-05-29 14:50:00	Completed
102	102	Bank Transfer	110	2023-10-13 16:10:00	Completed
103	103	Credit Card	120	2023-10-15 13:20:00	Completed
104	104	PayPal	140	2023-10-18 10:30:00	Completed
105	105	Credit Card	150	2023-10-20 15:40:00	Pending
106	106	Bank Transfer	100	2023-10-23 12:50:00	Completed
107	107	Credit Card	180	2023-10-25 10:00:00	Completed
108	108	PayPal	75	2023-10-28 14:10:00	Completed
109	109	Credit Card	40	2023-10-30 11:20:00	Completed
110	110	Bank Transfer	160	2023-11-02 16:30:00	Pending
111	111	Credit Card	90	2023-11-05 13:40:00	Completed
112	112	PayPal	180	2023-11-08 10:50:00	Completed
113	113	Credit Card	200	2023-11-10 16:00:00	Completed
114	114	Bank Transfer	140	2023-11-13 12:10:00	Completed
115	115	Credit Card	130	2023-11-16 09:20:00	Pending
116	116	PayPal	250	2023-11-18 14:30:00	Completed
117	117	Credit Card	100	2023-11-21 11:40:00	Completed
118	118	Bank Transfer	130	2023-11-23 16:50:00	Completed
119	119	Credit Card	500	2023-11-26 14:00:00	Completed
120	120	PayPal	200	2023-11-29 10:10:00	Pending
121	121	Credit Card	40	2023-12-02 15:20:00	Completed
122	122	Bank Transfer	300	2023-12-05 12:30:00	Completed
123	123	Credit Card	90	2023-12-08 09:40:00	Completed
124	124	PayPal	80	2023-12-10 14:50:00	Completed
125	125	Credit Card	110	2023-12-13 12:00:00	Pending
\.


--
-- TOC entry 4984 (class 0 OID 16624)
-- Dependencies: 219
-- Data for Name: products; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.products (id, name, category_id, price, stock_quantity, supplier_id) FROM stdin;
1	iPhone 15 Pro	6	1000	150	1
2	Samsung Galaxy S24	6	900	120	1
4	Dell XPS 15	7	1800	90	6
8	Non-Stick Cookware Set	11	130	100	3
9	Leather Sofa	12	900	40	3
13	iPad Air	17	600	110	1
14	Apple Watch Series 9	18	400	130	1
15	LG OLED TV 65"	19	1600	50	6
16	Canon EOS R5	20	3500	30	6
21	Dune	27	11	150	4
22	Gone Girl	28	12	140	4
23	The Notebook	29	10	160	4
24	Steve Jobs Biography	30	15	100	4
25	Sapiens	31	19	120	4
26	Atomic Habits	32	14	200	4
27	Yoga Block Set	33	20	180	5
28	Mountain Bike	34	500	40	5
29	Wireless Earbuds	8	80	250	1
30	Smart Thermostat	1	130	80	6
31	Air Fryer	3	90	70	3
35	Sleeping Bag	37	90	45	5
36	HP Laser Printer	39	200	55	6
38	Phone Case	41	20	300	1
39	Men's Boxer Briefs	42	25	200	2
40	Women's Bikini Set	43	40	150	2
41	Dog Food	44	50	120	3
42	Board Game	45	30	90	4
43	Car Phone Mount	46	15	180	6
44	Tool Set	47	80	70	3
47	Blender	3	60	85	3
48	Throw Blanket	24	30	120	3
49	Hiking Backpack	38	80	65	5
50	Desk Lamp	26	35	95	3
3	MacBook Pro 16"	7	2500	76	1
5	Sony WH-1000XM5	8	350	195	1
6	Men's Slim Fit Jeans	9	60	270	2
7	Women's Summer Dress	10	50	217	2
10	The Silent Patient	13	13	161	4
11	Yoga Mat	15	30	140	5
12	4-Person Tent	16	200	56	5
17	Kids' Hoodie	21	25	170	2
18	Running Shoes	22	90	116	5
19	Silver Necklace	23	80	89	2
20	Memory Foam Pillow	24	40	194	3
32	Standing Desk	12	250	47	3
33	Kindle Paperwhite	4	140	87	4
34	Dumbbell Set	15	130	57	5
37	PlayStation 5	40	500	27	1
45	Organic Coffee	48	13	147	3
46	Vitamin C Serum	50	25	128	2
\.


--
-- TOC entry 4982 (class 0 OID 16600)
-- Dependencies: 217
-- Data for Name: suppliers; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.suppliers (id, name, email, address) FROM stdin;
1	TechGlobal Inc.	contact@techglobal.com	123 Tech Plaza, Silicon Valley, CA
2	FashionForward Ltd.	sales@fashionforward.com	456 Style Ave, New York, NY
3	HomeEssentials Co.	info@homeessentials.com	789 Comfort St, Chicago, IL
4	BookWorld Distributors	orders@bookworld.com	321 Knowledge Blvd, Seattle, WA
5	OutdoorGear Solutions	support@outdoorgear.com	654 Adventure Lane, Denver, CO
6	GadgetMasters	sales@gadgetmasters.com	987 Innovation Dr, Austin, TX
7	UrbanStyle Apparel	contact@urbanstyle.com	159 Fashion Way, Los Angeles, CA
8	KitchenPro Supplies	info@kitchenpro.com	753 Culinary Ave, Miami, FL
9	Literary Haven	orders@literaryhaven.com	486 Novel St, Boston, MA
10	ActiveLife Sports	support@activelife.com	369 Fitness Rd, Portland, OR
11	ElectroWorld	sales@electroworld.com	852 Circuit Blvd, San Jose, CA
12	TrendyThreads	contact@trendythreads.com	147 Style Lane, Dallas, TX
13	CozyHome Creations	info@cozyhome.com	258 Comfort Dr, Atlanta, GA
14	PageTurner Books	orders@pageturner.com	369 Story Ave, Philadelphia, PA
15	Wilderness Outfitters	support@wilderness.com	741 Trail Way, Salt Lake City, UT
16	DigitalDream	sales@digitaldream.com	963 Byte St, San Francisco, CA
17	ChicBoutique	contact@chicboutique.com	159 Vogue Rd, Las Vegas, NV
18	Chef'sChoice	info@chefschoice.com	357 Recipe Blvd, New Orleans, LA
19	NovelNest	orders@novelnest.com	852 Chapter Lane, Washington, DC
20	SummitGear	support@summitgear.com	654 Peak Dr, Boulder, CO
21	FutureTech	sales@futuretech.com	159 Innovation Way, Raleigh, NC
22	StyleHub	contact@stylehub.com	753 Fashion Ave, Nashville, TN
23	Homestead Goods	info@homestead.com	486 Farm Rd, Kansas City, MO
24	BookBarn	orders@bookbarn.com	369 Library St, Minneapolis, MN
25	Trailblazer Outdoors	support@trailblazer.com	852 Path Way, Boise, ID
26	GizmoGalaxy	sales@gizmogalaxy.com	147 Gadget Blvd, Phoenix, AZ
27	ModaFashion	contact@modafashion.com	258 Runway Dr, San Diego, CA
28	CulinaryCorner	info@culinarycorner.com	741 Spice Lane, Houston, TX
29	ReadMore	orders@readmore.com	963 Bookworm Ave, Orlando, FL
30	AlpineGear	support@alpinegear.com	159 Mountain Rd, Anchorage, AK
31	TechNest	sales@technest.com	357 Chip Way, Columbus, OH
32	VogueCollections	contact@voguecollections.com	486 Couture Blvd, Charlotte, NC
33	HomeSweetHome	info@homesweethome.com	753 Hearth Dr, Indianapolis, IN
34	ChapterOne	orders@chapterone.com	852 Prologue Lane, Milwaukee, WI
35	PeakPerformance	support@peakperformance.com	147 Summit Ave, Oklahoma City, OK
36	DigitalHive	sales@digitalhive.com	369 Network Rd, Albuquerque, NM
37	FashionFusion	contact@fashionfusion.com	741 Trend Way, Tucson, AZ
38	KitchenKraft	info@kitchenkraft.com	159 Utensil Blvd, Memphis, TN
39	LiteraryLion	orders@literarylion.com	258 Manuscript Dr, Louisville, KY
40	TrailTrekker	support@trailtrekker.com	852 Footpath Lane, Richmond, VA
41	GadgetGrove	sales@gadgetgrove.com	963 Widget St, Hartford, CT
42	StyleSymphony	contact@stylesymphony.com	147 Ensemble Ave, Providence, RI
43	HearthAndHome	info@hearthandhome.com	369 Fireplace Rd, Des Moines, IA
44	BookEnd	orders@bookend.com	741 Epilogue Blvd, Omaha, NE
45	SummitSeekers	support@summitseekers.com	159 Ascent Way, Albany, NY
46	TechTrove	sales@techtrove.com	258 Motherboard Dr, Springfield, IL
47	FashionFable	contact@fashionfable.com	852 Silhouette Lane, Columbia, SC
48	PantryPro	info@pantrypro.com	147 Cupboard Ave, Billings, MT
49	NovelNotes	orders@novelnotes.com	369 Plot Rd, Cheyenne, WY
50	OutdoorOdyssey	support@outdoorodyssey.com	741 Expedition Blvd, Montpelier, VT
\.


--
-- TOC entry 4794 (class 2606 OID 16615)
-- Name: categories Categories_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.categories
    ADD CONSTRAINT "Categories_pkey" PRIMARY KEY (id);


--
-- TOC entry 4782 (class 2606 OID 16599)
-- Name: customers Customers_email_key; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.customers
    ADD CONSTRAINT "Customers_email_key" UNIQUE (email);


--
-- TOC entry 4784 (class 2606 OID 16597)
-- Name: customers Customers_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.customers
    ADD CONSTRAINT "Customers_pkey" PRIMARY KEY (id);


--
-- TOC entry 4815 (class 2606 OID 16667)
-- Name: order_items Order_Items_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.order_items
    ADD CONSTRAINT "Order_Items_pkey" PRIMARY KEY (id);


--
-- TOC entry 4807 (class 2606 OID 16654)
-- Name: orders Orders_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.orders
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 16689)
-- Name: payments Payments_order_id_key; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.payments
    ADD CONSTRAINT "Payments_order_id_key" UNIQUE (order_id);


--
-- TOC entry 4823 (class 2606 OID 16687)
-- Name: payments Payments_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.payments
    ADD CONSTRAINT "Payments_pkey" PRIMARY KEY (id);


--
-- TOC entry 4798 (class 2606 OID 16631)
-- Name: products Products_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.products
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (id);


--
-- TOC entry 4788 (class 2606 OID 16608)
-- Name: suppliers Suppliers_email_key; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.suppliers
    ADD CONSTRAINT "Suppliers_email_key" UNIQUE (email);


--
-- TOC entry 4790 (class 2606 OID 16606)
-- Name: suppliers Suppliers_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.suppliers
    ADD CONSTRAINT "Suppliers_pkey" PRIMARY KEY (id);


--
-- TOC entry 4795 (class 1259 OID 16726)
-- Name: idx_categories_name; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_categories_name ON store.categories USING btree (name);


--
-- TOC entry 4796 (class 1259 OID 16727)
-- Name: idx_categories_parent; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_categories_parent ON store.categories USING btree (parent_cat_id) WHERE (parent_cat_id IS NOT NULL);


--
-- TOC entry 4785 (class 1259 OID 16722)
-- Name: idx_customers_email; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_customers_email ON store.customers USING btree (email);


--
-- TOC entry 4786 (class 1259 OID 16723)
-- Name: idx_customers_name; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_customers_name ON store.customers USING btree (last_name, first_name);


--
-- TOC entry 4816 (class 1259 OID 16739)
-- Name: idx_order_items_composite; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_order_items_composite ON store.order_items USING btree (order_id, product_id);


--
-- TOC entry 4817 (class 1259 OID 16737)
-- Name: idx_order_items_order; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_order_items_order ON store.order_items USING btree (order_id);


--
-- TOC entry 4818 (class 1259 OID 16738)
-- Name: idx_order_items_product; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_order_items_product ON store.order_items USING btree (product_id);


--
-- TOC entry 4819 (class 1259 OID 16746)
-- Name: idx_order_items_product_quantity; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_order_items_product_quantity ON store.order_items USING btree (product_id, quantity) WHERE (quantity > 1);


--
-- TOC entry 4808 (class 1259 OID 16733)
-- Name: idx_orders_customer; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_orders_customer ON store.orders USING btree (customer_id);


--
-- TOC entry 4809 (class 1259 OID 16744)
-- Name: idx_orders_customer_date; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_orders_customer_date ON store.orders USING btree (customer_id, order_date);


--
-- TOC entry 4810 (class 1259 OID 16734)
-- Name: idx_orders_date; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_orders_date ON store.orders USING btree (order_date);


--
-- TOC entry 4811 (class 1259 OID 16747)
-- Name: idx_orders_recent; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_orders_recent ON store.orders USING btree (order_date) WHERE (order_date > '2023-01-01 00:00:00'::timestamp without time zone);


--
-- TOC entry 4812 (class 1259 OID 16735)
-- Name: idx_orders_status; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_orders_status ON store.orders USING btree (status) WHERE ((status)::text = ANY ((ARRAY['Processing'::character varying, 'Shipped'::character varying])::text[]));


--
-- TOC entry 4813 (class 1259 OID 16736)
-- Name: idx_orders_total_amount; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_orders_total_amount ON store.orders USING btree (total_amount) WHERE (total_amount > (100)::numeric);


--
-- TOC entry 4824 (class 1259 OID 16741)
-- Name: idx_payments_date; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_payments_date ON store.payments USING btree (payment_date);


--
-- TOC entry 4825 (class 1259 OID 16749)
-- Name: idx_payments_failed; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_payments_failed ON store.payments USING btree (status) WHERE ((status)::text = 'Failed'::text);


--
-- TOC entry 4826 (class 1259 OID 16743)
-- Name: idx_payments_method; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_payments_method ON store.payments USING btree (payment_method);


--
-- TOC entry 4827 (class 1259 OID 16740)
-- Name: idx_payments_order; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_payments_order ON store.payments USING btree (order_id);


--
-- TOC entry 4828 (class 1259 OID 16742)
-- Name: idx_payments_status; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_payments_status ON store.payments USING btree (status) WHERE ((status)::text = ANY ((ARRAY['Pending'::character varying, 'Completed'::character varying])::text[]));


--
-- TOC entry 4799 (class 1259 OID 16729)
-- Name: idx_products_category; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_products_category ON store.products USING btree (category_id);


--
-- TOC entry 4800 (class 1259 OID 16745)
-- Name: idx_products_category_price; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_products_category_price ON store.products USING btree (category_id, price);


--
-- TOC entry 4801 (class 1259 OID 16748)
-- Name: idx_products_low_stock; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_products_low_stock ON store.products USING btree (stock_quantity) WHERE (stock_quantity < 10);


--
-- TOC entry 4802 (class 1259 OID 16728)
-- Name: idx_products_name; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_products_name ON store.products USING btree (name);


--
-- TOC entry 4803 (class 1259 OID 16731)
-- Name: idx_products_price; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_products_price ON store.products USING btree (price) WHERE (price > (0)::numeric);


--
-- TOC entry 4804 (class 1259 OID 16732)
-- Name: idx_products_stock; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_products_stock ON store.products USING btree (stock_quantity) WHERE (stock_quantity > 0);


--
-- TOC entry 4805 (class 1259 OID 16730)
-- Name: idx_products_supplier; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_products_supplier ON store.products USING btree (supplier_id);


--
-- TOC entry 4791 (class 1259 OID 16725)
-- Name: idx_suppliers_email; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_suppliers_email ON store.suppliers USING btree (email);


--
-- TOC entry 4792 (class 1259 OID 16724)
-- Name: idx_suppliers_name; Type: INDEX; Schema: store; Owner: postgres
--

CREATE INDEX idx_suppliers_name ON store.suppliers USING btree (name);


--
-- TOC entry 4979 (class 2618 OID 16703)
-- Name: customer_order_history _RETURN; Type: RULE; Schema: store; Owner: postgres
--

CREATE OR REPLACE VIEW store.customer_order_history AS
 SELECT c.id,
    concat(c.first_name, ' ', c.last_name) AS customer_name,
    count(o.id) AS total_orders,
    sum(o.total_amount) AS total_spent,
    max(o.order_date) AS last_order_date
   FROM (store.customers c
     LEFT JOIN store.orders o ON ((c.id = o.id)))
  GROUP BY c.id;


--
-- TOC entry 4980 (class 2618 OID 16708)
-- Name: product_sales_report _RETURN; Type: RULE; Schema: store; Owner: postgres
--

CREATE OR REPLACE VIEW store.product_sales_report AS
 SELECT p.id,
    p.name AS product_name,
    sum(oi.quantity) AS total_sold,
    sum(((oi.quantity)::numeric * oi.unit_price)) AS total_revenue,
    s.name AS supplier_name
   FROM ((store.products p
     JOIN store.order_items oi ON ((p.id = oi.id)))
     JOIN store.suppliers s ON ((p.id = s.id)))
  GROUP BY p.id, s.name
  ORDER BY (sum(oi.quantity)) DESC;


--
-- TOC entry 4829 (class 2606 OID 16695)
-- Name: categories Categories_parent_cat_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.categories
    ADD CONSTRAINT "Categories_parent_cat_id_fkey" FOREIGN KEY (parent_cat_id) REFERENCES store.categories(id) NOT VALID;


--
-- TOC entry 4833 (class 2606 OID 16668)
-- Name: order_items Order_Items_order_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.order_items
    ADD CONSTRAINT "Order_Items_order_id_fkey" FOREIGN KEY (order_id) REFERENCES store.orders(id);


--
-- TOC entry 4834 (class 2606 OID 16673)
-- Name: order_items Order_Items_product_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.order_items
    ADD CONSTRAINT "Order_Items_product_id_fkey" FOREIGN KEY (product_id) REFERENCES store.products(id);


--
-- TOC entry 4832 (class 2606 OID 16655)
-- Name: orders Orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.orders
    ADD CONSTRAINT "Orders_customer_id_fkey" FOREIGN KEY (customer_id) REFERENCES store.customers(id);


--
-- TOC entry 4835 (class 2606 OID 16690)
-- Name: payments Payments_order_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.payments
    ADD CONSTRAINT "Payments_order_id_fkey" FOREIGN KEY (order_id) REFERENCES store.orders(id);


--
-- TOC entry 4830 (class 2606 OID 16637)
-- Name: products Products_category_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.products
    ADD CONSTRAINT "Products_category_id_fkey" FOREIGN KEY (category_id) REFERENCES store.categories(id);


--
-- TOC entry 4831 (class 2606 OID 16632)
-- Name: products Products_supplier_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.products
    ADD CONSTRAINT "Products_supplier_id_fkey" FOREIGN KEY (supplier_id) REFERENCES store.suppliers(id);


-- Completed on 2025-06-09 02:11:43

--
-- PostgreSQL database dump complete
--

