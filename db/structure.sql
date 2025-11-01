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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: activity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.activity_type AS ENUM (
    'color_war',
    'auction',
    'selling',
    'buying',
    'breeding',
    'claiming',
    'entering',
    'redeem'
);


--
-- Name: breed_rankings; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.breed_rankings AS ENUM (
    'bronze',
    'silver',
    'gold',
    'platinum'
);


--
-- Name: breed_record; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.breed_record AS ENUM (
    'none',
    'bronze',
    'silver',
    'gold',
    'platinum'
);


--
-- Name: budget_activity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.budget_activity_type AS ENUM (
    'sold_horse',
    'bought_horse',
    'bred_mare',
    'bred_stud',
    'claimed_horse',
    'entered_race',
    'shipped_horse',
    'race_winnings',
    'jockey_fee',
    'nominated_racehorse',
    'nominated_stallion',
    'boarded_horse',
    'opening_balance',
    'paid_tax',
    'handicapping_races',
    'nominated_breeders_series',
    'consigned_auction',
    'leased_horse',
    'color_war',
    'activity_points',
    'donation',
    'won_breeders_series',
    'misc'
);


--
-- Name: horse_color; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.horse_color AS ENUM (
    'bay',
    'black',
    'blood_bay',
    'blue_roan',
    'brown',
    'chestnut',
    'dapple_grey',
    'dark_bay',
    'dark_grey',
    'flea_bitten_grey',
    'grey',
    'light_bay',
    'light_chestnut',
    'light_grey',
    'liver_chestnut',
    'mahogany_bay',
    'red_chestnut',
    'strawberry_roan'
);


--
-- Name: horse_face_marking; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.horse_face_marking AS ENUM (
    'bald_face',
    'blaze',
    'snip',
    'star',
    'star_snip',
    'star_stripe',
    'star_stripe_snip',
    'stripe',
    'stripe_snip'
);


--
-- Name: horse_gender; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.horse_gender AS ENUM (
    'colt',
    'filly',
    'mare',
    'stallion',
    'gelding'
);


--
-- Name: horse_leg_marking; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.horse_leg_marking AS ENUM (
    'coronet',
    'ermine',
    'sock',
    'stocking'
);


--
-- Name: horse_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.horse_status AS ENUM (
    'unborn',
    'weanling',
    'yearling',
    'racehorse',
    'broodmare',
    'stud',
    'retired',
    'retired_broodmare',
    'retired_stud',
    'deceased'
);


--
-- Name: jockey_gender; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.jockey_gender AS ENUM (
    'male',
    'female'
);


--
-- Name: jockey_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.jockey_status AS ENUM (
    'apprentice',
    'veteran',
    'retired'
);


--
-- Name: jockey_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.jockey_type AS ENUM (
    'flat',
    'jump'
);


--
-- Name: race_age; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.race_age AS ENUM (
    '2',
    '2+',
    '3',
    '3+',
    '4',
    '4+'
);


--
-- Name: race_grade; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.race_grade AS ENUM (
    'Ungraded',
    'Grade 3',
    'Grade 2',
    'Grade 1'
);


--
-- Name: race_result_types; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.race_result_types AS ENUM (
    'dirt',
    'turf',
    'steeplechase'
);


--
-- Name: race_splits; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.race_splits AS ENUM (
    '4Q',
    '2F'
);


--
-- Name: race_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.race_type AS ENUM (
    'maiden',
    'claiming',
    'starter_allowance',
    'nw1_allowance',
    'nw2_allowance',
    'nw3_allowance',
    'allowance',
    'stakes'
);


--
-- Name: track_condition; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.track_condition AS ENUM (
    'fast',
    'good',
    'slow',
    'wet'
);


--
-- Name: track_surface; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.track_surface AS ENUM (
    'dirt',
    'turf',
    'steeplechase'
);


--
-- Name: user_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_status AS ENUM (
    'pending',
    'active',
    'deleted',
    'banned'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activations (
    id bigint NOT NULL,
    token character varying NOT NULL,
    activated_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: activations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activations_id_seq OWNED BY public.activations.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id uuid NOT NULL,
    blob_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    blob_id uuid NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: activity_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_points (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    stable_id uuid NOT NULL,
    activity_type public.activity_type NOT NULL,
    budget_id uuid,
    amount integer DEFAULT 0 NOT NULL,
    balance integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    legacy_stable_id integer DEFAULT 0 NOT NULL
);


--
-- Name: COLUMN activity_points.activity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.activity_points.activity_type IS 'color_war, auction, selling, buying, breeding, claiming, entering, redeem';


--
-- Name: race_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    horse_id uuid NOT NULL,
    year integer DEFAULT 1996 NOT NULL,
    result_type public.race_result_types DEFAULT 'dirt'::public.race_result_types,
    starts integer DEFAULT 0 NOT NULL,
    stakes_starts integer DEFAULT 0 NOT NULL,
    wins integer DEFAULT 0 NOT NULL,
    stakes_wins integer DEFAULT 0 NOT NULL,
    seconds integer DEFAULT 0 NOT NULL,
    stakes_seconds integer DEFAULT 0 NOT NULL,
    thirds integer DEFAULT 0 NOT NULL,
    stakes_thirds integer DEFAULT 0 NOT NULL,
    fourths integer DEFAULT 0 NOT NULL,
    stakes_fourths integer DEFAULT 0 NOT NULL,
    points integer DEFAULT 0 NOT NULL,
    earnings bigint DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN race_records.result_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_records.result_type IS 'dirt, turf, steeplechase';


--
-- Name: annual_race_records; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.annual_race_records AS
 SELECT race_records.year,
    race_records.horse_id,
    sum(race_records.starts) AS starts,
    sum(race_records.stakes_starts) AS stakes_starts,
    sum(race_records.wins) AS wins,
    sum(race_records.stakes_wins) AS stakes_wins,
    sum(race_records.seconds) AS seconds,
    sum(race_records.stakes_seconds) AS stakes_seconds,
    sum(race_records.thirds) AS thirds,
    sum(race_records.stakes_thirds) AS stakes_thirds,
    sum(race_records.fourths) AS fourths,
    sum(race_records.stakes_fourths) AS stakes_fourths,
    sum(race_records.points) AS points,
    sum(race_records.earnings) AS earnings
   FROM public.race_records
  GROUP BY race_records.year, race_records.horse_id
  WITH NO DATA;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: auction_bids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auction_bids (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    auction_id uuid NOT NULL,
    horse_id uuid NOT NULL,
    bidder_id uuid NOT NULL,
    current_bid integer DEFAULT 0 NOT NULL,
    maximum_bid integer,
    comment text,
    email_if_outbid boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: auction_consignment_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auction_consignment_configs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    auction_id uuid NOT NULL,
    horse_type character varying NOT NULL,
    minimum_age integer DEFAULT 0 NOT NULL,
    maximum_age integer DEFAULT 0 NOT NULL,
    minimum_count integer DEFAULT 0 NOT NULL,
    stakes_quality boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: auction_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auction_horses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    auction_id uuid NOT NULL,
    horse_id uuid NOT NULL,
    reserve_price integer,
    comment text,
    sold_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    maximum_price integer
);


--
-- Name: auctions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auctions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    auctioneer_id uuid NOT NULL,
    title character varying(500) NOT NULL,
    hours_until_sold integer DEFAULT 12 NOT NULL,
    reserve_pricing_allowed boolean DEFAULT false NOT NULL,
    outside_horses_allowed boolean DEFAULT false NOT NULL,
    spending_cap_per_stable integer,
    horse_purchase_cap_per_stable integer,
    racehorse_allowed_2yo boolean DEFAULT false NOT NULL,
    racehorse_allowed_3yo boolean DEFAULT false NOT NULL,
    racehorse_allowed_older boolean DEFAULT false NOT NULL,
    stallion_allowed boolean DEFAULT false NOT NULL,
    broodmare_allowed boolean DEFAULT false NOT NULL,
    yearling_allowed boolean DEFAULT false NOT NULL,
    weanling_allowed boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: broodmare_foal_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.broodmare_foal_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    horse_id uuid NOT NULL,
    born_foals_count integer DEFAULT 0 NOT NULL,
    stillborn_foals_count integer DEFAULT 0 NOT NULL,
    unborn_foals_count integer DEFAULT 0 NOT NULL,
    raced_foals_count integer DEFAULT 0 NOT NULL,
    winning_foals_count integer DEFAULT 0 NOT NULL,
    stakes_winning_foals_count integer DEFAULT 0 NOT NULL,
    multi_stakes_winning_foals_count integer DEFAULT 0 NOT NULL,
    millionaire_foals_count integer DEFAULT 0 NOT NULL,
    multi_millionaire_foals_count integer DEFAULT 0 NOT NULL,
    total_foal_points integer DEFAULT 0 NOT NULL,
    total_foal_races integer DEFAULT 0 NOT NULL,
    total_foal_earnings bigint DEFAULT 0 NOT NULL,
    breed_ranking public.breed_rankings,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN broodmare_foal_records.breed_ranking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.broodmare_foal_records.breed_ranking IS 'bronze, silver, gold, platinum';


--
-- Name: budgets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.budgets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    stable_id uuid NOT NULL,
    description text NOT NULL,
    amount bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    legacy_budget_id integer DEFAULT 0,
    legacy_stable_id integer DEFAULT 0,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_migrations (
    version character varying NOT NULL
);


--
-- Name: game_activity_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_activity_points (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    activity_type public.activity_type NOT NULL,
    first_year_points integer DEFAULT 0 NOT NULL,
    second_year_points integer DEFAULT 0 NOT NULL,
    older_year_points integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN game_activity_points.activity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.game_activity_points.activity_type IS 'color_war, auction, selling, buying, breeding, claiming, entering, redeem';


--
-- Name: game_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_alerts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    start_time timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    message text NOT NULL,
    display_to_newbies boolean DEFAULT true NOT NULL,
    display_to_non_newbies boolean DEFAULT true NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: horse_appearances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horse_appearances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    horse_id uuid NOT NULL,
    color public.horse_color DEFAULT 'bay'::public.horse_color NOT NULL,
    rf_leg_marking public.horse_leg_marking,
    lf_leg_marking public.horse_leg_marking,
    rh_leg_marking public.horse_leg_marking,
    lh_leg_marking public.horse_leg_marking,
    face_marking public.horse_face_marking,
    rf_leg_image character varying,
    lf_leg_image character varying,
    rh_leg_image character varying,
    lh_leg_image character varying,
    face_image character varying,
    birth_height numeric(4,2) DEFAULT 0.0 NOT NULL,
    current_height numeric(4,2) DEFAULT 0.0 NOT NULL,
    max_height numeric(4,2) DEFAULT 0.0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT current_height_must_be_valid CHECK ((current_height >= birth_height)),
    CONSTRAINT max_height_must_be_valid CHECK ((max_height >= current_height))
);


--
-- Name: COLUMN horse_appearances.color; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horse_appearances.color IS 'bay, black, blood_bay, blue_roan, brown, chestnut, dapple_grey, dark_bay, dark_grey, flea_bitten_grey, grey, light_bay, light_chestnut, light_grey, liver_chestnut, mahogany_bay, red_chestnut, strawberry_roan';


--
-- Name: COLUMN horse_appearances.rf_leg_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horse_appearances.rf_leg_marking IS 'coronet, ermine, sock, stocking';


--
-- Name: COLUMN horse_appearances.lf_leg_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horse_appearances.lf_leg_marking IS 'coronet, ermine, sock, stocking';


--
-- Name: COLUMN horse_appearances.rh_leg_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horse_appearances.rh_leg_marking IS 'coronet, ermine, sock, stocking';


--
-- Name: COLUMN horse_appearances.lh_leg_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horse_appearances.lh_leg_marking IS 'coronet, ermine, sock, stocking';


--
-- Name: COLUMN horse_appearances.face_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horse_appearances.face_marking IS 'bald_face, blaze, snip, star, star_snip, star_stripe, star_stripe_snip, stripe, stripe_snip';


--
-- Name: horse_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horse_attributes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    horse_id uuid NOT NULL,
    age integer DEFAULT 0,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    track_record character varying DEFAULT 'Unraced'::character varying NOT NULL,
    title character varying,
    breeding_record character varying DEFAULT 'None'::character varying NOT NULL,
    dosage_text character varying
);


--
-- Name: horse_genetics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horse_genetics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    horse_id uuid NOT NULL,
    allele character varying(32) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(18),
    gender public.horse_gender NOT NULL,
    status public.horse_status DEFAULT 'unborn'::public.horse_status NOT NULL,
    date_of_birth date NOT NULL,
    date_of_death date,
    age integer,
    owner_id uuid NOT NULL,
    breeder_id uuid NOT NULL,
    sire_id uuid,
    dam_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    location_bred_id uuid NOT NULL,
    legacy_id integer,
    foals_count integer DEFAULT 0 NOT NULL,
    unborn_foals_count integer DEFAULT 0 NOT NULL,
    slug character varying
);


--
-- Name: COLUMN horses.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horses.gender IS 'colt, filly, stallion, mare, gelding';


--
-- Name: COLUMN horses.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horses.status IS 'unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased';


--
-- Name: jockeys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jockeys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    legacy_id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    date_of_birth date NOT NULL,
    gender public.jockey_gender,
    status public.jockey_status,
    jockey_type public.jockey_type,
    height_in_inches integer NOT NULL,
    weight integer NOT NULL,
    strength integer NOT NULL,
    acceleration integer NOT NULL,
    break_speed integer NOT NULL,
    min_speed integer NOT NULL,
    average_speed integer NOT NULL,
    max_speed integer NOT NULL,
    "leading" integer NOT NULL,
    midpack integer NOT NULL,
    off_pace integer NOT NULL,
    closing integer NOT NULL,
    consistency integer NOT NULL,
    courage integer NOT NULL,
    pissy integer NOT NULL,
    rating integer NOT NULL,
    dirt integer NOT NULL,
    turf integer NOT NULL,
    steeplechase integer NOT NULL,
    fast integer NOT NULL,
    good integer NOT NULL,
    slow integer NOT NULL,
    wet integer NOT NULL,
    turning integer NOT NULL,
    looking integer NOT NULL,
    traffic integer NOT NULL,
    loaf_threshold integer NOT NULL,
    whip_seconds integer NOT NULL,
    experience integer NOT NULL,
    experience_rate integer NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN jockeys.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.jockeys.gender IS 'male, female';


--
-- Name: COLUMN jockeys.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.jockeys.status IS 'apprentice, veteran, retired';


--
-- Name: COLUMN jockeys.jockey_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.jockeys.jockey_type IS 'flat, jump';


--
-- Name: lifetime_race_records; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.lifetime_race_records AS
 SELECT race_records.horse_id,
    sum(race_records.starts) AS starts,
    sum(race_records.stakes_starts) AS stakes_starts,
    sum(race_records.wins) AS wins,
    sum(race_records.stakes_wins) AS stakes_wins,
    sum(race_records.seconds) AS seconds,
    sum(race_records.stakes_seconds) AS stakes_seconds,
    sum(race_records.thirds) AS thirds,
    sum(race_records.stakes_thirds) AS stakes_thirds,
    sum(race_records.fourths) AS fourths,
    sum(race_records.stakes_fourths) AS stakes_fourths,
    sum(race_records.points) AS points,
    sum(race_records.earnings) AS earnings
   FROM public.race_records
  GROUP BY race_records.horse_id
  WITH NO DATA;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    state character varying,
    county character varying,
    country character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_alert_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_alert_locks (
    id bigint NOT NULL,
    alert_id bigint NOT NULL,
    lock_timestamp character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_alert_locks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_alert_locks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_alert_locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_alert_locks_id_seq OWNED BY public.motor_alert_locks.id;


--
-- Name: motor_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_alerts (
    id bigint NOT NULL,
    query_id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    to_emails text NOT NULL,
    is_enabled boolean DEFAULT true NOT NULL,
    preferences text NOT NULL,
    author_id bigint,
    author_type character varying,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_alerts_id_seq OWNED BY public.motor_alerts.id;


--
-- Name: motor_api_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_api_configs (
    id bigint NOT NULL,
    name character varying NOT NULL,
    url character varying NOT NULL,
    preferences text NOT NULL,
    credentials text NOT NULL,
    description text,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_api_configs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_api_configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_api_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_api_configs_id_seq OWNED BY public.motor_api_configs.id;


--
-- Name: motor_audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_audits (
    id bigint NOT NULL,
    auditable_id character varying,
    auditable_type character varying,
    associated_id character varying,
    associated_type character varying,
    user_id bigint,
    user_type character varying,
    username character varying,
    action character varying,
    audited_changes text,
    version bigint DEFAULT 0,
    comment text,
    remote_address character varying,
    request_uuid character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_audits_id_seq OWNED BY public.motor_audits.id;


--
-- Name: motor_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_configs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_configs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_configs_id_seq OWNED BY public.motor_configs.id;


--
-- Name: motor_dashboards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_dashboards (
    id bigint NOT NULL,
    title character varying NOT NULL,
    description text,
    preferences text NOT NULL,
    author_id bigint,
    author_type character varying,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_dashboards_id_seq OWNED BY public.motor_dashboards.id;


--
-- Name: motor_forms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_forms (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    api_path text NOT NULL,
    http_method character varying NOT NULL,
    preferences text NOT NULL,
    author_id bigint,
    author_type character varying,
    deleted_at timestamp with time zone,
    api_config_name character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_forms_id_seq OWNED BY public.motor_forms.id;


--
-- Name: motor_queries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_queries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    sql_body text NOT NULL,
    preferences text NOT NULL,
    author_id bigint,
    author_type character varying,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_queries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_queries_id_seq OWNED BY public.motor_queries.id;


--
-- Name: motor_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_resources (
    id bigint NOT NULL,
    name character varying NOT NULL,
    preferences text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_resources_id_seq OWNED BY public.motor_resources.id;


--
-- Name: motor_taggable_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_taggable_tags (
    id bigint NOT NULL,
    tag_id bigint NOT NULL,
    taggable_id bigint NOT NULL,
    taggable_type character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_taggable_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_taggable_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_taggable_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_taggable_tags_id_seq OWNED BY public.motor_taggable_tags.id;


--
-- Name: motor_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.motor_tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: motor_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motor_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_tags_id_seq OWNED BY public.motor_tags.id;


--
-- Name: new_activations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_activations (
    id bigint NOT NULL,
    activated_at timestamp with time zone,
    token character varying NOT NULL,
    user_id integer,
    old_user_id uuid NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_activations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_activations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_activations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_activations_id_seq OWNED BY public.new_activations.id;


--
-- Name: new_activity_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_activity_points (
    id bigint NOT NULL,
    activity_type public.activity_type NOT NULL,
    amount integer DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    budget_id integer,
    old_budget_id uuid,
    legacy_stable_id integer DEFAULT 0 NOT NULL,
    stable_id integer,
    old_stable_id uuid NOT NULL,
    old_id uuid NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_activity_points.activity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_activity_points.activity_type IS 'color_war, auction, selling, buying, breeding, claiming, entering, redeem';


--
-- Name: new_activity_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_activity_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_activity_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_activity_points_id_seq OWNED BY public.new_activity_points.id;


--
-- Name: new_auction_bids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_auction_bids (
    id bigint NOT NULL,
    auction_id integer,
    old_auction_id uuid NOT NULL,
    bidder_id integer,
    old_bidder_id uuid NOT NULL,
    comment text,
    current_bid integer DEFAULT 0 NOT NULL,
    notify_if_outbid boolean DEFAULT false NOT NULL,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    maximum_bid integer,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_auction_bids_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_auction_bids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_auction_bids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_auction_bids_id_seq OWNED BY public.new_auction_bids.id;


--
-- Name: new_auction_consignment_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_auction_consignment_configs (
    id bigint NOT NULL,
    auction_id integer,
    old_auction_id uuid NOT NULL,
    horse_type character varying NOT NULL,
    maximum_age integer DEFAULT 0 NOT NULL,
    minimum_age integer DEFAULT 0 NOT NULL,
    minimum_count integer DEFAULT 0 NOT NULL,
    stakes_quality boolean DEFAULT false NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_auction_consignment_configs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_auction_consignment_configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_auction_consignment_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_auction_consignment_configs_id_seq OWNED BY public.new_auction_consignment_configs.id;


--
-- Name: new_auction_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_auction_horses (
    id bigint NOT NULL,
    auction_id integer,
    old_auction_id uuid NOT NULL,
    comment text,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    maximum_price integer,
    reserve_price integer,
    sold_at timestamp with time zone,
    public_id character varying(12),
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_auction_horses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_auction_horses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_auction_horses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_auction_horses_id_seq OWNED BY public.new_auction_horses.id;


--
-- Name: new_auctions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_auctions (
    id bigint NOT NULL,
    auctioneer_id integer,
    old_auctioneer_id uuid NOT NULL,
    broodmare_allowed boolean DEFAULT false NOT NULL,
    end_time timestamp with time zone NOT NULL,
    horse_purchase_cap_per_stable integer,
    hours_until_sold integer DEFAULT 12 NOT NULL,
    outside_horses_allowed boolean DEFAULT false NOT NULL,
    racehorse_allowed_2yo boolean DEFAULT false NOT NULL,
    racehorse_allowed_3yo boolean DEFAULT false NOT NULL,
    racehorse_allowed_older boolean DEFAULT false NOT NULL,
    reserve_pricing_allowed boolean DEFAULT false NOT NULL,
    spending_cap_per_stable integer,
    stallion_allowed boolean DEFAULT false NOT NULL,
    start_time timestamp with time zone NOT NULL,
    title character varying(500) NOT NULL,
    weanling_allowed boolean DEFAULT false NOT NULL,
    yearling_allowed boolean DEFAULT false NOT NULL,
    public_id character varying(12),
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_auctions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_auctions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_auctions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_auctions_id_seq OWNED BY public.new_auctions.id;


--
-- Name: new_broodmare_foal_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_broodmare_foal_records (
    id bigint NOT NULL,
    born_foals_count integer DEFAULT 0 NOT NULL,
    breed_ranking character varying,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    millionaire_foals_count integer DEFAULT 0 NOT NULL,
    multi_millionaire_foals_count integer DEFAULT 0 NOT NULL,
    multi_stakes_winning_foals_count integer DEFAULT 0 NOT NULL,
    raced_foals_count integer DEFAULT 0 NOT NULL,
    stakes_winning_foals_count integer DEFAULT 0 NOT NULL,
    stillborn_foals_count integer DEFAULT 0 NOT NULL,
    total_foal_earnings bigint DEFAULT 0 NOT NULL,
    total_foal_points integer DEFAULT 0 NOT NULL,
    total_foal_races integer DEFAULT 0 NOT NULL,
    unborn_foals_count integer DEFAULT 0 NOT NULL,
    winning_foals_count integer DEFAULT 0 NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_broodmare_foal_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_broodmare_foal_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_broodmare_foal_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_broodmare_foal_records_id_seq OWNED BY public.new_broodmare_foal_records.id;


--
-- Name: new_budget_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_budget_transactions (
    id bigint NOT NULL,
    activity_type public.budget_activity_type,
    amount integer DEFAULT 0 NOT NULL,
    balance integer DEFAULT 0 NOT NULL,
    description text NOT NULL,
    legacy_budget_id integer DEFAULT 0,
    legacy_stable_id integer DEFAULT 0,
    stable_id integer,
    old_stable_id uuid NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_budget_transactions.activity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_budget_transactions.activity_type IS 'sold_horse, bought_horse, bred_mare, bred_stud, claimed_horse, entered_race, shipped_horse, race_winnings, jockey_fee, nominated_racehorse, nominated_stallion, boarded_horse';


--
-- Name: new_budget_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_budget_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_budget_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_budget_transactions_id_seq OWNED BY public.new_budget_transactions.id;


--
-- Name: new_game_activity_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_game_activity_points (
    id bigint NOT NULL,
    activity_type public.activity_type NOT NULL,
    first_year_points integer DEFAULT 0 NOT NULL,
    older_year_points integer DEFAULT 0 NOT NULL,
    second_year_points integer DEFAULT 0 NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_game_activity_points.activity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_game_activity_points.activity_type IS 'color_war, auction, selling, buying, breeding, claiming, entering, redeem';


--
-- Name: new_game_activity_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_game_activity_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_game_activity_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_game_activity_points_id_seq OWNED BY public.new_game_activity_points.id;


--
-- Name: new_game_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_game_alerts (
    id bigint NOT NULL,
    display_to_newbies boolean DEFAULT true NOT NULL,
    display_to_non_newbies boolean DEFAULT true NOT NULL,
    end_time timestamp with time zone,
    message text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_game_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_game_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_game_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_game_alerts_id_seq OWNED BY public.new_game_alerts.id;


--
-- Name: new_horse_appearances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_horse_appearances (
    id bigint NOT NULL,
    birth_height numeric(4,2) DEFAULT 0.0,
    current_height numeric(4,2) DEFAULT 0.0,
    max_height numeric(4,2) DEFAULT 0.0,
    color public.horse_color DEFAULT 'bay'::public.horse_color NOT NULL,
    rf_leg_marking public.horse_leg_marking,
    lf_leg_marking public.horse_leg_marking,
    rh_leg_marking public.horse_leg_marking,
    lh_leg_marking public.horse_leg_marking,
    face_marking public.horse_face_marking,
    face_image character varying,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    lf_leg_image character varying,
    lh_leg_image character varying,
    rf_leg_image character varying,
    rh_leg_image character varying,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_horse_appearances.color; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horse_appearances.color IS 'bay, black, blood_bay, blue_roan, brown, chestnut, dapple_grey, dark_bay, dark_grey, flea_bitten_grey, grey, light_bay, light_chestnut, light_grey, liver_chestnut, mahogany_bay, red_chestnut, strawberry_roan';


--
-- Name: COLUMN new_horse_appearances.rf_leg_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horse_appearances.rf_leg_marking IS 'coronet, ermine, sock, stocking';


--
-- Name: COLUMN new_horse_appearances.lf_leg_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horse_appearances.lf_leg_marking IS 'coronet, ermine, sock, stocking';


--
-- Name: COLUMN new_horse_appearances.rh_leg_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horse_appearances.rh_leg_marking IS 'coronet, ermine, sock, stocking';


--
-- Name: COLUMN new_horse_appearances.lh_leg_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horse_appearances.lh_leg_marking IS 'coronet, ermine, sock, stocking';


--
-- Name: COLUMN new_horse_appearances.face_marking; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horse_appearances.face_marking IS 'bald_face, blaze, snip, star, star_snip, star_stripe, star_stripe_snip, stripe, stripe_snip';


--
-- Name: new_horse_appearances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_horse_appearances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_horse_appearances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_horse_appearances_id_seq OWNED BY public.new_horse_appearances.id;


--
-- Name: new_horse_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_horse_attributes (
    id bigint NOT NULL,
    track_record character varying DEFAULT 'Unraced'::character varying NOT NULL,
    title character varying,
    breeding_record public.breed_record DEFAULT 'none'::public.breed_record NOT NULL,
    dosage_text character varying,
    string character varying,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_horse_attributes.breeding_record; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horse_attributes.breeding_record IS 'none, bronze, silver, gold, platinum';


--
-- Name: new_horse_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_horse_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_horse_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_horse_attributes_id_seq OWNED BY public.new_horse_attributes.id;


--
-- Name: new_horse_genetics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_horse_genetics (
    id bigint NOT NULL,
    allele character varying(32) NOT NULL,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_horse_genetics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_horse_genetics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_horse_genetics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_horse_genetics_id_seq OWNED BY public.new_horse_genetics.id;


--
-- Name: new_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_horses (
    id bigint NOT NULL,
    public_id character varying(12),
    name character varying(18),
    slug character varying,
    date_of_birth date NOT NULL,
    date_of_death date,
    age integer DEFAULT 0 NOT NULL,
    gender public.horse_gender NOT NULL,
    status public.horse_status DEFAULT 'unborn'::public.horse_status NOT NULL,
    sire_id integer,
    old_sire_id uuid,
    dam_id integer,
    old_dam_id uuid,
    owner_id integer,
    old_owner_id uuid NOT NULL,
    breeder_id integer,
    old_breeder_id uuid NOT NULL,
    legacy_id integer,
    location_bred_id integer,
    old_location_bred_id uuid NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_horses.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horses.gender IS 'colt, filly, mare, stallion, gelding';


--
-- Name: COLUMN new_horses.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_horses.status IS 'unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased';


--
-- Name: new_horses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_horses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_horses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_horses_id_seq OWNED BY public.new_horses.id;


--
-- Name: new_jockeys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_jockeys (
    id bigint NOT NULL,
    public_id character varying(12),
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    date_of_birth date NOT NULL,
    status public.jockey_status,
    jockey_type public.jockey_type,
    height_in_inches integer NOT NULL,
    weight integer NOT NULL,
    slug character varying,
    gender public.jockey_gender,
    acceleration integer NOT NULL,
    average_speed integer NOT NULL,
    break_speed integer NOT NULL,
    closing integer NOT NULL,
    consistency integer NOT NULL,
    courage integer NOT NULL,
    dirt integer NOT NULL,
    experience integer NOT NULL,
    experience_rate integer NOT NULL,
    fast integer NOT NULL,
    good integer NOT NULL,
    "leading" integer NOT NULL,
    legacy_id integer NOT NULL,
    loaf_threshold integer NOT NULL,
    looking integer NOT NULL,
    max_speed integer NOT NULL,
    midpack integer NOT NULL,
    min_speed integer NOT NULL,
    off_pace integer NOT NULL,
    pissy integer NOT NULL,
    rating integer NOT NULL,
    slow integer NOT NULL,
    steeplechase integer NOT NULL,
    strength integer NOT NULL,
    traffic integer NOT NULL,
    turf integer NOT NULL,
    turning integer NOT NULL,
    wet integer NOT NULL,
    whip_seconds integer NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_jockeys.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_jockeys.status IS 'apprentice, veteran, retired';


--
-- Name: COLUMN new_jockeys.jockey_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_jockeys.jockey_type IS 'flat, jump';


--
-- Name: COLUMN new_jockeys.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_jockeys.gender IS 'male, female';


--
-- Name: new_jockeys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_jockeys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_jockeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_jockeys_id_seq OWNED BY public.new_jockeys.id;


--
-- Name: new_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_locations (
    id bigint NOT NULL,
    country character varying NOT NULL,
    county character varying,
    name character varying NOT NULL,
    state character varying,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_locations_id_seq OWNED BY public.new_locations.id;


--
-- Name: new_race_odds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_race_odds (
    id bigint NOT NULL,
    display character varying NOT NULL,
    value numeric(3,1) NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_race_odds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_race_odds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_race_odds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_race_odds_id_seq OWNED BY public.new_race_odds.id;


--
-- Name: new_race_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_race_records (
    id bigint NOT NULL,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    year integer DEFAULT 1996 NOT NULL,
    result_type public.race_result_types DEFAULT 'dirt'::public.race_result_types,
    starts integer DEFAULT 0 NOT NULL,
    stakes_starts integer DEFAULT 0 NOT NULL,
    wins integer DEFAULT 0 NOT NULL,
    stakes_wins integer DEFAULT 0 NOT NULL,
    seconds integer DEFAULT 0 NOT NULL,
    stakes_seconds integer DEFAULT 0 NOT NULL,
    thirds integer DEFAULT 0 NOT NULL,
    stakes_thirds integer DEFAULT 0 NOT NULL,
    fourths integer DEFAULT 0 NOT NULL,
    stakes_fourths integer DEFAULT 0 NOT NULL,
    points integer DEFAULT 0 NOT NULL,
    earnings bigint DEFAULT 0 NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_race_records.result_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_records.result_type IS 'dirt, turf, steeplechase';


--
-- Name: new_race_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_race_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_race_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_race_records_id_seq OWNED BY public.new_race_records.id;


--
-- Name: new_race_result_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_race_result_horses (
    id bigint NOT NULL,
    race_id integer,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    legacy_horse_id integer DEFAULT 0 NOT NULL,
    post_parade integer DEFAULT 1 NOT NULL,
    finish_position integer DEFAULT 1 NOT NULL,
    positions character varying NOT NULL,
    margins character varying NOT NULL,
    fractions character varying,
    jockey_id integer,
    old_jockey_id uuid,
    equipment integer DEFAULT 0 NOT NULL,
    odd_id integer,
    old_odd_id uuid,
    old_race_id uuid NOT NULL,
    speed_factor integer DEFAULT 0 NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_race_result_horses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_race_result_horses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_race_result_horses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_race_result_horses_id_seq OWNED BY public.new_race_result_horses.id;


--
-- Name: new_race_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_race_results (
    id bigint NOT NULL,
    date date NOT NULL,
    number integer DEFAULT 1 NOT NULL,
    race_type public.race_type DEFAULT 'maiden'::public.race_type NOT NULL,
    age public.race_age DEFAULT '2'::public.race_age NOT NULL,
    male_only boolean DEFAULT false NOT NULL,
    female_only boolean DEFAULT false NOT NULL,
    distance numeric(3,1) DEFAULT 5.0 NOT NULL,
    grade public.race_grade,
    surface_id integer,
    old_surface_id uuid NOT NULL,
    condition public.track_condition,
    name character varying,
    purse bigint DEFAULT 0 NOT NULL,
    claiming_price integer,
    split public.race_splits,
    time_in_seconds numeric(7,3) DEFAULT 0.0 NOT NULL,
    slug character varying,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_race_results.race_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_results.race_type IS 'maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes';


--
-- Name: COLUMN new_race_results.age; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_results.age IS '2, 2+, 3, 3+, 4, 4+';


--
-- Name: COLUMN new_race_results.grade; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_results.grade IS 'Ungraded, Grade 3, Grade 2, Grade 1';


--
-- Name: COLUMN new_race_results.condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_results.condition IS 'fast, good, slow, wet';


--
-- Name: COLUMN new_race_results.split; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_results.split IS '4Q, 2F';


--
-- Name: new_race_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_race_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_race_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_race_results_id_seq OWNED BY public.new_race_results.id;


--
-- Name: new_race_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_race_schedules (
    id bigint NOT NULL,
    day_number integer DEFAULT 1 NOT NULL,
    date date NOT NULL,
    number integer DEFAULT 1 NOT NULL,
    race_type public.race_type DEFAULT 'maiden'::public.race_type NOT NULL,
    age public.race_age DEFAULT '2'::public.race_age NOT NULL,
    male_only boolean DEFAULT false NOT NULL,
    female_only boolean DEFAULT false NOT NULL,
    distance numeric(3,1) DEFAULT 5.0 NOT NULL,
    grade public.race_grade,
    surface_id integer,
    old_surface_id uuid NOT NULL,
    name character varying,
    purse bigint DEFAULT 0 NOT NULL,
    claiming_price integer,
    qualification_required boolean DEFAULT false NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_race_schedules.race_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_schedules.race_type IS 'maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes';


--
-- Name: COLUMN new_race_schedules.age; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_schedules.age IS '2, 2+, 3, 3+, 4, 4+';


--
-- Name: COLUMN new_race_schedules.grade; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_race_schedules.grade IS 'Ungraded, Grade 3, Grade 2, Grade 1';


--
-- Name: new_race_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_race_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_race_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_race_schedules_id_seq OWNED BY public.new_race_schedules.id;


--
-- Name: new_racetracks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_racetracks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying,
    public_id character varying(12),
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    location_id integer,
    old_location_id uuid NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_racetracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_racetracks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_racetracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_racetracks_id_seq OWNED BY public.new_racetracks.id;


--
-- Name: new_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_sessions (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    user_id integer,
    old_user_id uuid,
    data text,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_sessions_id_seq OWNED BY public.new_sessions.id;


--
-- Name: new_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_settings (
    id bigint NOT NULL,
    user_id integer,
    old_user_id uuid NOT NULL,
    theme character varying,
    locale character varying,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_settings_id_seq OWNED BY public.new_settings.id;


--
-- Name: new_stables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_stables (
    id bigint NOT NULL,
    name character varying NOT NULL,
    legacy_id integer,
    slug character varying,
    public_id character varying(12),
    available_balance bigint DEFAULT 0,
    total_balance bigint DEFAULT 0,
    last_online_at timestamp with time zone,
    description text,
    miles_from_track integer DEFAULT 1 NOT NULL,
    racetrack_id integer,
    old_racetrack_id uuid,
    user_id integer,
    old_user_id uuid NOT NULL,
    old_id uuid NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_stables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_stables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_stables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_stables_id_seq OWNED BY public.new_stables.id;


--
-- Name: new_track_surfaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_track_surfaces (
    id bigint NOT NULL,
    surface public.track_surface DEFAULT 'dirt'::public.track_surface NOT NULL,
    condition public.track_condition DEFAULT 'fast'::public.track_condition NOT NULL,
    racetrack_id integer,
    old_racetrack_id uuid NOT NULL,
    banking integer NOT NULL,
    jumps integer DEFAULT 0 NOT NULL,
    length integer NOT NULL,
    turn_distance integer NOT NULL,
    turn_to_finish_length integer NOT NULL,
    width integer NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_track_surfaces.surface; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_track_surfaces.surface IS 'dirt, turf, steeplechase';


--
-- Name: COLUMN new_track_surfaces.condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_track_surfaces.condition IS 'fast, good, slow, wet';


--
-- Name: new_track_surfaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_track_surfaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_track_surfaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_track_surfaces_id_seq OWNED BY public.new_track_surfaces.id;


--
-- Name: new_training_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_training_schedules (
    id bigint NOT NULL,
    name character varying NOT NULL,
    stable_id integer,
    old_stable_id uuid NOT NULL,
    horses_count integer DEFAULT 0 NOT NULL,
    monday_activities character varying NOT NULL,
    tuesday_activities character varying NOT NULL,
    wednesday_activities character varying NOT NULL,
    thursday_activities character varying NOT NULL,
    friday_activities character varying NOT NULL,
    saturday_activities character varying NOT NULL,
    sunday_activities character varying NOT NULL,
    description text,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_training_schedules_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_training_schedules_horses (
    id bigint NOT NULL,
    horse_id integer,
    old_horse_id uuid NOT NULL,
    training_schedule_id integer,
    old_training_schedule_id uuid NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_training_schedules_horses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_training_schedules_horses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_training_schedules_horses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_training_schedules_horses_id_seq OWNED BY public.new_training_schedules_horses.id;


--
-- Name: new_training_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_training_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_training_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_training_schedules_id_seq OWNED BY public.new_training_schedules.id;


--
-- Name: new_user_push_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_user_push_subscriptions (
    id bigint NOT NULL,
    user_id integer,
    old_user_id uuid NOT NULL,
    user_agent character varying,
    auth_key character varying,
    endpoint character varying,
    p256dh_key character varying,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: new_user_push_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_user_push_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_user_push_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_user_push_subscriptions_id_seq OWNED BY public.new_user_push_subscriptions.id;


--
-- Name: new_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.new_users (
    id bigint NOT NULL,
    slug character varying,
    username character varying NOT NULL,
    public_id character varying(12),
    status public.user_status DEFAULT 'pending'::public.user_status NOT NULL,
    discourse_id integer,
    email character varying DEFAULT ''::character varying NOT NULL,
    name character varying NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    developer boolean DEFAULT false NOT NULL,
    discarded_at timestamp with time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp with time zone,
    current_sign_in_ip character varying,
    unconfirmed_email character varying,
    remember_created_at timestamp with time zone,
    failed_attempts integer DEFAULT 0 NOT NULL,
    last_sign_in_at timestamp with time zone,
    last_sign_in_ip character varying,
    locked_at timestamp with time zone,
    unlock_token character varying,
    reset_password_sent_at timestamp with time zone,
    reset_password_token character varying,
    confirmation_sent_at timestamp with time zone,
    confirmation_token character varying,
    confirmed_at timestamp with time zone,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN new_users.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.new_users.status IS 'pending, active, deleted, banned';


--
-- Name: new_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.new_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: new_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.new_users_id_seq OWNED BY public.new_users.id;


--
-- Name: race_odds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_odds (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    display character varying NOT NULL,
    value numeric(3,1) NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: race_result_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_result_horses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    race_id uuid NOT NULL,
    horse_id uuid NOT NULL,
    legacy_horse_id integer DEFAULT 0 NOT NULL,
    post_parade integer DEFAULT 1 NOT NULL,
    finish_position integer DEFAULT 1 NOT NULL,
    positions character varying NOT NULL,
    margins character varying NOT NULL,
    fractions character varying,
    jockey_id uuid,
    equipment integer DEFAULT 0 NOT NULL,
    odd_id uuid,
    speed_factor integer DEFAULT 0 NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: race_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_results (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    date date NOT NULL,
    number integer DEFAULT 1 NOT NULL,
    race_type public.race_type DEFAULT 'maiden'::public.race_type NOT NULL,
    age public.race_age DEFAULT '2'::public.race_age NOT NULL,
    male_only boolean DEFAULT false NOT NULL,
    female_only boolean DEFAULT false NOT NULL,
    distance numeric(3,1) DEFAULT 5.0 NOT NULL,
    grade public.race_grade,
    surface_id uuid NOT NULL,
    condition public.track_condition,
    name character varying,
    purse integer DEFAULT 0 NOT NULL,
    claiming_price integer,
    split public.race_splits,
    time_in_seconds numeric(7,3) DEFAULT 0.0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN race_results.race_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_results.race_type IS 'maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes';


--
-- Name: COLUMN race_results.age; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_results.age IS '2, 2+, 3, 3+, 4, 4+';


--
-- Name: COLUMN race_results.grade; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_results.grade IS 'Ungraded, Grade 3, Grade 2, Grade 1';


--
-- Name: COLUMN race_results.condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_results.condition IS 'fast, good, slow, wet';


--
-- Name: COLUMN race_results.split; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_results.split IS '4Q, 2F';


--
-- Name: race_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    day_number integer DEFAULT 1 NOT NULL,
    date date NOT NULL,
    number integer DEFAULT 1 NOT NULL,
    race_type public.race_type DEFAULT 'maiden'::public.race_type NOT NULL,
    age public.race_age DEFAULT '2'::public.race_age NOT NULL,
    male_only boolean DEFAULT false NOT NULL,
    female_only boolean DEFAULT false NOT NULL,
    distance numeric(3,1) DEFAULT 5.0 NOT NULL,
    grade public.race_grade,
    surface_id uuid NOT NULL,
    name character varying,
    purse integer DEFAULT 0 NOT NULL,
    claiming_price integer,
    qualification_required boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN race_schedules.race_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_schedules.race_type IS 'maiden, claiming, starter_allowance, nw1_allowance, nw2_allowance, nw3_allowance, allowance, stakes';


--
-- Name: COLUMN race_schedules.age; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_schedules.age IS '2, 2+, 3, 3+, 4, 4+';


--
-- Name: COLUMN race_schedules.grade; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_schedules.grade IS 'Ungraded, Grade 3, Grade 2, Grade 1';


--
-- Name: racetracks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.racetracks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    location_id uuid NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    user_id character varying,
    data text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    theme character varying,
    locale character varying,
    user_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: stables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stables (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    user_id uuid NOT NULL,
    legacy_id integer,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    last_online_at timestamp with time zone,
    horses_count integer DEFAULT 0 NOT NULL,
    bred_horses_count integer DEFAULT 0 NOT NULL,
    unborn_horses_count integer DEFAULT 0 NOT NULL,
    available_balance integer DEFAULT 0,
    total_balance integer DEFAULT 0,
    racetrack_id uuid,
    miles_from_track integer DEFAULT 1 NOT NULL
);


--
-- Name: track_surfaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.track_surfaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    racetrack_id uuid NOT NULL,
    surface public.track_surface DEFAULT 'dirt'::public.track_surface NOT NULL,
    condition public.track_condition DEFAULT 'fast'::public.track_condition NOT NULL,
    width integer NOT NULL,
    length integer NOT NULL,
    turn_to_finish_length integer NOT NULL,
    turn_distance integer NOT NULL,
    banking integer NOT NULL,
    jumps integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: COLUMN track_surfaces.surface; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.track_surfaces.surface IS 'dirt, turf, steeplechase';


--
-- Name: COLUMN track_surfaces.condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.track_surfaces.condition IS 'fast, good, slow, wet';


--
-- Name: training_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    stable_id uuid NOT NULL,
    name character varying NOT NULL,
    description text,
    sunday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    monday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    tuesday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    wednesday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    thursday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    friday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    saturday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    horses_count integer DEFAULT 0 NOT NULL
);


--
-- Name: training_schedules_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_schedules_horses (
    id bigint NOT NULL,
    training_schedule_id uuid NOT NULL,
    horse_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: training_schedules_horses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.training_schedules_horses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_schedules_horses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.training_schedules_horses_id_seq OWNED BY public.training_schedules_horses.id;


--
-- Name: user_push_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_push_subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    auth_key character varying,
    endpoint character varying,
    p256dh_key character varying,
    user_agent character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    slug character varying,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying NOT NULL,
    status public.user_status DEFAULT 'pending'::public.user_status NOT NULL,
    name character varying NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    discourse_id integer,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp with time zone,
    remember_created_at timestamp with time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp with time zone,
    confirmation_sent_at timestamp with time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    discarded_at timestamp with time zone,
    developer boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN users.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.status IS 'pending, active, deleted, banned';


--
-- Name: COLUMN users.discourse_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.discourse_id IS 'integer from Discourse forum';


--
-- Name: activations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activations ALTER COLUMN id SET DEFAULT nextval('public.activations_id_seq'::regclass);


--
-- Name: motor_alert_locks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_alert_locks ALTER COLUMN id SET DEFAULT nextval('public.motor_alert_locks_id_seq'::regclass);


--
-- Name: motor_alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_alerts ALTER COLUMN id SET DEFAULT nextval('public.motor_alerts_id_seq'::regclass);


--
-- Name: motor_api_configs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_api_configs ALTER COLUMN id SET DEFAULT nextval('public.motor_api_configs_id_seq'::regclass);


--
-- Name: motor_audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_audits ALTER COLUMN id SET DEFAULT nextval('public.motor_audits_id_seq'::regclass);


--
-- Name: motor_configs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_configs ALTER COLUMN id SET DEFAULT nextval('public.motor_configs_id_seq'::regclass);


--
-- Name: motor_dashboards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_dashboards ALTER COLUMN id SET DEFAULT nextval('public.motor_dashboards_id_seq'::regclass);


--
-- Name: motor_forms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_forms ALTER COLUMN id SET DEFAULT nextval('public.motor_forms_id_seq'::regclass);


--
-- Name: motor_queries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_queries ALTER COLUMN id SET DEFAULT nextval('public.motor_queries_id_seq'::regclass);


--
-- Name: motor_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_resources ALTER COLUMN id SET DEFAULT nextval('public.motor_resources_id_seq'::regclass);


--
-- Name: motor_taggable_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_taggable_tags ALTER COLUMN id SET DEFAULT nextval('public.motor_taggable_tags_id_seq'::regclass);


--
-- Name: motor_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_tags ALTER COLUMN id SET DEFAULT nextval('public.motor_tags_id_seq'::regclass);


--
-- Name: new_activations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_activations ALTER COLUMN id SET DEFAULT nextval('public.new_activations_id_seq'::regclass);


--
-- Name: new_activity_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_activity_points ALTER COLUMN id SET DEFAULT nextval('public.new_activity_points_id_seq'::regclass);


--
-- Name: new_auction_bids id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_auction_bids ALTER COLUMN id SET DEFAULT nextval('public.new_auction_bids_id_seq'::regclass);


--
-- Name: new_auction_consignment_configs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_auction_consignment_configs ALTER COLUMN id SET DEFAULT nextval('public.new_auction_consignment_configs_id_seq'::regclass);


--
-- Name: new_auction_horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_auction_horses ALTER COLUMN id SET DEFAULT nextval('public.new_auction_horses_id_seq'::regclass);


--
-- Name: new_auctions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_auctions ALTER COLUMN id SET DEFAULT nextval('public.new_auctions_id_seq'::regclass);


--
-- Name: new_broodmare_foal_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_broodmare_foal_records ALTER COLUMN id SET DEFAULT nextval('public.new_broodmare_foal_records_id_seq'::regclass);


--
-- Name: new_budget_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_budget_transactions ALTER COLUMN id SET DEFAULT nextval('public.new_budget_transactions_id_seq'::regclass);


--
-- Name: new_game_activity_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_game_activity_points ALTER COLUMN id SET DEFAULT nextval('public.new_game_activity_points_id_seq'::regclass);


--
-- Name: new_game_alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_game_alerts ALTER COLUMN id SET DEFAULT nextval('public.new_game_alerts_id_seq'::regclass);


--
-- Name: new_horse_appearances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_horse_appearances ALTER COLUMN id SET DEFAULT nextval('public.new_horse_appearances_id_seq'::regclass);


--
-- Name: new_horse_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_horse_attributes ALTER COLUMN id SET DEFAULT nextval('public.new_horse_attributes_id_seq'::regclass);


--
-- Name: new_horse_genetics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_horse_genetics ALTER COLUMN id SET DEFAULT nextval('public.new_horse_genetics_id_seq'::regclass);


--
-- Name: new_horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_horses ALTER COLUMN id SET DEFAULT nextval('public.new_horses_id_seq'::regclass);


--
-- Name: new_jockeys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_jockeys ALTER COLUMN id SET DEFAULT nextval('public.new_jockeys_id_seq'::regclass);


--
-- Name: new_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_locations ALTER COLUMN id SET DEFAULT nextval('public.new_locations_id_seq'::regclass);


--
-- Name: new_race_odds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_odds ALTER COLUMN id SET DEFAULT nextval('public.new_race_odds_id_seq'::regclass);


--
-- Name: new_race_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_records ALTER COLUMN id SET DEFAULT nextval('public.new_race_records_id_seq'::regclass);


--
-- Name: new_race_result_horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_result_horses ALTER COLUMN id SET DEFAULT nextval('public.new_race_result_horses_id_seq'::regclass);


--
-- Name: new_race_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_results ALTER COLUMN id SET DEFAULT nextval('public.new_race_results_id_seq'::regclass);


--
-- Name: new_race_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_schedules ALTER COLUMN id SET DEFAULT nextval('public.new_race_schedules_id_seq'::regclass);


--
-- Name: new_racetracks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_racetracks ALTER COLUMN id SET DEFAULT nextval('public.new_racetracks_id_seq'::regclass);


--
-- Name: new_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_sessions ALTER COLUMN id SET DEFAULT nextval('public.new_sessions_id_seq'::regclass);


--
-- Name: new_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_settings ALTER COLUMN id SET DEFAULT nextval('public.new_settings_id_seq'::regclass);


--
-- Name: new_stables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_stables ALTER COLUMN id SET DEFAULT nextval('public.new_stables_id_seq'::regclass);


--
-- Name: new_track_surfaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_track_surfaces ALTER COLUMN id SET DEFAULT nextval('public.new_track_surfaces_id_seq'::regclass);


--
-- Name: new_training_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_training_schedules ALTER COLUMN id SET DEFAULT nextval('public.new_training_schedules_id_seq'::regclass);


--
-- Name: new_training_schedules_horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_training_schedules_horses ALTER COLUMN id SET DEFAULT nextval('public.new_training_schedules_horses_id_seq'::regclass);


--
-- Name: new_user_push_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_user_push_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.new_user_push_subscriptions_id_seq'::regclass);


--
-- Name: new_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_users ALTER COLUMN id SET DEFAULT nextval('public.new_users_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: training_schedules_horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules_horses ALTER COLUMN id SET DEFAULT nextval('public.training_schedules_horses_id_seq'::regclass);


--
-- Name: activations activations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT activations_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: activity_points activity_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_points
    ADD CONSTRAINT activity_points_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: auction_bids auction_bids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_bids
    ADD CONSTRAINT auction_bids_pkey PRIMARY KEY (id);


--
-- Name: auction_consignment_configs auction_consignment_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_consignment_configs
    ADD CONSTRAINT auction_consignment_configs_pkey PRIMARY KEY (id);


--
-- Name: auction_horses auction_horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_horses
    ADD CONSTRAINT auction_horses_pkey PRIMARY KEY (id);


--
-- Name: auctions auctions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auctions
    ADD CONSTRAINT auctions_pkey PRIMARY KEY (id);


--
-- Name: broodmare_foal_records broodmare_foal_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_foal_records
    ADD CONSTRAINT broodmare_foal_records_pkey PRIMARY KEY (id);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (version);


--
-- Name: game_activity_points game_activity_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_activity_points
    ADD CONSTRAINT game_activity_points_pkey PRIMARY KEY (id);


--
-- Name: game_alerts game_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_alerts
    ADD CONSTRAINT game_alerts_pkey PRIMARY KEY (id);


--
-- Name: horse_appearances horse_appearances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_appearances
    ADD CONSTRAINT horse_appearances_pkey PRIMARY KEY (id);


--
-- Name: horse_attributes horse_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_attributes
    ADD CONSTRAINT horse_attributes_pkey PRIMARY KEY (id);


--
-- Name: horse_genetics horse_genetics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_genetics
    ADD CONSTRAINT horse_genetics_pkey PRIMARY KEY (id);


--
-- Name: horses horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT horses_pkey PRIMARY KEY (id);


--
-- Name: jockeys jockeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jockeys
    ADD CONSTRAINT jockeys_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: motor_alert_locks motor_alert_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_alert_locks
    ADD CONSTRAINT motor_alert_locks_pkey PRIMARY KEY (id);


--
-- Name: motor_alerts motor_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_alerts
    ADD CONSTRAINT motor_alerts_pkey PRIMARY KEY (id);


--
-- Name: motor_api_configs motor_api_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_api_configs
    ADD CONSTRAINT motor_api_configs_pkey PRIMARY KEY (id);


--
-- Name: motor_audits motor_audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_audits
    ADD CONSTRAINT motor_audits_pkey PRIMARY KEY (id);


--
-- Name: motor_configs motor_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_configs
    ADD CONSTRAINT motor_configs_pkey PRIMARY KEY (id);


--
-- Name: motor_dashboards motor_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_dashboards
    ADD CONSTRAINT motor_dashboards_pkey PRIMARY KEY (id);


--
-- Name: motor_forms motor_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_forms
    ADD CONSTRAINT motor_forms_pkey PRIMARY KEY (id);


--
-- Name: motor_queries motor_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_queries
    ADD CONSTRAINT motor_queries_pkey PRIMARY KEY (id);


--
-- Name: motor_resources motor_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_resources
    ADD CONSTRAINT motor_resources_pkey PRIMARY KEY (id);


--
-- Name: motor_taggable_tags motor_taggable_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_taggable_tags
    ADD CONSTRAINT motor_taggable_tags_pkey PRIMARY KEY (id);


--
-- Name: motor_tags motor_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_tags
    ADD CONSTRAINT motor_tags_pkey PRIMARY KEY (id);


--
-- Name: new_activations new_activations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_activations
    ADD CONSTRAINT new_activations_pkey PRIMARY KEY (id);


--
-- Name: new_activity_points new_activity_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_activity_points
    ADD CONSTRAINT new_activity_points_pkey PRIMARY KEY (id);


--
-- Name: new_auction_bids new_auction_bids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_auction_bids
    ADD CONSTRAINT new_auction_bids_pkey PRIMARY KEY (id);


--
-- Name: new_auction_consignment_configs new_auction_consignment_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_auction_consignment_configs
    ADD CONSTRAINT new_auction_consignment_configs_pkey PRIMARY KEY (id);


--
-- Name: new_auction_horses new_auction_horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_auction_horses
    ADD CONSTRAINT new_auction_horses_pkey PRIMARY KEY (id);


--
-- Name: new_auctions new_auctions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_auctions
    ADD CONSTRAINT new_auctions_pkey PRIMARY KEY (id);


--
-- Name: new_broodmare_foal_records new_broodmare_foal_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_broodmare_foal_records
    ADD CONSTRAINT new_broodmare_foal_records_pkey PRIMARY KEY (id);


--
-- Name: new_budget_transactions new_budget_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_budget_transactions
    ADD CONSTRAINT new_budget_transactions_pkey PRIMARY KEY (id);


--
-- Name: new_game_activity_points new_game_activity_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_game_activity_points
    ADD CONSTRAINT new_game_activity_points_pkey PRIMARY KEY (id);


--
-- Name: new_game_alerts new_game_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_game_alerts
    ADD CONSTRAINT new_game_alerts_pkey PRIMARY KEY (id);


--
-- Name: new_horse_appearances new_horse_appearances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_horse_appearances
    ADD CONSTRAINT new_horse_appearances_pkey PRIMARY KEY (id);


--
-- Name: new_horse_attributes new_horse_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_horse_attributes
    ADD CONSTRAINT new_horse_attributes_pkey PRIMARY KEY (id);


--
-- Name: new_horse_genetics new_horse_genetics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_horse_genetics
    ADD CONSTRAINT new_horse_genetics_pkey PRIMARY KEY (id);


--
-- Name: new_horses new_horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_horses
    ADD CONSTRAINT new_horses_pkey PRIMARY KEY (id);


--
-- Name: new_jockeys new_jockeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_jockeys
    ADD CONSTRAINT new_jockeys_pkey PRIMARY KEY (id);


--
-- Name: new_locations new_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_locations
    ADD CONSTRAINT new_locations_pkey PRIMARY KEY (id);


--
-- Name: new_race_odds new_race_odds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_odds
    ADD CONSTRAINT new_race_odds_pkey PRIMARY KEY (id);


--
-- Name: new_race_records new_race_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_records
    ADD CONSTRAINT new_race_records_pkey PRIMARY KEY (id);


--
-- Name: new_race_result_horses new_race_result_horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_result_horses
    ADD CONSTRAINT new_race_result_horses_pkey PRIMARY KEY (id);


--
-- Name: new_race_results new_race_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_results
    ADD CONSTRAINT new_race_results_pkey PRIMARY KEY (id);


--
-- Name: new_race_schedules new_race_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_race_schedules
    ADD CONSTRAINT new_race_schedules_pkey PRIMARY KEY (id);


--
-- Name: new_racetracks new_racetracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_racetracks
    ADD CONSTRAINT new_racetracks_pkey PRIMARY KEY (id);


--
-- Name: new_sessions new_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_sessions
    ADD CONSTRAINT new_sessions_pkey PRIMARY KEY (id);


--
-- Name: new_settings new_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_settings
    ADD CONSTRAINT new_settings_pkey PRIMARY KEY (id);


--
-- Name: new_stables new_stables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_stables
    ADD CONSTRAINT new_stables_pkey PRIMARY KEY (id);


--
-- Name: new_track_surfaces new_track_surfaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_track_surfaces
    ADD CONSTRAINT new_track_surfaces_pkey PRIMARY KEY (id);


--
-- Name: new_training_schedules_horses new_training_schedules_horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_training_schedules_horses
    ADD CONSTRAINT new_training_schedules_horses_pkey PRIMARY KEY (id);


--
-- Name: new_training_schedules new_training_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_training_schedules
    ADD CONSTRAINT new_training_schedules_pkey PRIMARY KEY (id);


--
-- Name: new_user_push_subscriptions new_user_push_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_user_push_subscriptions
    ADD CONSTRAINT new_user_push_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: new_users new_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.new_users
    ADD CONSTRAINT new_users_pkey PRIMARY KEY (id);


--
-- Name: race_odds race_odds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_odds
    ADD CONSTRAINT race_odds_pkey PRIMARY KEY (id);


--
-- Name: race_records race_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_records
    ADD CONSTRAINT race_records_pkey PRIMARY KEY (id);


--
-- Name: race_result_horses race_result_horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT race_result_horses_pkey PRIMARY KEY (id);


--
-- Name: race_results race_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_results
    ADD CONSTRAINT race_results_pkey PRIMARY KEY (id);


--
-- Name: race_schedules race_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_schedules
    ADD CONSTRAINT race_schedules_pkey PRIMARY KEY (id);


--
-- Name: racetracks racetracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racetracks
    ADD CONSTRAINT racetracks_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: stables stables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stables
    ADD CONSTRAINT stables_pkey PRIMARY KEY (id);


--
-- Name: track_surfaces track_surfaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_surfaces
    ADD CONSTRAINT track_surfaces_pkey PRIMARY KEY (id);


--
-- Name: training_schedules_horses training_schedules_horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules_horses
    ADD CONSTRAINT training_schedules_horses_pkey PRIMARY KEY (id);


--
-- Name: training_schedules training_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules
    ADD CONSTRAINT training_schedules_pkey PRIMARY KEY (id);


--
-- Name: user_push_subscriptions user_push_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_push_subscriptions
    ADD CONSTRAINT user_push_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_on_multi_millionaire_foals_count_d9fbaf71a9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_multi_millionaire_foals_count_d9fbaf71a9 ON public.new_broodmare_foal_records USING btree (multi_millionaire_foals_count);


--
-- Name: idx_on_multi_stakes_winning_foals_count_6dd74b327f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_multi_stakes_winning_foals_count_6dd74b327f ON public.new_broodmare_foal_records USING btree (multi_stakes_winning_foals_count);


--
-- Name: idx_on_multi_stakes_winning_foals_count_d86a3500a8; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_multi_stakes_winning_foals_count_d86a3500a8 ON public.broodmare_foal_records USING btree (multi_stakes_winning_foals_count);


--
-- Name: idx_on_old_training_schedule_id_11937fe10b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_old_training_schedule_id_11937fe10b ON public.new_training_schedules_horses USING btree (old_training_schedule_id);


--
-- Name: index_activations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_activations_on_user_id ON public.activations USING btree (user_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_activity_points_on_activity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activity_points_on_activity_type ON public.activity_points USING btree (activity_type);


--
-- Name: index_activity_points_on_budget_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activity_points_on_budget_id ON public.activity_points USING btree (budget_id);


--
-- Name: index_activity_points_on_legacy_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activity_points_on_legacy_stable_id ON public.activity_points USING btree (legacy_stable_id);


--
-- Name: index_activity_points_on_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activity_points_on_stable_id ON public.activity_points USING btree (stable_id);


--
-- Name: index_auction_bids_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_bids_on_auction_id ON public.auction_bids USING btree (auction_id);


--
-- Name: index_auction_bids_on_bidder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_bids_on_bidder_id ON public.auction_bids USING btree (bidder_id);


--
-- Name: index_auction_bids_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_bids_on_horse_id ON public.auction_bids USING btree (horse_id);


--
-- Name: index_auction_consignment_configs_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_consignment_configs_on_auction_id ON public.auction_consignment_configs USING btree (auction_id);


--
-- Name: index_auction_horses_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_horses_on_auction_id ON public.auction_horses USING btree (auction_id);


--
-- Name: index_auction_horses_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auction_horses_on_horse_id ON public.auction_horses USING btree (horse_id);


--
-- Name: index_auction_horses_on_sold_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_horses_on_sold_at ON public.auction_horses USING btree (sold_at);


--
-- Name: index_auctions_on_auctioneer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auctions_on_auctioneer_id ON public.auctions USING btree (auctioneer_id);


--
-- Name: index_auctions_on_end_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auctions_on_end_time ON public.auctions USING btree (end_time);


--
-- Name: index_auctions_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auctions_on_start_time ON public.auctions USING btree (start_time);


--
-- Name: index_auctions_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auctions_on_title ON public.auctions USING btree (lower((title)::text));


--
-- Name: index_broodmare_foal_records_on_born_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_born_foals_count ON public.broodmare_foal_records USING btree (born_foals_count);


--
-- Name: index_broodmare_foal_records_on_breed_ranking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_breed_ranking ON public.broodmare_foal_records USING btree (breed_ranking);


--
-- Name: index_broodmare_foal_records_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_broodmare_foal_records_on_horse_id ON public.broodmare_foal_records USING btree (horse_id);


--
-- Name: index_broodmare_foal_records_on_millionaire_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_millionaire_foals_count ON public.broodmare_foal_records USING btree (millionaire_foals_count);


--
-- Name: index_broodmare_foal_records_on_multi_millionaire_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_multi_millionaire_foals_count ON public.broodmare_foal_records USING btree (multi_millionaire_foals_count);


--
-- Name: index_broodmare_foal_records_on_raced_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_raced_foals_count ON public.broodmare_foal_records USING btree (raced_foals_count);


--
-- Name: index_broodmare_foal_records_on_stakes_winning_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_stakes_winning_foals_count ON public.broodmare_foal_records USING btree (stakes_winning_foals_count);


--
-- Name: index_broodmare_foal_records_on_unborn_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_unborn_foals_count ON public.broodmare_foal_records USING btree (unborn_foals_count);


--
-- Name: index_broodmare_foal_records_on_winning_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_winning_foals_count ON public.broodmare_foal_records USING btree (winning_foals_count);


--
-- Name: index_budgets_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budgets_on_description ON public.budgets USING btree (description);


--
-- Name: index_budgets_on_legacy_budget_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budgets_on_legacy_budget_id ON public.budgets USING btree (legacy_budget_id);


--
-- Name: index_budgets_on_legacy_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budgets_on_legacy_stable_id ON public.budgets USING btree (legacy_stable_id);


--
-- Name: index_budgets_on_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budgets_on_stable_id ON public.budgets USING btree (stable_id);


--
-- Name: index_consignment_configs_on_horse_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_consignment_configs_on_horse_type ON public.auction_consignment_configs USING btree (auction_id, lower((horse_type)::text));


--
-- Name: index_game_activity_points_on_activity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_activity_points_on_activity_type ON public.game_activity_points USING btree (activity_type);


--
-- Name: index_game_alerts_on_end_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_alerts_on_end_time ON public.game_alerts USING btree (end_time);


--
-- Name: index_game_alerts_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_alerts_on_start_time ON public.game_alerts USING btree (start_time);


--
-- Name: index_horse_appearances_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_horse_appearances_on_horse_id ON public.horse_appearances USING btree (horse_id);


--
-- Name: index_horse_attributes_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_horse_attributes_on_horse_id ON public.horse_attributes USING btree (horse_id);


--
-- Name: index_horse_genetics_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_horse_genetics_on_horse_id ON public.horse_genetics USING btree (horse_id);


--
-- Name: index_horses_on_breeder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_breeder_id ON public.horses USING btree (breeder_id);


--
-- Name: index_horses_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_created_at ON public.horses USING btree (created_at);


--
-- Name: index_horses_on_dam_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_dam_id ON public.horses USING btree (dam_id);


--
-- Name: index_horses_on_date_of_birth; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_date_of_birth ON public.horses USING btree (date_of_birth);


--
-- Name: index_horses_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_horses_on_legacy_id ON public.horses USING btree (legacy_id);


--
-- Name: index_horses_on_location_bred_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_location_bred_id ON public.horses USING btree (location_bred_id);


--
-- Name: index_horses_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_name ON public.horses USING btree (name);


--
-- Name: index_horses_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_owner_id ON public.horses USING btree (owner_id);


--
-- Name: index_horses_on_sire_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_sire_id ON public.horses USING btree (sire_id);


--
-- Name: index_horses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_horses_on_slug ON public.horses USING btree (slug);


--
-- Name: index_horses_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_status ON public.horses USING btree (status);


--
-- Name: index_jockeys_on_gender; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_gender ON public.jockeys USING btree (gender);


--
-- Name: index_jockeys_on_height_in_inches; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_height_in_inches ON public.jockeys USING btree (height_in_inches);


--
-- Name: index_jockeys_on_jockey_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_jockey_type ON public.jockeys USING btree (jockey_type);


--
-- Name: index_jockeys_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_legacy_id ON public.jockeys USING btree (legacy_id);


--
-- Name: index_jockeys_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_status ON public.jockeys USING btree (status);


--
-- Name: index_jockeys_on_weight; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_weight ON public.jockeys USING btree (weight);


--
-- Name: index_lifetime_race_records_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lifetime_race_records_on_horse_id ON public.lifetime_race_records USING btree (horse_id);


--
-- Name: index_locations_on_country_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_country_and_name ON public.locations USING btree (country, name);


--
-- Name: index_motor_alert_locks_on_alert_id_and_lock_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_motor_alert_locks_on_alert_id_and_lock_timestamp ON public.motor_alert_locks USING btree (alert_id, lock_timestamp);


--
-- Name: index_motor_alerts_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_alerts_on_author_type_and_author_id ON public.motor_alerts USING btree (author_type, author_id) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_alerts_on_query_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_alerts_on_query_id ON public.motor_alerts USING btree (query_id) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_alerts_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_alerts_on_updated_at ON public.motor_alerts USING btree (updated_at) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_audits_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_audits_on_created_at ON public.motor_audits USING btree (created_at);


--
-- Name: index_motor_audits_on_request_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_audits_on_request_uuid ON public.motor_audits USING btree (request_uuid);


--
-- Name: index_motor_configs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_motor_configs_on_key ON public.motor_configs USING btree (key);


--
-- Name: index_motor_configs_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_configs_on_updated_at ON public.motor_configs USING btree (updated_at);


--
-- Name: index_motor_dashboards_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_dashboards_on_author_type_and_author_id ON public.motor_dashboards USING btree (author_type, author_id) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_dashboards_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_dashboards_on_updated_at ON public.motor_dashboards USING btree (updated_at) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_forms_on_api_config_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_forms_on_api_config_name ON public.motor_forms USING btree (api_config_name) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_forms_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_forms_on_author_type_and_author_id ON public.motor_forms USING btree (author_type, author_id) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_forms_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_forms_on_updated_at ON public.motor_forms USING btree (updated_at) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_queries_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_queries_on_author_type_and_author_id ON public.motor_queries USING btree (author_type, author_id) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_queries_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_queries_on_updated_at ON public.motor_queries USING btree (updated_at) WHERE (deleted_at IS NULL);


--
-- Name: index_motor_resources_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_motor_resources_on_name ON public.motor_resources USING btree (name);


--
-- Name: index_motor_resources_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_resources_on_updated_at ON public.motor_resources USING btree (updated_at);


--
-- Name: index_motor_taggable_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_taggable_tags_on_tag_id ON public.motor_taggable_tags USING btree (tag_id);


--
-- Name: index_new_activations_on_old_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_activations_on_old_user_id ON public.new_activations USING btree (old_user_id);


--
-- Name: index_new_activations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_activations_on_user_id ON public.new_activations USING btree (user_id);


--
-- Name: index_new_activity_points_on_activity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_activity_points_on_activity_type ON public.new_activity_points USING btree (activity_type);


--
-- Name: index_new_activity_points_on_budget_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_activity_points_on_budget_id ON public.new_activity_points USING btree (budget_id);


--
-- Name: index_new_activity_points_on_legacy_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_activity_points_on_legacy_stable_id ON public.new_activity_points USING btree (legacy_stable_id);


--
-- Name: index_new_activity_points_on_old_budget_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_activity_points_on_old_budget_id ON public.new_activity_points USING btree (old_budget_id);


--
-- Name: index_new_activity_points_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_activity_points_on_old_id ON public.new_activity_points USING btree (old_id);


--
-- Name: index_new_activity_points_on_old_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_activity_points_on_old_stable_id ON public.new_activity_points USING btree (old_stable_id);


--
-- Name: index_new_activity_points_on_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_activity_points_on_stable_id ON public.new_activity_points USING btree (stable_id);


--
-- Name: index_new_auction_bids_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_bids_on_auction_id ON public.new_auction_bids USING btree (auction_id);


--
-- Name: index_new_auction_bids_on_bidder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_bids_on_bidder_id ON public.new_auction_bids USING btree (bidder_id);


--
-- Name: index_new_auction_bids_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_bids_on_horse_id ON public.new_auction_bids USING btree (horse_id);


--
-- Name: index_new_auction_bids_on_old_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_bids_on_old_auction_id ON public.new_auction_bids USING btree (old_auction_id);


--
-- Name: index_new_auction_bids_on_old_bidder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_bids_on_old_bidder_id ON public.new_auction_bids USING btree (old_bidder_id);


--
-- Name: index_new_auction_bids_on_old_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_bids_on_old_horse_id ON public.new_auction_bids USING btree (old_horse_id);


--
-- Name: index_new_auction_bids_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_bids_on_old_id ON public.new_auction_bids USING btree (old_id);


--
-- Name: index_new_auction_consignment_configs_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_consignment_configs_on_auction_id ON public.new_auction_consignment_configs USING btree (auction_id);


--
-- Name: index_new_auction_consignment_configs_on_old_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_consignment_configs_on_old_auction_id ON public.new_auction_consignment_configs USING btree (old_auction_id);


--
-- Name: index_new_auction_consignment_configs_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_consignment_configs_on_old_id ON public.new_auction_consignment_configs USING btree (old_id);


--
-- Name: index_new_auction_horses_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_horses_on_auction_id ON public.new_auction_horses USING btree (auction_id);


--
-- Name: index_new_auction_horses_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_horses_on_horse_id ON public.new_auction_horses USING btree (horse_id);


--
-- Name: index_new_auction_horses_on_old_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_horses_on_old_auction_id ON public.new_auction_horses USING btree (old_auction_id);


--
-- Name: index_new_auction_horses_on_old_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_horses_on_old_horse_id ON public.new_auction_horses USING btree (old_horse_id);


--
-- Name: index_new_auction_horses_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_horses_on_old_id ON public.new_auction_horses USING btree (old_id);


--
-- Name: index_new_auction_horses_on_sold_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auction_horses_on_sold_at ON public.new_auction_horses USING btree (sold_at);


--
-- Name: index_new_auctions_on_auctioneer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auctions_on_auctioneer_id ON public.new_auctions USING btree (auctioneer_id);


--
-- Name: index_new_auctions_on_end_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auctions_on_end_time ON public.new_auctions USING btree (end_time);


--
-- Name: index_new_auctions_on_old_auctioneer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auctions_on_old_auctioneer_id ON public.new_auctions USING btree (old_auctioneer_id);


--
-- Name: index_new_auctions_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auctions_on_old_id ON public.new_auctions USING btree (old_id);


--
-- Name: index_new_auctions_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_auctions_on_start_time ON public.new_auctions USING btree (start_time);


--
-- Name: index_new_auctions_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_auctions_on_title ON public.new_auctions USING btree (title);


--
-- Name: index_new_broodmare_foal_records_on_born_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_born_foals_count ON public.new_broodmare_foal_records USING btree (born_foals_count);


--
-- Name: index_new_broodmare_foal_records_on_breed_ranking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_breed_ranking ON public.new_broodmare_foal_records USING btree (breed_ranking);


--
-- Name: index_new_broodmare_foal_records_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_horse_id ON public.new_broodmare_foal_records USING btree (horse_id);


--
-- Name: index_new_broodmare_foal_records_on_millionaire_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_millionaire_foals_count ON public.new_broodmare_foal_records USING btree (millionaire_foals_count);


--
-- Name: index_new_broodmare_foal_records_on_old_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_old_horse_id ON public.new_broodmare_foal_records USING btree (old_horse_id);


--
-- Name: index_new_broodmare_foal_records_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_old_id ON public.new_broodmare_foal_records USING btree (old_id);


--
-- Name: index_new_broodmare_foal_records_on_raced_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_raced_foals_count ON public.new_broodmare_foal_records USING btree (raced_foals_count);


--
-- Name: index_new_broodmare_foal_records_on_stakes_winning_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_stakes_winning_foals_count ON public.new_broodmare_foal_records USING btree (stakes_winning_foals_count);


--
-- Name: index_new_broodmare_foal_records_on_stillborn_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_stillborn_foals_count ON public.new_broodmare_foal_records USING btree (stillborn_foals_count);


--
-- Name: index_new_broodmare_foal_records_on_total_foal_points; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_total_foal_points ON public.new_broodmare_foal_records USING btree (total_foal_points);


--
-- Name: index_new_broodmare_foal_records_on_total_foal_races; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_total_foal_races ON public.new_broodmare_foal_records USING btree (total_foal_races);


--
-- Name: index_new_broodmare_foal_records_on_unborn_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_unborn_foals_count ON public.new_broodmare_foal_records USING btree (unborn_foals_count);


--
-- Name: index_new_broodmare_foal_records_on_winning_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_broodmare_foal_records_on_winning_foals_count ON public.new_broodmare_foal_records USING btree (winning_foals_count);


--
-- Name: index_new_budget_transactions_on_activity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_budget_transactions_on_activity_type ON public.new_budget_transactions USING btree (activity_type);


--
-- Name: index_new_budget_transactions_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_budget_transactions_on_description ON public.new_budget_transactions USING btree (description);


--
-- Name: index_new_budget_transactions_on_legacy_budget_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_budget_transactions_on_legacy_budget_id ON public.new_budget_transactions USING btree (legacy_budget_id);


--
-- Name: index_new_budget_transactions_on_legacy_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_budget_transactions_on_legacy_stable_id ON public.new_budget_transactions USING btree (legacy_stable_id);


--
-- Name: index_new_budget_transactions_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_budget_transactions_on_old_id ON public.new_budget_transactions USING btree (old_id);


--
-- Name: index_new_budget_transactions_on_old_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_budget_transactions_on_old_stable_id ON public.new_budget_transactions USING btree (old_stable_id);


--
-- Name: index_new_budget_transactions_on_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_budget_transactions_on_stable_id ON public.new_budget_transactions USING btree (stable_id);


--
-- Name: index_new_game_activity_points_on_activity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_game_activity_points_on_activity_type ON public.new_game_activity_points USING btree (activity_type);


--
-- Name: index_new_game_activity_points_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_game_activity_points_on_old_id ON public.new_game_activity_points USING btree (old_id);


--
-- Name: index_new_game_alerts_on_display_to_newbies; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_game_alerts_on_display_to_newbies ON public.new_game_alerts USING btree (display_to_newbies);


--
-- Name: index_new_game_alerts_on_display_to_non_newbies; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_game_alerts_on_display_to_non_newbies ON public.new_game_alerts USING btree (display_to_non_newbies);


--
-- Name: index_new_game_alerts_on_end_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_game_alerts_on_end_time ON public.new_game_alerts USING btree (end_time);


--
-- Name: index_new_game_alerts_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_game_alerts_on_old_id ON public.new_game_alerts USING btree (old_id);


--
-- Name: index_new_game_alerts_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_game_alerts_on_start_time ON public.new_game_alerts USING btree (start_time);


--
-- Name: index_new_horse_appearances_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horse_appearances_on_horse_id ON public.new_horse_appearances USING btree (horse_id);


--
-- Name: index_new_horse_appearances_on_old_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horse_appearances_on_old_horse_id ON public.new_horse_appearances USING btree (old_horse_id);


--
-- Name: index_new_horse_appearances_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horse_appearances_on_old_id ON public.new_horse_appearances USING btree (old_id);


--
-- Name: index_new_horse_attributes_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horse_attributes_on_horse_id ON public.new_horse_attributes USING btree (horse_id);


--
-- Name: index_new_horse_attributes_on_old_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horse_attributes_on_old_horse_id ON public.new_horse_attributes USING btree (old_horse_id);


--
-- Name: index_new_horse_attributes_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horse_attributes_on_old_id ON public.new_horse_attributes USING btree (old_id);


--
-- Name: index_new_horse_genetics_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horse_genetics_on_horse_id ON public.new_horse_genetics USING btree (horse_id);


--
-- Name: index_new_horse_genetics_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horse_genetics_on_old_id ON public.new_horse_genetics USING btree (old_id);


--
-- Name: index_new_horses_on_age; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_age ON public.new_horses USING btree (age);


--
-- Name: index_new_horses_on_breeder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_breeder_id ON public.new_horses USING btree (breeder_id);


--
-- Name: index_new_horses_on_dam_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_dam_id ON public.new_horses USING btree (dam_id);


--
-- Name: index_new_horses_on_date_of_birth; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_date_of_birth ON public.new_horses USING btree (date_of_birth);


--
-- Name: index_new_horses_on_date_of_death; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_date_of_death ON public.new_horses USING btree (date_of_death);


--
-- Name: index_new_horses_on_gender; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_gender ON public.new_horses USING btree (gender);


--
-- Name: index_new_horses_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_legacy_id ON public.new_horses USING btree (legacy_id);


--
-- Name: index_new_horses_on_location_bred_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_location_bred_id ON public.new_horses USING btree (location_bred_id);


--
-- Name: index_new_horses_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_name ON public.new_horses USING btree (name);


--
-- Name: index_new_horses_on_old_breeder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_old_breeder_id ON public.new_horses USING btree (old_breeder_id);


--
-- Name: index_new_horses_on_old_dam_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_old_dam_id ON public.new_horses USING btree (old_dam_id);


--
-- Name: index_new_horses_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_old_id ON public.new_horses USING btree (old_id);


--
-- Name: index_new_horses_on_old_location_bred_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_old_location_bred_id ON public.new_horses USING btree (old_location_bred_id);


--
-- Name: index_new_horses_on_old_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_old_owner_id ON public.new_horses USING btree (old_owner_id);


--
-- Name: index_new_horses_on_old_sire_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_old_sire_id ON public.new_horses USING btree (old_sire_id);


--
-- Name: index_new_horses_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_owner_id ON public.new_horses USING btree (owner_id);


--
-- Name: index_new_horses_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_public_id ON public.new_horses USING btree (public_id);


--
-- Name: index_new_horses_on_sire_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_sire_id ON public.new_horses USING btree (sire_id);


--
-- Name: index_new_horses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_slug ON public.new_horses USING btree (slug);


--
-- Name: index_new_horses_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_horses_on_status ON public.new_horses USING btree (status);


--
-- Name: index_new_jockeys_on_date_of_birth; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_date_of_birth ON public.new_jockeys USING btree (date_of_birth);


--
-- Name: index_new_jockeys_on_first_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_first_name ON public.new_jockeys USING btree (first_name);


--
-- Name: index_new_jockeys_on_gender; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_gender ON public.new_jockeys USING btree (gender);


--
-- Name: index_new_jockeys_on_height_in_inches; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_height_in_inches ON public.new_jockeys USING btree (height_in_inches);


--
-- Name: index_new_jockeys_on_jockey_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_jockey_type ON public.new_jockeys USING btree (jockey_type);


--
-- Name: index_new_jockeys_on_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_last_name ON public.new_jockeys USING btree (last_name);


--
-- Name: index_new_jockeys_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_legacy_id ON public.new_jockeys USING btree (legacy_id);


--
-- Name: index_new_jockeys_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_old_id ON public.new_jockeys USING btree (old_id);


--
-- Name: index_new_jockeys_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_public_id ON public.new_jockeys USING btree (public_id);


--
-- Name: index_new_jockeys_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_slug ON public.new_jockeys USING btree (slug);


--
-- Name: index_new_jockeys_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_status ON public.new_jockeys USING btree (status);


--
-- Name: index_new_jockeys_on_weight; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_jockeys_on_weight ON public.new_jockeys USING btree (weight);


--
-- Name: index_new_locations_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_locations_on_name ON public.new_locations USING btree (name);


--
-- Name: index_new_locations_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_locations_on_old_id ON public.new_locations USING btree (old_id);


--
-- Name: index_new_race_odds_on_display; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_odds_on_display ON public.new_race_odds USING btree (display);


--
-- Name: index_new_race_odds_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_odds_on_old_id ON public.new_race_odds USING btree (old_id);


--
-- Name: index_new_race_records_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_horse_id ON public.new_race_records USING btree (horse_id);


--
-- Name: index_new_race_records_on_old_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_old_horse_id ON public.new_race_records USING btree (old_horse_id);


--
-- Name: index_new_race_records_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_old_id ON public.new_race_records USING btree (old_id);


--
-- Name: index_new_race_records_on_result_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_result_type ON public.new_race_records USING btree (result_type);


--
-- Name: index_new_race_records_on_stakes_starts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_stakes_starts ON public.new_race_records USING btree (stakes_starts);


--
-- Name: index_new_race_records_on_stakes_wins; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_stakes_wins ON public.new_race_records USING btree (stakes_wins);


--
-- Name: index_new_race_records_on_starts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_starts ON public.new_race_records USING btree (starts);


--
-- Name: index_new_race_records_on_wins; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_wins ON public.new_race_records USING btree (wins);


--
-- Name: index_new_race_records_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_records_on_year ON public.new_race_records USING btree (year);


--
-- Name: index_new_race_result_horses_on_finish_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_finish_position ON public.new_race_result_horses USING btree (finish_position);


--
-- Name: index_new_race_result_horses_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_horse_id ON public.new_race_result_horses USING btree (horse_id);


--
-- Name: index_new_race_result_horses_on_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_jockey_id ON public.new_race_result_horses USING btree (jockey_id);


--
-- Name: index_new_race_result_horses_on_legacy_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_legacy_horse_id ON public.new_race_result_horses USING btree (legacy_horse_id);


--
-- Name: index_new_race_result_horses_on_old_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_old_horse_id ON public.new_race_result_horses USING btree (old_horse_id);


--
-- Name: index_new_race_result_horses_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_old_id ON public.new_race_result_horses USING btree (old_id);


--
-- Name: index_new_race_result_horses_on_old_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_old_jockey_id ON public.new_race_result_horses USING btree (old_jockey_id);


--
-- Name: index_new_race_result_horses_on_old_odd_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_old_odd_id ON public.new_race_result_horses USING btree (old_odd_id);


--
-- Name: index_new_race_result_horses_on_old_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_old_race_id ON public.new_race_result_horses USING btree (old_race_id);


--
-- Name: index_new_race_result_horses_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_race_id ON public.new_race_result_horses USING btree (race_id);


--
-- Name: index_new_race_result_horses_on_speed_factor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_result_horses_on_speed_factor ON public.new_race_result_horses USING btree (speed_factor);


--
-- Name: index_new_race_results_on_age; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_age ON public.new_race_results USING btree (age);


--
-- Name: index_new_race_results_on_condition; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_condition ON public.new_race_results USING btree (condition);


--
-- Name: index_new_race_results_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_date ON public.new_race_results USING btree (date);


--
-- Name: index_new_race_results_on_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_distance ON public.new_race_results USING btree (distance);


--
-- Name: index_new_race_results_on_grade; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_grade ON public.new_race_results USING btree (grade);


--
-- Name: index_new_race_results_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_name ON public.new_race_results USING btree (name);


--
-- Name: index_new_race_results_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_number ON public.new_race_results USING btree (number);


--
-- Name: index_new_race_results_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_old_id ON public.new_race_results USING btree (old_id);


--
-- Name: index_new_race_results_on_old_surface_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_old_surface_id ON public.new_race_results USING btree (old_surface_id);


--
-- Name: index_new_race_results_on_purse; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_purse ON public.new_race_results USING btree (purse);


--
-- Name: index_new_race_results_on_race_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_race_type ON public.new_race_results USING btree (race_type);


--
-- Name: index_new_race_results_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_slug ON public.new_race_results USING btree (slug);


--
-- Name: index_new_race_results_on_surface_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_surface_id ON public.new_race_results USING btree (surface_id);


--
-- Name: index_new_race_results_on_time_in_seconds; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_results_on_time_in_seconds ON public.new_race_results USING btree (time_in_seconds);


--
-- Name: index_new_race_schedules_on_age; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_age ON public.new_race_schedules USING btree (age);


--
-- Name: index_new_race_schedules_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_date ON public.new_race_schedules USING btree (date);


--
-- Name: index_new_race_schedules_on_day_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_day_number ON public.new_race_schedules USING btree (day_number);


--
-- Name: index_new_race_schedules_on_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_distance ON public.new_race_schedules USING btree (distance);


--
-- Name: index_new_race_schedules_on_female_only; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_female_only ON public.new_race_schedules USING btree (female_only);


--
-- Name: index_new_race_schedules_on_grade; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_grade ON public.new_race_schedules USING btree (grade);


--
-- Name: index_new_race_schedules_on_male_only; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_male_only ON public.new_race_schedules USING btree (male_only);


--
-- Name: index_new_race_schedules_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_name ON public.new_race_schedules USING btree (name);


--
-- Name: index_new_race_schedules_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_number ON public.new_race_schedules USING btree (number);


--
-- Name: index_new_race_schedules_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_old_id ON public.new_race_schedules USING btree (old_id);


--
-- Name: index_new_race_schedules_on_old_surface_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_old_surface_id ON public.new_race_schedules USING btree (old_surface_id);


--
-- Name: index_new_race_schedules_on_qualification_required; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_qualification_required ON public.new_race_schedules USING btree (qualification_required);


--
-- Name: index_new_race_schedules_on_race_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_race_type ON public.new_race_schedules USING btree (race_type);


--
-- Name: index_new_race_schedules_on_surface_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_race_schedules_on_surface_id ON public.new_race_schedules USING btree (surface_id);


--
-- Name: index_new_racetracks_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_racetracks_on_location_id ON public.new_racetracks USING btree (location_id);


--
-- Name: index_new_racetracks_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_racetracks_on_name ON public.new_racetracks USING btree (name);


--
-- Name: index_new_racetracks_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_racetracks_on_old_id ON public.new_racetracks USING btree (old_id);


--
-- Name: index_new_racetracks_on_old_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_racetracks_on_old_location_id ON public.new_racetracks USING btree (old_location_id);


--
-- Name: index_new_racetracks_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_racetracks_on_public_id ON public.new_racetracks USING btree (public_id);


--
-- Name: index_new_racetracks_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_racetracks_on_slug ON public.new_racetracks USING btree (slug);


--
-- Name: index_new_sessions_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_sessions_on_old_id ON public.new_sessions USING btree (old_id);


--
-- Name: index_new_sessions_on_old_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_sessions_on_old_user_id ON public.new_sessions USING btree (old_user_id);


--
-- Name: index_new_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_sessions_on_session_id ON public.new_sessions USING btree (session_id);


--
-- Name: index_new_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_sessions_on_user_id ON public.new_sessions USING btree (user_id);


--
-- Name: index_new_settings_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_settings_on_old_id ON public.new_settings USING btree (old_id);


--
-- Name: index_new_settings_on_old_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_settings_on_old_user_id ON public.new_settings USING btree (old_user_id);


--
-- Name: index_new_settings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_settings_on_user_id ON public.new_settings USING btree (user_id);


--
-- Name: index_new_stables_on_available_balance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_available_balance ON public.new_stables USING btree (available_balance);


--
-- Name: index_new_stables_on_last_online_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_last_online_at ON public.new_stables USING btree (last_online_at);


--
-- Name: index_new_stables_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_legacy_id ON public.new_stables USING btree (legacy_id);


--
-- Name: index_new_stables_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_stables_on_name ON public.new_stables USING btree (name);


--
-- Name: index_new_stables_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_old_id ON public.new_stables USING btree (old_id);


--
-- Name: index_new_stables_on_old_racetrack_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_old_racetrack_id ON public.new_stables USING btree (old_racetrack_id);


--
-- Name: index_new_stables_on_old_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_old_user_id ON public.new_stables USING btree (old_user_id);


--
-- Name: index_new_stables_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_public_id ON public.new_stables USING btree (public_id);


--
-- Name: index_new_stables_on_racetrack_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_racetrack_id ON public.new_stables USING btree (racetrack_id);


--
-- Name: index_new_stables_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_slug ON public.new_stables USING btree (slug);


--
-- Name: index_new_stables_on_total_balance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_total_balance ON public.new_stables USING btree (total_balance);


--
-- Name: index_new_stables_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_stables_on_user_id ON public.new_stables USING btree (user_id);


--
-- Name: index_new_track_surfaces_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_track_surfaces_on_old_id ON public.new_track_surfaces USING btree (old_id);


--
-- Name: index_new_track_surfaces_on_old_racetrack_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_track_surfaces_on_old_racetrack_id ON public.new_track_surfaces USING btree (old_racetrack_id);


--
-- Name: index_new_track_surfaces_on_racetrack_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_track_surfaces_on_racetrack_id ON public.new_track_surfaces USING btree (racetrack_id);


--
-- Name: index_new_training_schedules_horses_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_horses_on_horse_id ON public.new_training_schedules_horses USING btree (horse_id);


--
-- Name: index_new_training_schedules_horses_on_old_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_horses_on_old_horse_id ON public.new_training_schedules_horses USING btree (old_horse_id);


--
-- Name: index_new_training_schedules_horses_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_horses_on_old_id ON public.new_training_schedules_horses USING btree (old_id);


--
-- Name: index_new_training_schedules_horses_on_training_schedule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_horses_on_training_schedule_id ON public.new_training_schedules_horses USING btree (training_schedule_id);


--
-- Name: index_new_training_schedules_on_friday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_friday_activities ON public.new_training_schedules USING btree (friday_activities);


--
-- Name: index_new_training_schedules_on_horses_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_horses_count ON public.new_training_schedules USING btree (horses_count);


--
-- Name: index_new_training_schedules_on_monday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_monday_activities ON public.new_training_schedules USING btree (monday_activities);


--
-- Name: index_new_training_schedules_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_old_id ON public.new_training_schedules USING btree (old_id);


--
-- Name: index_new_training_schedules_on_old_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_old_stable_id ON public.new_training_schedules USING btree (old_stable_id);


--
-- Name: index_new_training_schedules_on_saturday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_saturday_activities ON public.new_training_schedules USING btree (saturday_activities);


--
-- Name: index_new_training_schedules_on_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_stable_id ON public.new_training_schedules USING btree (stable_id);


--
-- Name: index_new_training_schedules_on_sunday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_sunday_activities ON public.new_training_schedules USING btree (sunday_activities);


--
-- Name: index_new_training_schedules_on_thursday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_thursday_activities ON public.new_training_schedules USING btree (thursday_activities);


--
-- Name: index_new_training_schedules_on_tuesday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_tuesday_activities ON public.new_training_schedules USING btree (tuesday_activities);


--
-- Name: index_new_training_schedules_on_wednesday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_training_schedules_on_wednesday_activities ON public.new_training_schedules USING btree (wednesday_activities);


--
-- Name: index_new_user_push_subscriptions_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_user_push_subscriptions_on_old_id ON public.new_user_push_subscriptions USING btree (old_id);


--
-- Name: index_new_user_push_subscriptions_on_old_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_user_push_subscriptions_on_old_user_id ON public.new_user_push_subscriptions USING btree (old_user_id);


--
-- Name: index_new_user_push_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_user_push_subscriptions_on_user_id ON public.new_user_push_subscriptions USING btree (user_id);


--
-- Name: index_new_users_on_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_users_on_admin ON public.new_users USING btree (admin) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_new_users_on_developer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_users_on_developer ON public.new_users USING btree (developer) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_new_users_on_discourse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_users_on_discourse_id ON public.new_users USING btree (discourse_id) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_new_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_users_on_email ON public.new_users USING btree (email) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_new_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_users_on_name ON public.new_users USING btree (name) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_new_users_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_new_users_on_old_id ON public.new_users USING btree (old_id);


--
-- Name: index_new_users_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_users_on_public_id ON public.new_users USING btree (public_id) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_new_users_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_users_on_slug ON public.new_users USING btree (slug) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_new_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_new_users_on_username ON public.new_users USING btree (username) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_race_records_on_horse_id_and_year_and_result_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_race_records_on_horse_id_and_year_and_result_type ON public.race_records USING btree (horse_id, year, result_type);


--
-- Name: index_race_records_on_result_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_records_on_result_type ON public.race_records USING btree (result_type);


--
-- Name: index_race_records_on_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_records_on_year ON public.race_records USING btree (year);


--
-- Name: index_race_result_horses_on_finish_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_result_horses_on_finish_position ON public.race_result_horses USING btree (finish_position);


--
-- Name: index_race_result_horses_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_result_horses_on_horse_id ON public.race_result_horses USING btree (horse_id);


--
-- Name: index_race_result_horses_on_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_result_horses_on_jockey_id ON public.race_result_horses USING btree (jockey_id);


--
-- Name: index_race_result_horses_on_legacy_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_result_horses_on_legacy_horse_id ON public.race_result_horses USING btree (legacy_horse_id);


--
-- Name: index_race_result_horses_on_odd_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_result_horses_on_odd_id ON public.race_result_horses USING btree (odd_id);


--
-- Name: index_race_result_horses_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_result_horses_on_race_id ON public.race_result_horses USING btree (race_id);


--
-- Name: index_race_result_horses_on_speed_factor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_result_horses_on_speed_factor ON public.race_result_horses USING btree (speed_factor);


--
-- Name: index_race_results_on_age; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_age ON public.race_results USING btree (age);


--
-- Name: index_race_results_on_condition; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_condition ON public.race_results USING btree (condition);


--
-- Name: index_race_results_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_date ON public.race_results USING btree (date);


--
-- Name: index_race_results_on_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_distance ON public.race_results USING btree (distance);


--
-- Name: index_race_results_on_female_only; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_female_only ON public.race_results USING btree (female_only);


--
-- Name: index_race_results_on_grade; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_grade ON public.race_results USING btree (grade);


--
-- Name: index_race_results_on_male_only; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_male_only ON public.race_results USING btree (male_only);


--
-- Name: index_race_results_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_name ON public.race_results USING btree (name);


--
-- Name: index_race_results_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_number ON public.race_results USING btree (number);


--
-- Name: index_race_results_on_purse; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_purse ON public.race_results USING btree (purse);


--
-- Name: index_race_results_on_race_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_race_type ON public.race_results USING btree (race_type);


--
-- Name: index_race_results_on_surface_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_surface_id ON public.race_results USING btree (surface_id);


--
-- Name: index_race_results_on_time_in_seconds; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_time_in_seconds ON public.race_results USING btree (time_in_seconds);


--
-- Name: index_race_schedules_on_age; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_age ON public.race_schedules USING btree (age);


--
-- Name: index_race_schedules_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_date ON public.race_schedules USING btree (date);


--
-- Name: index_race_schedules_on_day_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_day_number ON public.race_schedules USING btree (day_number);


--
-- Name: index_race_schedules_on_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_distance ON public.race_schedules USING btree (distance);


--
-- Name: index_race_schedules_on_female_only; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_female_only ON public.race_schedules USING btree (female_only);


--
-- Name: index_race_schedules_on_grade; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_grade ON public.race_schedules USING btree (grade);


--
-- Name: index_race_schedules_on_male_only; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_male_only ON public.race_schedules USING btree (male_only);


--
-- Name: index_race_schedules_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_name ON public.race_schedules USING btree (name);


--
-- Name: index_race_schedules_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_number ON public.race_schedules USING btree (number);


--
-- Name: index_race_schedules_on_purse; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_purse ON public.race_schedules USING btree (purse);


--
-- Name: index_race_schedules_on_qualification_required; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_qualification_required ON public.race_schedules USING btree (qualification_required);


--
-- Name: index_race_schedules_on_race_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_race_type ON public.race_schedules USING btree (race_type);


--
-- Name: index_race_schedules_on_surface_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_schedules_on_surface_id ON public.race_schedules USING btree (surface_id);


--
-- Name: index_racetracks_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racetracks_on_created_at ON public.racetracks USING btree (created_at);


--
-- Name: index_racetracks_on_latitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racetracks_on_latitude ON public.racetracks USING btree (latitude);


--
-- Name: index_racetracks_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racetracks_on_location_id ON public.racetracks USING btree (location_id);


--
-- Name: index_racetracks_on_longitude; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racetracks_on_longitude ON public.racetracks USING btree (longitude);


--
-- Name: index_racetracks_on_lowercase_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_racetracks_on_lowercase_name ON public.racetracks USING btree (lower((name)::text));


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON public.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON public.sessions USING btree (updated_at);


--
-- Name: index_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_user_id ON public.sessions USING btree (user_id);


--
-- Name: index_settings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_settings_on_user_id ON public.settings USING btree (user_id);


--
-- Name: index_stables_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_created_at ON public.stables USING btree (created_at);


--
-- Name: index_stables_on_last_online_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_last_online_at ON public.stables USING btree (last_online_at);


--
-- Name: index_stables_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_legacy_id ON public.stables USING btree (legacy_id);


--
-- Name: index_stables_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_stables_on_name ON public.stables USING btree (lower((name)::text));


--
-- Name: index_stables_on_racetrack_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_racetrack_id ON public.stables USING btree (racetrack_id);


--
-- Name: index_stables_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_stables_on_user_id ON public.stables USING btree (user_id);


--
-- Name: index_track_surfaces_on_racetrack_id_and_surface; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_track_surfaces_on_racetrack_id_and_surface ON public.track_surfaces USING btree (racetrack_id, surface);


--
-- Name: index_training_schedules_horses_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_training_schedules_horses_on_horse_id ON public.training_schedules_horses USING btree (horse_id);


--
-- Name: index_training_schedules_horses_on_training_schedule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_horses_on_training_schedule_id ON public.training_schedules_horses USING btree (training_schedule_id);


--
-- Name: index_training_schedules_on_friday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_on_friday_activities ON public.training_schedules USING gin (friday_activities);


--
-- Name: index_training_schedules_on_lowercase_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_training_schedules_on_lowercase_name ON public.training_schedules USING btree (stable_id, lower((name)::text));


--
-- Name: index_training_schedules_on_monday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_on_monday_activities ON public.training_schedules USING gin (monday_activities);


--
-- Name: index_training_schedules_on_saturday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_on_saturday_activities ON public.training_schedules USING gin (saturday_activities);


--
-- Name: index_training_schedules_on_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_on_stable_id ON public.training_schedules USING btree (stable_id);


--
-- Name: index_training_schedules_on_sunday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_on_sunday_activities ON public.training_schedules USING gin (sunday_activities);


--
-- Name: index_training_schedules_on_thursday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_on_thursday_activities ON public.training_schedules USING gin (thursday_activities);


--
-- Name: index_training_schedules_on_tuesday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_on_tuesday_activities ON public.training_schedules USING gin (tuesday_activities);


--
-- Name: index_training_schedules_on_wednesday_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_training_schedules_on_wednesday_activities ON public.training_schedules USING gin (wednesday_activities);


--
-- Name: index_user_push_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_push_subscriptions_on_user_id ON public.user_push_subscriptions USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_created_at ON public.users USING btree (created_at) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_developer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_developer ON public.users USING btree (developer) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_discarded_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_discarded_at ON public.users USING btree (discarded_at) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_discourse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_discourse_id ON public.users USING btree (discourse_id) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_lowercase_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_lowercase_username ON public.users USING btree (lower((username)::text)) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_slug ON public.users USING btree (slug) WHERE (discarded_at IS NULL);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token) WHERE (discarded_at IS NULL);


--
-- Name: motor_alerts_name_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX motor_alerts_name_unique_index ON public.motor_alerts USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: motor_api_configs_name_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX motor_api_configs_name_unique_index ON public.motor_api_configs USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: motor_auditable_associated_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX motor_auditable_associated_index ON public.motor_audits USING btree (associated_type, associated_id);


--
-- Name: motor_auditable_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX motor_auditable_index ON public.motor_audits USING btree (auditable_type, auditable_id, version);


--
-- Name: motor_auditable_user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX motor_auditable_user_index ON public.motor_audits USING btree (user_id, user_type);


--
-- Name: motor_dashboards_title_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX motor_dashboards_title_unique_index ON public.motor_dashboards USING btree (title) WHERE (deleted_at IS NULL);


--
-- Name: motor_forms_name_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX motor_forms_name_unique_index ON public.motor_forms USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: motor_polymorphic_association_tag_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX motor_polymorphic_association_tag_index ON public.motor_taggable_tags USING btree (taggable_id, taggable_type, tag_id);


--
-- Name: motor_queries_name_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX motor_queries_name_unique_index ON public.motor_queries USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: motor_tags_name_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX motor_tags_name_unique_index ON public.motor_tags USING btree (name);


--
-- Name: race_results fk_rails_06818a8fab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_results
    ADD CONSTRAINT fk_rails_06818a8fab FOREIGN KEY (surface_id) REFERENCES public.track_surfaces(id);


--
-- Name: race_schedules fk_rails_0831641203; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_schedules
    ADD CONSTRAINT fk_rails_0831641203 FOREIGN KEY (surface_id) REFERENCES public.track_surfaces(id);


--
-- Name: auction_horses fk_rails_0ff758e7f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_horses
    ADD CONSTRAINT fk_rails_0ff758e7f8 FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: horse_genetics fk_rails_10e493203b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_genetics
    ADD CONSTRAINT fk_rails_10e493203b FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: race_result_horses fk_rails_1fdef5dc32; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT fk_rails_1fdef5dc32 FOREIGN KEY (race_id) REFERENCES public.race_results(id);


--
-- Name: user_push_subscriptions fk_rails_2762779401; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_push_subscriptions
    ADD CONSTRAINT fk_rails_2762779401 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: auction_consignment_configs fk_rails_2d96c0c08a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_consignment_configs
    ADD CONSTRAINT fk_rails_2d96c0c08a FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: stables fk_rails_337ce4ea4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stables
    ADD CONSTRAINT fk_rails_337ce4ea4d FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: motor_alert_locks fk_rails_38d1b2960e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_alert_locks
    ADD CONSTRAINT fk_rails_38d1b2960e FOREIGN KEY (alert_id) REFERENCES public.motor_alerts(id);


--
-- Name: settings fk_rails_5676777bf1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT fk_rails_5676777bf1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: training_schedules_horses fk_rails_5699b9eba5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules_horses
    ADD CONSTRAINT fk_rails_5699b9eba5 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: race_result_horses fk_rails_5a43ac707f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT fk_rails_5a43ac707f FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: auction_horses fk_rails_68ba859655; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_horses
    ADD CONSTRAINT fk_rails_68ba859655 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: stables fk_rails_6c0fff5a3e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stables
    ADD CONSTRAINT fk_rails_6c0fff5a3e FOREIGN KEY (racetrack_id) REFERENCES public.racetracks(id);


--
-- Name: racetracks fk_rails_7135862009; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racetracks
    ADD CONSTRAINT fk_rails_7135862009 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: race_result_horses fk_rails_7254168319; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT fk_rails_7254168319 FOREIGN KEY (odd_id) REFERENCES public.race_odds(id);


--
-- Name: motor_alerts fk_rails_8828951644; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_alerts
    ADD CONSTRAINT fk_rails_8828951644 FOREIGN KEY (query_id) REFERENCES public.motor_queries(id);


--
-- Name: track_surfaces fk_rails_8a3fdd3bd1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_surfaces
    ADD CONSTRAINT fk_rails_8a3fdd3bd1 FOREIGN KEY (racetrack_id) REFERENCES public.racetracks(id);


--
-- Name: horses fk_rails_99146e7c92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_99146e7c92 FOREIGN KEY (owner_id) REFERENCES public.stables(id);


--
-- Name: activity_points fk_rails_9921842c69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_points
    ADD CONSTRAINT fk_rails_9921842c69 FOREIGN KEY (budget_id) REFERENCES public.budgets(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: activity_points fk_rails_a3b05b12f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_points
    ADD CONSTRAINT fk_rails_a3b05b12f2 FOREIGN KEY (stable_id) REFERENCES public.stables(id);


--
-- Name: budgets fk_rails_a43f3d3880; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT fk_rails_a43f3d3880 FOREIGN KEY (stable_id) REFERENCES public.stables(id);


--
-- Name: training_schedules_horses fk_rails_a48e7af8f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules_horses
    ADD CONSTRAINT fk_rails_a48e7af8f9 FOREIGN KEY (training_schedule_id) REFERENCES public.training_schedules(id);


--
-- Name: auction_bids fk_rails_a66160d8e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_bids
    ADD CONSTRAINT fk_rails_a66160d8e4 FOREIGN KEY (auction_id) REFERENCES public.auctions(id);


--
-- Name: horse_attributes fk_rails_a783c29acc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_attributes
    ADD CONSTRAINT fk_rails_a783c29acc FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: auction_bids fk_rails_ad9350f9f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_bids
    ADD CONSTRAINT fk_rails_ad9350f9f6 FOREIGN KEY (bidder_id) REFERENCES public.stables(id);


--
-- Name: horses fk_rails_b1757e50ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_b1757e50ec FOREIGN KEY (breeder_id) REFERENCES public.stables(id);


--
-- Name: motor_taggable_tags fk_rails_ba9ebe2280; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_taggable_tags
    ADD CONSTRAINT fk_rails_ba9ebe2280 FOREIGN KEY (tag_id) REFERENCES public.motor_tags(id);


--
-- Name: race_records fk_rails_c25fca6795; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_records
    ADD CONSTRAINT fk_rails_c25fca6795 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: training_schedules fk_rails_c52806e045; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules
    ADD CONSTRAINT fk_rails_c52806e045 FOREIGN KEY (stable_id) REFERENCES public.stables(id);


--
-- Name: auction_bids fk_rails_c7783844e2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_bids
    ADD CONSTRAINT fk_rails_c7783844e2 FOREIGN KEY (horse_id) REFERENCES public.auction_horses(id);


--
-- Name: activations fk_rails_c968676a56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT fk_rails_c968676a56 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: horses fk_rails_d484f5dff4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_d484f5dff4 FOREIGN KEY (sire_id) REFERENCES public.horses(id);


--
-- Name: horses fk_rails_e50f0d1f41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_e50f0d1f41 FOREIGN KEY (location_bred_id) REFERENCES public.locations(id);


--
-- Name: auctions fk_rails_eb22f53e21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auctions
    ADD CONSTRAINT fk_rails_eb22f53e21 FOREIGN KEY (auctioneer_id) REFERENCES public.stables(id);


--
-- Name: horse_appearances fk_rails_edfc2b0987; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_appearances
    ADD CONSTRAINT fk_rails_edfc2b0987 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: broodmare_foal_records fk_rails_f03f5afd0c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_foal_records
    ADD CONSTRAINT fk_rails_f03f5afd0c FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: race_result_horses fk_rails_f05befc048; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT fk_rails_f05befc048 FOREIGN KEY (jockey_id) REFERENCES public.jockeys(id);


--
-- Name: horses fk_rails_fc5ea1ce34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_fc5ea1ce34 FOREIGN KEY (dam_id) REFERENCES public.horses(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20251101223740'),
('20251101200403'),
('20251031160653'),
('20251030225629'),
('20251030195925'),
('20251030135303'),
('20251030120315'),
('20251029202531'),
('20251029201112'),
('20251029190419'),
('20251029180307'),
('20251029151606'),
('20251028190559'),
('20251028114109'),
('20251022194854'),
('20251022133524'),
('20251022112251'),
('20251017161018'),
('20251017125321'),
('20251017114946'),
('20251017084750'),
('20251013155516'),
('20251012155939'),
('20251012133537'),
('20251012093408'),
('20251012091923'),
('20251011175308'),
('20251011134245'),
('20251011103916'),
('20251008210419'),
('20251008184823'),
('20251007163508'),
('20251005120538'),
('20251004194127'),
('20251004173409'),
('20250925184704'),
('20250925183807'),
('20250923114259'),
('20250923111108'),
('20250921162540'),
('20250921162539'),
('20250921162538'),
('20250915164511'),
('20240406120656'),
('20240403140532'),
('20240403120623'),
('20230924132918'),
('20230911184526'),
('20230807135058'),
('20230806122728'),
('20230804160856'),
('20220814180246'),
('20220812155732'),
('20220812140110'),
('20220811154600'),
('20220811150618'),
('20220803170759'),
('20220731171155'),
('20220730191849'),
('20220730102044'),
('20220723081447'),
('20220722210749'),
('20220722202326'),
('20220722201433'),
('20220722200044'),
('20220722173334'),
('20220717190341'),
('20220717121209'),
('20220717024945'),
('20220716131503'),
('20220619171138'),
('20220619160549'),
('20220502150518'),
('20220502093637'),
('20220426211810'),
('20220403152231');

