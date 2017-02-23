--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: api_menuitem; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE api_menuitem (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    image character varying(100),
    price numeric(10,2) NOT NULL,
    merchant_id integer NOT NULL
);


ALTER TABLE api_menuitem OWNER TO smueats_django;

--
-- Name: api_menuitem_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE api_menuitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE api_menuitem_id_seq OWNER TO smueats_django;

--
-- Name: api_menuitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE api_menuitem_id_seq OWNED BY api_menuitem.id;


--
-- Name: api_merchant; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE api_merchant (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    image character varying(100),
    location_str character varying(100) NOT NULL,
    location_id integer NOT NULL
);


ALTER TABLE api_merchant OWNER TO smueats_django;

--
-- Name: api_merchant_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE api_merchant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE api_merchant_id_seq OWNER TO smueats_django;

--
-- Name: api_merchant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE api_merchant_id_seq OWNED BY api_merchant.id;


--
-- Name: api_merchantlocation; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE api_merchantlocation (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    image character varying(100)
);


ALTER TABLE api_merchantlocation OWNER TO smueats_django;

--
-- Name: api_merchantlocation_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE api_merchantlocation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE api_merchantlocation_id_seq OWNER TO smueats_django;

--
-- Name: api_merchantlocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE api_merchantlocation_id_seq OWNED BY api_merchantlocation.id;


--
-- Name: api_order; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE api_order (
    id integer NOT NULL,
    time_placed timestamp with time zone NOT NULL,
    timeout_by timestamp with time zone,
    time_committed timestamp with time zone,
    time_fulfilled timestamp with time zone,
    is_paid boolean NOT NULL,
    fulfiller_id integer,
    orderer_id integer NOT NULL,
    location text NOT NULL
);


ALTER TABLE api_order OWNER TO smueats_django;

--
-- Name: api_order_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE api_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE api_order_id_seq OWNER TO smueats_django;

--
-- Name: api_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE api_order_id_seq OWNED BY api_order.id;


--
-- Name: api_orderconfirmcode; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE api_orderconfirmcode (
    code uuid NOT NULL,
    time_created timestamp with time zone NOT NULL,
    expire_by timestamp with time zone NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE api_orderconfirmcode OWNER TO smueats_django;

--
-- Name: api_orderitem; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE api_orderitem (
    id integer NOT NULL,
    quantity integer NOT NULL,
    notes text NOT NULL,
    menu_item_id integer NOT NULL,
    order_id integer NOT NULL
);


ALTER TABLE api_orderitem OWNER TO smueats_django;

--
-- Name: api_orderitem_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE api_orderitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE api_orderitem_id_seq OWNER TO smueats_django;

--
-- Name: api_orderitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE api_orderitem_id_seq OWNED BY api_orderitem.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE auth_group OWNER TO smueats_django;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_id_seq OWNER TO smueats_django;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_group_permissions OWNER TO smueats_django;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_group_permissions_id_seq OWNER TO smueats_django;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE auth_permission OWNER TO smueats_django;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_permission_id_seq OWNER TO smueats_django;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE auth_user OWNER TO smueats_django;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE auth_user_groups OWNER TO smueats_django;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_groups_id_seq OWNER TO smueats_django;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_id_seq OWNER TO smueats_django;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE auth_user_user_permissions OWNER TO smueats_django;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_user_user_permissions_id_seq OWNER TO smueats_django;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE django_admin_log OWNER TO smueats_django;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_admin_log_id_seq OWNER TO smueats_django;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE django_content_type OWNER TO smueats_django;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_content_type_id_seq OWNER TO smueats_django;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE django_migrations OWNER TO smueats_django;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE django_migrations_id_seq OWNER TO smueats_django;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE django_session OWNER TO smueats_django;

--
-- Name: guardian_groupobjectpermission; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE guardian_groupobjectpermission (
    id integer NOT NULL,
    object_pk character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE guardian_groupobjectpermission OWNER TO smueats_django;

--
-- Name: guardian_groupobjectpermission_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE guardian_groupobjectpermission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE guardian_groupobjectpermission_id_seq OWNER TO smueats_django;

--
-- Name: guardian_groupobjectpermission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE guardian_groupobjectpermission_id_seq OWNED BY guardian_groupobjectpermission.id;


--
-- Name: guardian_userobjectpermission; Type: TABLE; Schema: public; Owner: smueats_django
--

CREATE TABLE guardian_userobjectpermission (
    id integer NOT NULL,
    object_pk character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    permission_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE guardian_userobjectpermission OWNER TO smueats_django;

--
-- Name: guardian_userobjectpermission_id_seq; Type: SEQUENCE; Schema: public; Owner: smueats_django
--

CREATE SEQUENCE guardian_userobjectpermission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE guardian_userobjectpermission_id_seq OWNER TO smueats_django;

--
-- Name: guardian_userobjectpermission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: smueats_django
--

ALTER SEQUENCE guardian_userobjectpermission_id_seq OWNED BY guardian_userobjectpermission.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_menuitem ALTER COLUMN id SET DEFAULT nextval('api_menuitem_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_merchant ALTER COLUMN id SET DEFAULT nextval('api_merchant_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_merchantlocation ALTER COLUMN id SET DEFAULT nextval('api_merchantlocation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_order ALTER COLUMN id SET DEFAULT nextval('api_order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_orderitem ALTER COLUMN id SET DEFAULT nextval('api_orderitem_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_groupobjectpermission ALTER COLUMN id SET DEFAULT nextval('guardian_groupobjectpermission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_userobjectpermission ALTER COLUMN id SET DEFAULT nextval('guardian_userobjectpermission_id_seq'::regclass);


--
-- Data for Name: api_menuitem; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY api_menuitem (id, name, image, price, merchant_id) FROM stdin;
1	Nai you pai gu fan		6.00	1
2	Xing zhou chao fan		5.00	1
3	Otah		1.00	1
4	Xing zhou mi fen		3.50	1
5	Har cheong gai		10.00	1
6	Xian dan nai you ji fan		6.50	2
7	Niu rou chao fan		7.00	2
8	Xing zhou mi fen		5.00	2
9	Red tea longan		2.00	3
10	Chendol		1.50	3
11	Tau suan		1.20	3
12	Nasi lemak ayam		3.50	4
13	Nasi lemak ikan		4.00	4
14	Nasi lemak special		6.00	4
15	Nasi lemak sausage		3.00	4
\.


--
-- Name: api_menuitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('api_menuitem_id_seq', 15, true);


--
-- Data for Name: api_merchant; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY api_merchant (id, name, image, location_str, location_id) FROM stdin;
1	Ding Heng Kitchen		Next to the petrol station	1
2	Jia Yuen Eating House		Somewhere over the rainbow	1
3	Dessert stall		#12-345	1
4	Famous nasi lemak		#23-456	1
\.


--
-- Name: api_merchant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('api_merchant_id_seq', 4, true);


--
-- Data for Name: api_merchantlocation; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY api_merchantlocation (id, name, image) FROM stdin;
1	Upper Changi	
2	Changi Village	
\.


--
-- Name: api_merchantlocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('api_merchantlocation_id_seq', 2, true);


--
-- Data for Name: api_order; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY api_order (id, time_placed, timeout_by, time_committed, time_fulfilled, is_paid, fulfiller_id, orderer_id, location) FROM stdin;
1	2017-02-23 03:15:24+00	2017-02-23 06:16:30.112886+00	2017-02-23 05:22:16.133083+00	\N	f	4	3	
2	2017-02-23 06:57:03+00	2017-02-23 09:58:00+00	\N	\N	f	\N	6	Golf 3
\.


--
-- Name: api_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('api_order_id_seq', 2, true);


--
-- Data for Name: api_orderconfirmcode; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY api_orderconfirmcode (code, time_created, expire_by, order_id) FROM stdin;
9174649d-9940-44ff-8d37-04d31a6b7cfa	2017-02-23 03:49:18.764159+00	2017-02-23 03:54:18.764159+00	1
\.


--
-- Data for Name: api_orderitem; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY api_orderitem (id, quantity, notes, menu_item_id, order_id) FROM stdin;
1	3		1	1
2	3		3	1
3	1		5	1
4	2		4	1
5	2		9	2
6	3		11	2
7	1		13	2
8	2		12	2
9	1		14	2
\.


--
-- Name: api_orderitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('api_orderitem_id_seq', 9, true);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add permission	2	add_permission
5	Can change permission	2	change_permission
6	Can delete permission	2	delete_permission
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add group	4	add_group
11	Can change group	4	change_group
12	Can delete group	4	delete_group
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add order item	7	add_orderitem
20	Can change order item	7	change_orderitem
21	Can delete order item	7	delete_orderitem
22	Can add merchant	8	add_merchant
23	Can change merchant	8	change_merchant
24	Can delete merchant	8	delete_merchant
25	Can add order	9	add_order
26	Can change order	9	change_order
27	Can delete order	9	delete_order
28	Can add order confirm code	10	add_orderconfirmcode
29	Can change order confirm code	10	change_orderconfirmcode
30	Can delete order confirm code	10	delete_orderconfirmcode
31	Can add menu item	11	add_menuitem
32	Can change menu item	11	change_menuitem
33	Can delete menu item	11	delete_menuitem
34	Can add user object permission	12	add_userobjectpermission
35	Can change user object permission	12	change_userobjectpermission
36	Can delete user object permission	12	delete_userobjectpermission
37	Can add group object permission	13	add_groupobjectpermission
38	Can change group object permission	13	change_groupobjectpermission
39	Can delete group object permission	13	delete_groupobjectpermission
40	Can add merchant location	14	add_merchantlocation
41	Can change merchant location	14	change_merchantlocation
42	Can delete merchant location	14	delete_merchantlocation
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('auth_permission_id_seq', 42, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	!i16I7M9jsrpReBDSZu1PNfjKbwVXjPOlEbxStpgL	\N	f	AnonymousUser				f	t	2017-02-23 03:01:24.056063+00
3	pbkdf2_sha256$30000$9ORRPyEvXdRh$DFgmkZrGaLa9WkY8G/jfiwLU3pUIs2vS5YEzJAKxduo=	\N	f	mazda			guardhouse@mazda.com	f	t	2017-02-23 03:12:02+00
4	pbkdf2_sha256$30000$mlIB6tzhp0V8$ByrcL/FrKMFVstb310GJWsnmu/o3fHTCC0TGCWRLdLY=	\N	f	kenneth			takeahike@kenneth.com	f	t	2017-02-23 03:12:29+00
5	pbkdf2_sha256$30000$AdDZyXyN5gDu$3IAzczCpd0uHWdku55qZCJPobb9Hqbo3y5yHmS9fpx8=	\N	f	dingheng			delivery@dingheng.com	f	t	2017-02-23 03:13:51+00
2	pbkdf2_sha256$30000$ojP1Iqcm9MKi$KblvsJAPOfMtDdCCOzBmPkHA6fZyIEVkNwmagF3M5gM=	2017-02-23 03:03:51+00	t	nikos			Password1!@nikos.com	t	t	2017-02-23 03:01:47+00
6	pbkdf2_sha256$30000$2y5T4HXxNiYF$a07OzW5uunSH+UOYdyLO1mXtbVDUMvixoxBO6iv6P7o=	\N	f	wagon			cctvslack@wagon.com	f	t	2017-02-23 07:00:57+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('auth_user_id_seq', 6, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2017-02-23 03:04:32.310936+00	1	Ding Heng Kitchen	1	[{"added": {}}]	8	2
2	2017-02-23 03:09:53.390772+00	1	Ding Heng Kitchen	2	[{"added": {"name": "menu item", "object": "Nai you pai gu fan ($6) from Ding Heng Kitchen"}}, {"added": {"name": "menu item", "object": "Xing zhou chao fan ($5) from Ding Heng Kitchen"}}, {"added": {"name": "menu item", "object": "Otah ($1) from Ding Heng Kitchen"}}, {"added": {"name": "menu item", "object": "Xing zhou mi fen ($3.5) from Ding Heng Kitchen"}}, {"added": {"name": "menu item", "object": "Har cheong gai ($10) from Ding Heng Kitchen"}}]	8	2
3	2017-02-23 03:12:02.782179+00	3	mazda	1	[{"added": {}}]	3	2
4	2017-02-23 03:12:12.693663+00	3	mazda	2	[{"changed": {"fields": ["email"]}}]	3	2
5	2017-02-23 03:12:29.404684+00	4	kenneth	1	[{"added": {}}]	3	2
6	2017-02-23 03:12:40.162204+00	4	kenneth	2	[{"changed": {"fields": ["email"]}}]	3	2
7	2017-02-23 03:13:51.440243+00	5	dingheng	1	[{"added": {}}]	3	2
8	2017-02-23 03:14:51.547076+00	5	dingheng	2	[{"changed": {"fields": ["email"]}}]	3	2
9	2017-02-23 03:16:40.713904+00	1	Order object	1	[{"added": {}}, {"added": {"name": "order item", "object": "OrderItem object"}}, {"added": {"name": "order item", "object": "OrderItem object"}}, {"added": {"name": "order item", "object": "OrderItem object"}}, {"added": {"name": "order item", "object": "OrderItem object"}}]	9	2
10	2017-02-23 06:48:18.356264+00	1	MerchantLocation object	1	[{"added": {}}]	14	2
11	2017-02-23 06:49:07.739853+00	1	Ding Heng Kitchen	2	[{"changed": {"fields": ["location", "location_str"]}}]	8	2
12	2017-02-23 06:56:43.080923+00	2	Jia Yuen Eating House	1	[{"added": {}}, {"added": {"object": "Xian dan nai you ji fan ($6.50) from Jia Yuen Eating House", "name": "menu item"}}, {"added": {"object": "Niu rou chao fan ($7) from Jia Yuen Eating House", "name": "menu item"}}, {"added": {"object": "Xing zhou mi fen ($5) from Jia Yuen Eating House", "name": "menu item"}}]	8	2
13	2017-02-23 06:58:47.315717+00	2	Order opened by nikos on 2017-02-23 06:57:03+00:00, stage: Stage.PLACED	1	[{"added": {}}, {"added": {"object": "OrderItem object", "name": "order item"}}, {"added": {"object": "OrderItem object", "name": "order item"}}]	9	2
14	2017-02-23 06:59:55.914183+00	2	nikos	2	[{"changed": {"fields": ["email"]}}]	3	2
15	2017-02-23 07:00:58.025999+00	6	wagon	1	[{"added": {}}]	3	2
16	2017-02-23 07:01:11.260883+00	6	wagon	2	[{"changed": {"fields": ["email"]}}]	3	2
17	2017-02-23 07:01:42.062212+00	2	Order opened by wagon on 2017-02-23 06:57:03+00:00, stage: Stage.PLACED	2	[{"changed": {"fields": ["orderer", "location"]}}]	9	2
18	2017-02-23 07:02:04.43132+00	2	Changi Village	1	[{"added": {}}]	14	2
19	2017-02-23 07:03:15.550643+00	3	Dessert stall	1	[{"added": {}}, {"added": {"object": "Red tea longan ($2) from Dessert stall", "name": "menu item"}}, {"added": {"object": "Chendol ($1.5) from Dessert stall", "name": "menu item"}}, {"added": {"object": "Tau suan ($1.2) from Dessert stall", "name": "menu item"}}]	8	2
20	2017-02-23 07:04:55.382609+00	4	Famous nasi lemak	1	[{"added": {}}, {"added": {"object": "Nasi lemak ayam ($3.5) from Famous nasi lemak", "name": "menu item"}}, {"added": {"object": "Nasi lemak ikan ($4) from Famous nasi lemak", "name": "menu item"}}, {"added": {"object": "Nasi lemak special ($6) from Famous nasi lemak", "name": "menu item"}}, {"added": {"object": "Nasi lemak sausage ($3) from Famous nasi lemak", "name": "menu item"}}]	8	2
21	2017-02-23 07:05:45.406234+00	2	Order opened by wagon on 2017-02-23 06:57:03+00:00, stage: Stage.PLACED	2	[{"added": {"object": "OrderItem object", "name": "order item"}}, {"added": {"object": "OrderItem object", "name": "order item"}}, {"added": {"object": "OrderItem object", "name": "order item"}}, {"changed": {"object": "OrderItem object", "name": "order item", "fields": ["menu_item"]}}, {"changed": {"object": "OrderItem object", "name": "order item", "fields": ["menu_item", "quantity"]}}]	9	2
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 21, true);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	user
4	auth	group
5	contenttypes	contenttype
6	sessions	session
7	api	orderitem
8	api	merchant
9	api	order
10	api	orderconfirmcode
11	api	menuitem
12	guardian	userobjectpermission
13	guardian	groupobjectpermission
14	api	merchantlocation
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('django_content_type_id_seq', 14, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: smueats_django
--
-- You might need to delete all this 


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('django_migrations_id_seq', 20, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
xd521nq9q0dq0wsfeq2lqk633jma8mqk	ODNiMDJkZjAyNzA3NzI3ZGI4ZTRiZGQ3OGNlNjcwYTFiMjE5ZWJkODp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiIxZmI0MzMzOWY2OTU0M2Q0NzJiODNjNjEwOTdjMDc0ZGYzOWYzNDJjIn0=	2017-03-09 03:03:51.677688+00
\.


--
-- Data for Name: guardian_groupobjectpermission; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY guardian_groupobjectpermission (id, object_pk, content_type_id, group_id, permission_id) FROM stdin;
\.


--
-- Name: guardian_groupobjectpermission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('guardian_groupobjectpermission_id_seq', 1, false);


--
-- Data for Name: guardian_userobjectpermission; Type: TABLE DATA; Schema: public; Owner: smueats_django
--

COPY guardian_userobjectpermission (id, object_pk, content_type_id, permission_id, user_id) FROM stdin;
\.


--
-- Name: guardian_userobjectpermission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: smueats_django
--

SELECT pg_catalog.setval('guardian_userobjectpermission_id_seq', 1, false);


--
-- Name: api_menuitem_name_cb8acead_uniq; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_menuitem
    ADD CONSTRAINT api_menuitem_name_cb8acead_uniq UNIQUE (name, merchant_id);


--
-- Name: api_menuitem_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_menuitem
    ADD CONSTRAINT api_menuitem_pkey PRIMARY KEY (id);


--
-- Name: api_merchant_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_merchant
    ADD CONSTRAINT api_merchant_pkey PRIMARY KEY (id);


--
-- Name: api_merchantlocation_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_merchantlocation
    ADD CONSTRAINT api_merchantlocation_pkey PRIMARY KEY (id);


--
-- Name: api_order_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_order
    ADD CONSTRAINT api_order_pkey PRIMARY KEY (id);


--
-- Name: api_orderconfirmcode_order_id_key; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_orderconfirmcode
    ADD CONSTRAINT api_orderconfirmcode_order_id_key UNIQUE (order_id);


--
-- Name: api_orderconfirmcode_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_orderconfirmcode
    ADD CONSTRAINT api_orderconfirmcode_pkey PRIMARY KEY (code);


--
-- Name: api_orderitem_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_orderitem
    ADD CONSTRAINT api_orderitem_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: guardian_groupobjectpermission_group_id_3f189f7c_uniq; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_groupobjectpermission
    ADD CONSTRAINT guardian_groupobjectpermission_group_id_3f189f7c_uniq UNIQUE (group_id, permission_id, object_pk);


--
-- Name: guardian_groupobjectpermission_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_groupobjectpermission
    ADD CONSTRAINT guardian_groupobjectpermission_pkey PRIMARY KEY (id);


--
-- Name: guardian_userobjectpermission_pkey; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_userobjectpermission
    ADD CONSTRAINT guardian_userobjectpermission_pkey PRIMARY KEY (id);


--
-- Name: guardian_userobjectpermission_user_id_b0b3d2fc_uniq; Type: CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_userobjectpermission
    ADD CONSTRAINT guardian_userobjectpermission_user_id_b0b3d2fc_uniq UNIQUE (user_id, permission_id, object_pk);


--
-- Name: api_menuitem_2bfddeac; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX api_menuitem_2bfddeac ON api_menuitem USING btree (merchant_id);


--
-- Name: api_menuitem_name_cb8acead_idx; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX api_menuitem_name_cb8acead_idx ON api_menuitem USING btree (name, merchant_id);


--
-- Name: api_merchant_e274a5da; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX api_merchant_e274a5da ON api_merchant USING btree (location_id);


--
-- Name: api_order_230c0360; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX api_order_230c0360 ON api_order USING btree (orderer_id);


--
-- Name: api_order_29cebe7f; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX api_order_29cebe7f ON api_order USING btree (fulfiller_id);


--
-- Name: api_orderitem_69dfcb07; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX api_orderitem_69dfcb07 ON api_orderitem USING btree (order_id);


--
-- Name: api_orderitem_db4bc2b7; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX api_orderitem_db4bc2b7 ON api_orderitem USING btree (menu_item_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_group_name_a6ea08ec_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_0e939a4f; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_group_permissions_0e939a4f ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_8373b171; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_group_permissions_8373b171 ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_417f1b1c; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_permission_417f1b1c ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_0e939a4f; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_user_groups_0e939a4f ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_e8701ad4; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_user_groups_e8701ad4 ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_user_user_permissions_8373b171 ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_e8701ad4; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_user_user_permissions_e8701ad4 ON auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX auth_user_username_6821ab7c_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_417f1b1c; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX django_admin_log_417f1b1c ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_e8701ad4; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX django_admin_log_e8701ad4 ON django_admin_log USING btree (user_id);


--
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX django_session_session_key_c0390e0f_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: guardian_groupobjectpermission_0e939a4f; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX guardian_groupobjectpermission_0e939a4f ON guardian_groupobjectpermission USING btree (group_id);


--
-- Name: guardian_groupobjectpermission_417f1b1c; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX guardian_groupobjectpermission_417f1b1c ON guardian_groupobjectpermission USING btree (content_type_id);


--
-- Name: guardian_groupobjectpermission_8373b171; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX guardian_groupobjectpermission_8373b171 ON guardian_groupobjectpermission USING btree (permission_id);


--
-- Name: guardian_userobjectpermission_417f1b1c; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX guardian_userobjectpermission_417f1b1c ON guardian_userobjectpermission USING btree (content_type_id);


--
-- Name: guardian_userobjectpermission_8373b171; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX guardian_userobjectpermission_8373b171 ON guardian_userobjectpermission USING btree (permission_id);


--
-- Name: guardian_userobjectpermission_e8701ad4; Type: INDEX; Schema: public; Owner: smueats_django
--

CREATE INDEX guardian_userobjectpermission_e8701ad4 ON guardian_userobjectpermission USING btree (user_id);


--
-- Name: api_menuitem_merchant_id_fb24dd07_fk_api_merchant_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_menuitem
    ADD CONSTRAINT api_menuitem_merchant_id_fb24dd07_fk_api_merchant_id FOREIGN KEY (merchant_id) REFERENCES api_merchant(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_merchant_location_id_f1810c52_fk_api_merchantlocation_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_merchant
    ADD CONSTRAINT api_merchant_location_id_f1810c52_fk_api_merchantlocation_id FOREIGN KEY (location_id) REFERENCES api_merchantlocation(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_order_fulfiller_id_27af0a0b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_order
    ADD CONSTRAINT api_order_fulfiller_id_27af0a0b_fk_auth_user_id FOREIGN KEY (fulfiller_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_order_orderer_id_2463a069_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_order
    ADD CONSTRAINT api_order_orderer_id_2463a069_fk_auth_user_id FOREIGN KEY (orderer_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_orderconfirmcode_order_id_69a543d2_fk_api_order_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_orderconfirmcode
    ADD CONSTRAINT api_orderconfirmcode_order_id_69a543d2_fk_api_order_id FOREIGN KEY (order_id) REFERENCES api_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_orderitem_menu_item_id_d2f53516_fk_api_menuitem_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_orderitem
    ADD CONSTRAINT api_orderitem_menu_item_id_d2f53516_fk_api_menuitem_id FOREIGN KEY (menu_item_id) REFERENCES api_menuitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: api_orderitem_order_id_f9c0afc0_fk_api_order_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY api_orderitem
    ADD CONSTRAINT api_orderitem_order_id_f9c0afc0_fk_api_order_id FOREIGN KEY (order_id) REFERENCES api_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permiss_permission_id_84c5c92e_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permiss_permission_id_84c5c92e_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permiss_content_type_id_2f476e4b_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permiss_content_type_id_2f476e4b_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_per_permission_id_1fbb5f2c_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_per_permission_id_1fbb5f2c_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_content_type_id_c4bce8eb_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_content_type_id_c4bce8eb_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: guardian_gro_content_type_id_7ade36b8_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_groupobjectpermission
    ADD CONSTRAINT guardian_gro_content_type_id_7ade36b8_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: guardian_groupobje_permission_id_36572738_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_groupobjectpermission
    ADD CONSTRAINT guardian_groupobje_permission_id_36572738_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: guardian_groupobjectpermissi_group_id_4bbbfb62_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_groupobjectpermission
    ADD CONSTRAINT guardian_groupobjectpermissi_group_id_4bbbfb62_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: guardian_use_content_type_id_2e892405_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_userobjectpermission
    ADD CONSTRAINT guardian_use_content_type_id_2e892405_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: guardian_userobjec_permission_id_71807bfc_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_userobjectpermission
    ADD CONSTRAINT guardian_userobjec_permission_id_71807bfc_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: guardian_userobjectpermission_user_id_d5c1e964_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: smueats_django
--

ALTER TABLE ONLY guardian_userobjectpermission
    ADD CONSTRAINT guardian_userobjectpermission_user_id_d5c1e964_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

