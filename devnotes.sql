--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: files; Type: TABLE; Schema: public; Owner: devnotes; Tablespace: 
--

CREATE TABLE files (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    body text,
    public boolean DEFAULT true NOT NULL,
    date_created timestamp with time zone DEFAULT now() NOT NULL,
    last_modified timestamp with time zone DEFAULT now() NOT NULL,
    folder_id integer NOT NULL
);


ALTER TABLE public.files OWNER TO devnotes;

--
-- Name: files_id_seq; Type: SEQUENCE; Schema: public; Owner: devnotes
--

CREATE SEQUENCE files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.files_id_seq OWNER TO devnotes;

--
-- Name: files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: devnotes
--

ALTER SEQUENCE files_id_seq OWNED BY files.id;


--
-- Name: folders; Type: TABLE; Schema: public; Owner: devnotes; Tablespace: 
--

CREATE TABLE folders (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    user_id integer NOT NULL,
    public boolean DEFAULT true NOT NULL,
    parent_id integer
);


ALTER TABLE public.folders OWNER TO devnotes;

--
-- Name: folders_id_seq; Type: SEQUENCE; Schema: public; Owner: devnotes
--

CREATE SEQUENCE folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.folders_id_seq OWNER TO devnotes;

--
-- Name: folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: devnotes
--

ALTER SEQUENCE folders_id_seq OWNED BY folders.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: devnotes; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(32) NOT NULL,
    email character varying(256),
    password character varying(64) NOT NULL
);


ALTER TABLE public.users OWNER TO devnotes;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: devnotes
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO devnotes;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: devnotes
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: devnotes
--

ALTER TABLE ONLY files ALTER COLUMN id SET DEFAULT nextval('files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: devnotes
--

ALTER TABLE ONLY folders ALTER COLUMN id SET DEFAULT nextval('folders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: devnotes
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: devnotes
--

COPY files (id, name, body, public, date_created, last_modified, folder_id) FROM stdin;
1	Test 1	blah	t	2014-03-06 03:20:13.61609-08	2014-03-06 03:20:13.61609-08	2
3	Test 2	foo	t	2014-03-06 03:21:13.289837-08	2014-03-06 03:21:13.289837-08	2
4	Test 3	bar	t	2014-03-06 03:21:19.698359-08	2014-03-06 03:21:19.698359-08	2
5	Test 4	baz	t	2014-03-06 03:21:24.494423-08	2014-03-06 03:21:24.494423-08	2
6	Framemaker	\N	t	2014-03-06 05:26:13.208697-08	2014-03-06 05:26:13.208697-08	3
\.


--
-- Name: files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: devnotes
--

SELECT pg_catalog.setval('files_id_seq', 6, true);


--
-- Data for Name: folders; Type: TABLE DATA; Schema: public; Owner: devnotes
--

COPY folders (id, name, user_id, public, parent_id) FROM stdin;
1	/	2	t	\N
2	Perl	3	t	\N
3	Chapter 1	3	t	2
4	Chapter 2	3	t	2
\.


--
-- Name: folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: devnotes
--

SELECT pg_catalog.setval('folders_id_seq', 4, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: devnotes
--

COPY users (id, username, email, password) FROM stdin;
2	test	\N	test123
3	test2	\N	$2a$06$SRTNREvNblDhLBHTXjL1TOXTr/Hk2fNxpUcnhSMokxXbXY0IQhOsK
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: devnotes
--

SELECT pg_catalog.setval('users_id_seq', 3, true);


--
-- Name: files_pkey; Type: CONSTRAINT; Schema: public; Owner: devnotes; Tablespace: 
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_pkey PRIMARY KEY (id);


--
-- Name: folders_pkey; Type: CONSTRAINT; Schema: public; Owner: devnotes; Tablespace: 
--

ALTER TABLE ONLY folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: devnotes; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: devnotes; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: files_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: devnotes
--

ALTER TABLE ONLY files
    ADD CONSTRAINT files_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES folders(id);


--
-- Name: folders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: devnotes
--

ALTER TABLE ONLY folders
    ADD CONSTRAINT folders_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


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

