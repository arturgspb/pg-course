\connect lets_goto_it

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0 (Debian 15.0-1.pgdg110+1)
-- Dumped by pg_dump version 15.0

-- Started on 2022-10-24 14:02:21 MSK

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16401)
-- Name: client; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.client (
    id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.client OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16400)
-- Name: client_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_id_seq OWNER TO postgres;

--
-- TOC entry 3353 (class 0 OID 0)
-- Dependencies: 216
-- Name: client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.client_id_seq OWNED BY public.client.id;


--
-- TOC entry 219 (class 1259 OID 16411)
-- Name: user_client_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_client_link (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    client_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_client_link OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16410)
-- Name: user_client_link_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_client_link_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_client_link_id_seq OWNER TO postgres;

--
-- TOC entry 3354 (class 0 OID 0)
-- Dependencies: 218
-- Name: user_client_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_client_link_id_seq OWNED BY public.user_client_link.id;


--
-- TOC entry 215 (class 1259 OID 16391)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name text,
    last_name text,
    birth_date date,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16390)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3355 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3188 (class 2604 OID 16404)
-- Name: client id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client ALTER COLUMN id SET DEFAULT nextval('public.client_id_seq'::regclass);


--
-- TOC entry 3190 (class 2604 OID 16414)
-- Name: user_client_link id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_client_link ALTER COLUMN id SET DEFAULT nextval('public.user_client_link_id_seq'::regclass);


--
-- TOC entry 3186 (class 2604 OID 16394)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3345 (class 0 OID 16401)
-- Dependencies: 217
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.client (id, name, created_at) VALUES (1, 'Кафе «Бабочка»', '2022-10-24 08:27:34.916379+00');
INSERT INTO public.client (id, name, created_at) VALUES (2, 'ООО Ромашка', '2022-10-24 08:29:06.928746+00');
INSERT INTO public.client (id, name, created_at) VALUES (3, 'ОАО Сталь', '2022-10-24 08:29:06.928746+00');
INSERT INTO public.client (id, name, created_at) VALUES (4, 'Кафе «Булочка»', '2022-10-24 08:29:06.928746+00');
INSERT INTO public.client (id, name, created_at) VALUES (5, 'Музей естественной истории', '2022-10-24 08:29:06.928746+00');
INSERT INTO public.client (id, name, created_at) VALUES (6, 'ИЗО Студия «Акварелька»', '2022-10-24 08:29:06.928746+00');
INSERT INTO public.client (id, name, created_at) VALUES (7, 'Океанариум', '2022-10-24 08:29:06.928746+00');


--
-- TOC entry 3347 (class 0 OID 16411)
-- Dependencies: 219
-- Data for Name: user_client_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (1, 1, 1, '2022-10-24 08:32:53.386942+00');
INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (4, 1, 2, '2022-10-24 08:33:30.875079+00');
INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (5, 2, 1, '2022-10-24 08:57:21.029094+00');
INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (6, 2, 3, '2022-10-24 08:57:21.029094+00');
INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (8, 4, 4, '2022-10-24 08:57:21.029094+00');
INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (9, 4, 5, '2022-10-24 08:57:21.029094+00');
INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (10, 4, 6, '2022-10-24 08:57:21.029094+00');
INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (11, 4, 7, '2022-10-24 08:57:21.029094+00');
INSERT INTO public.user_client_link (id, user_id, client_id, created_at) VALUES (7, 3, 3, '2022-10-24 08:57:21.029094+00');


--
-- TOC entry 3343 (class 0 OID 16391)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, first_name, last_name, birth_date, created_at) VALUES (1, 'Иван', 'Кузнецов', '1988-07-03', '2022-10-24 08:23:58.719822+00');
INSERT INTO public.users (id, first_name, last_name, birth_date, created_at) VALUES (2, 'Ольга', 'Васильева', '1990-07-03', '2022-10-24 08:25:36.553206+00');
INSERT INTO public.users (id, first_name, last_name, birth_date, created_at) VALUES (3, 'Сергей', 'Смирнов', '1990-07-25', '2022-10-24 08:25:36.553206+00');
INSERT INTO public.users (id, first_name, last_name, birth_date, created_at) VALUES (4, 'Елена', 'Петрова', '1991-10-02', '2022-10-24 08:25:36.553206+00');


--
-- TOC entry 3356 (class 0 OID 0)
-- Dependencies: 216
-- Name: client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.client_id_seq', 7, true);


--
-- TOC entry 3357 (class 0 OID 0)
-- Dependencies: 218
-- Name: user_client_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_client_link_id_seq', 11, true);


--
-- TOC entry 3358 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 3195 (class 2606 OID 16409)
-- Name: client client_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pk PRIMARY KEY (id);


--
-- TOC entry 3197 (class 2606 OID 16417)
-- Name: user_client_link user_client_link_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_client_link
    ADD CONSTRAINT user_client_link_pk PRIMARY KEY (id);


--
-- TOC entry 3193 (class 2606 OID 16399)
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (id);


--
-- TOC entry 3198 (class 2606 OID 16423)
-- Name: user_client_link user_client_link_client_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_client_link
    ADD CONSTRAINT user_client_link_client_id_fk FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3199 (class 2606 OID 16418)
-- Name: user_client_link user_client_link_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_client_link
    ADD CONSTRAINT user_client_link_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2022-10-24 14:02:21 MSK

--
-- PostgreSQL database dump complete
--

