SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


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
-- Name: injury_types; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.injury_types AS ENUM (
    'heat',
    'swelling',
    'cut',
    'limping',
    'overheat',
    'bowed tendon',
    'broken leg',
    'heart attack'
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
-- Name: legs; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.legs AS ENUM (
    'LF',
    'RF',
    'LH',
    'RH'
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
-- Name: racehorse_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.racehorse_type AS ENUM (
    'flat',
    'jump'
);


--
-- Name: racing_style; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.racing_style AS ENUM (
    'leading',
    'off_pace',
    'midpack',
    'closing'
);


--
-- Name: shipping_mode; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.shipping_mode AS ENUM (
    'road',
    'air'
);


--
-- Name: shipping_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.shipping_type AS ENUM (
    'track_to_track',
    'farm_to_track',
    'track_to_farm'
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


--
-- Name: workout_activities; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.workout_activities AS ENUM (
    'walk',
    'jog',
    'canter',
    'gallop',
    'breeze'
);


--
-- Name: workout_stats; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.workout_stats AS ENUM (
    'bolt',
    'confidence',
    'cooperate',
    'dump',
    'energy',
    'equipment',
    'fight',
    'fitness',
    'happy',
    'jumps',
    'natural_energy',
    'pissy',
    'ratability',
    'spook',
    'stamina',
    'style',
    'weight',
    'xp'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activations (
    id bigint NOT NULL,
    activated_at timestamp with time zone,
    token character varying NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
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
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
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
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
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
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    blob_id uuid NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: activity_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_points (
    id bigint NOT NULL,
    activity_type public.activity_type NOT NULL,
    amount integer DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    budget_id bigint,
    legacy_stable_id integer DEFAULT 0 NOT NULL,
    stable_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN activity_points.activity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.activity_points.activity_type IS 'color_war, auction, selling, buying, breeding, claiming, entering, redeem';


--
-- Name: activity_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activity_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activity_points_id_seq OWNED BY public.activity_points.id;


--
-- Name: race_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_records (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
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
 SELECT year,
    horse_id,
    sum(starts) AS starts,
    sum(stakes_starts) AS stakes_starts,
    sum(wins) AS wins,
    sum(stakes_wins) AS stakes_wins,
    sum(seconds) AS seconds,
    sum(stakes_seconds) AS stakes_seconds,
    sum(thirds) AS thirds,
    sum(stakes_thirds) AS stakes_thirds,
    sum(fourths) AS fourths,
    sum(stakes_fourths) AS stakes_fourths,
    sum(points) AS points,
    sum(earnings) AS earnings
   FROM public.race_records
  GROUP BY year, horse_id
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
    id bigint NOT NULL,
    auction_id bigint NOT NULL,
    bidder_id bigint NOT NULL,
    comment text,
    current_bid integer DEFAULT 0 NOT NULL,
    notify_if_outbid boolean DEFAULT false NOT NULL,
    horse_id bigint NOT NULL,
    maximum_bid integer,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    current_high_bid boolean DEFAULT false NOT NULL,
    bid_at timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- Name: auction_bids_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auction_bids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auction_bids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auction_bids_id_seq OWNED BY public.auction_bids.id;


--
-- Name: auction_consignment_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auction_consignment_configs (
    id bigint NOT NULL,
    auction_id bigint NOT NULL,
    horse_type character varying NOT NULL,
    maximum_age integer DEFAULT 0 NOT NULL,
    minimum_age integer DEFAULT 0 NOT NULL,
    minimum_count integer DEFAULT 0 NOT NULL,
    stakes_quality boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: auction_consignment_configs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auction_consignment_configs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auction_consignment_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auction_consignment_configs_id_seq OWNED BY public.auction_consignment_configs.id;


--
-- Name: auction_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auction_horses (
    id bigint NOT NULL,
    auction_id bigint NOT NULL,
    comment text,
    horse_id bigint NOT NULL,
    maximum_price integer,
    reserve_price integer,
    sold_at timestamp with time zone,
    public_id character varying(12),
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    slug character varying,
    seller_id bigint,
    buyer_id bigint
);


--
-- Name: auction_horses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auction_horses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auction_horses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auction_horses_id_seq OWNED BY public.auction_horses.id;


--
-- Name: auctions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.auctions (
    id bigint NOT NULL,
    auctioneer_id bigint NOT NULL,
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
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    slug character varying,
    horses_count integer DEFAULT 0 NOT NULL,
    sold_horses_count integer DEFAULT 0 NOT NULL,
    pending_sales_count integer DEFAULT 0 NOT NULL
);


--
-- Name: auctions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.auctions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: auctions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.auctions_id_seq OWNED BY public.auctions.id;


--
-- Name: boardings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boardings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    horse_id bigint NOT NULL,
    location_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date,
    days integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: broodmare_foal_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.broodmare_foal_records (
    id bigint NOT NULL,
    born_foals_count integer DEFAULT 0 NOT NULL,
    breed_ranking character varying,
    horse_id bigint NOT NULL,
    millionaire_foals_count integer DEFAULT 0 NOT NULL,
    multi_millionaire_foals_count integer DEFAULT 0 NOT NULL,
    multi_stakes_winning_foals_count integer DEFAULT 0 CONSTRAINT broodmare_foal_records_multi_stakes_winning_foals_coun_not_null NOT NULL,
    raced_foals_count integer DEFAULT 0 NOT NULL,
    stakes_winning_foals_count integer DEFAULT 0 NOT NULL,
    stillborn_foals_count integer DEFAULT 0 NOT NULL,
    total_foal_earnings bigint DEFAULT 0 NOT NULL,
    total_foal_points integer DEFAULT 0 NOT NULL,
    total_foal_races integer DEFAULT 0 NOT NULL,
    unborn_foals_count integer DEFAULT 0 NOT NULL,
    winning_foals_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: broodmare_foal_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.broodmare_foal_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: broodmare_foal_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.broodmare_foal_records_id_seq OWNED BY public.broodmare_foal_records.id;


--
-- Name: broodmare_shipments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.broodmare_shipments (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    departure_date date NOT NULL,
    arrival_date date NOT NULL,
    mode public.shipping_mode NOT NULL,
    starting_farm_id bigint NOT NULL,
    ending_farm_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN broodmare_shipments.mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.broodmare_shipments.mode IS 'road, air';


--
-- Name: broodmare_shipments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.broodmare_shipments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: broodmare_shipments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.broodmare_shipments_id_seq OWNED BY public.broodmare_shipments.id;


--
-- Name: budget_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.budget_transactions (
    id bigint NOT NULL,
    activity_type public.budget_activity_type,
    amount integer DEFAULT 0 NOT NULL,
    balance integer DEFAULT 0 NOT NULL,
    description text NOT NULL,
    legacy_budget_id integer DEFAULT 0,
    legacy_stable_id integer DEFAULT 0,
    stable_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN budget_transactions.activity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.budget_transactions.activity_type IS 'sold_horse, bought_horse, bred_mare, bred_stud, claimed_horse, entered_race, shipped_horse, race_winnings, jockey_fee, nominated_racehorse, nominated_stallion, boarded_horse';


--
-- Name: budget_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.budget_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: budget_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.budget_transactions_id_seq OWNED BY public.budget_transactions.id;


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_migrations (
    version character varying NOT NULL
);


--
-- Name: future_race_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.future_race_entries (
    id bigint NOT NULL,
    race_id bigint NOT NULL,
    date date NOT NULL,
    horse_id bigint NOT NULL,
    equipment integer DEFAULT 0 NOT NULL,
    first_jockey_id bigint,
    second_jockey_id bigint,
    third_jockey_id bigint,
    racing_style public.racing_style,
    auto_enter boolean DEFAULT false NOT NULL,
    auto_ship boolean DEFAULT false NOT NULL,
    ship_mode public.shipping_mode,
    ship_when_entries_open boolean DEFAULT false NOT NULL,
    ship_when_horse_is_entered boolean DEFAULT false NOT NULL,
    ship_only_if_horse_is_entered boolean DEFAULT false NOT NULL,
    ship_date date,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN future_race_entries.racing_style; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.future_race_entries.racing_style IS 'leading,off_pace,midpack,closing';


--
-- Name: COLUMN future_race_entries.ship_mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.future_race_entries.ship_mode IS 'road, air';


--
-- Name: future_race_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.future_race_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: future_race_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.future_race_entries_id_seq OWNED BY public.future_race_entries.id;


--
-- Name: game_activity_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_activity_points (
    id bigint NOT NULL,
    activity_type public.activity_type NOT NULL,
    first_year_points integer DEFAULT 0 NOT NULL,
    older_year_points integer DEFAULT 0 NOT NULL,
    second_year_points integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN game_activity_points.activity_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.game_activity_points.activity_type IS 'color_war, auction, selling, buying, breeding, claiming, entering, redeem';


--
-- Name: game_activity_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.game_activity_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_activity_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.game_activity_points_id_seq OWNED BY public.game_activity_points.id;


--
-- Name: game_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.game_alerts (
    id bigint NOT NULL,
    display_to_newbies boolean DEFAULT true NOT NULL,
    display_to_non_newbies boolean DEFAULT true NOT NULL,
    end_time timestamp with time zone,
    message text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: game_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.game_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: game_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.game_alerts_id_seq OWNED BY public.game_alerts.id;


--
-- Name: historical_injuries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historical_injuries (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    date date NOT NULL,
    injury_type public.injury_types NOT NULL,
    leg public.legs,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: historical_injuries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.historical_injuries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_injuries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.historical_injuries_id_seq OWNED BY public.historical_injuries.id;


--
-- Name: horse_appearances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horse_appearances (
    id bigint NOT NULL,
    birth_height numeric(4,2) DEFAULT 0.0 NOT NULL,
    current_height numeric(4,2) DEFAULT 0.0 NOT NULL,
    max_height numeric(4,2) DEFAULT 0.0 NOT NULL,
    color public.horse_color DEFAULT 'bay'::public.horse_color NOT NULL,
    rf_leg_marking public.horse_leg_marking,
    lf_leg_marking public.horse_leg_marking,
    rh_leg_marking public.horse_leg_marking,
    lh_leg_marking public.horse_leg_marking,
    face_marking public.horse_face_marking,
    face_image character varying,
    horse_id bigint NOT NULL,
    lf_leg_image character varying,
    lh_leg_image character varying,
    rf_leg_image character varying,
    rh_leg_image character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
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
-- Name: horse_appearances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.horse_appearances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: horse_appearances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.horse_appearances_id_seq OWNED BY public.horse_appearances.id;


--
-- Name: horse_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horse_attributes (
    id bigint NOT NULL,
    track_record character varying DEFAULT 'Unraced'::character varying NOT NULL,
    title character varying,
    breeding_record public.breed_record DEFAULT 'none'::public.breed_record NOT NULL,
    dosage_text character varying,
    string character varying,
    horse_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN horse_attributes.breeding_record; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horse_attributes.breeding_record IS 'none, bronze, silver, gold, platinum';


--
-- Name: horse_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.horse_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: horse_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.horse_attributes_id_seq OWNED BY public.horse_attributes.id;


--
-- Name: horse_genetics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horse_genetics (
    id bigint NOT NULL,
    allele character varying(32) NOT NULL,
    horse_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: horse_genetics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.horse_genetics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: horse_genetics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.horse_genetics_id_seq OWNED BY public.horse_genetics.id;


--
-- Name: horse_jockey_relationships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horse_jockey_relationships (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    jockey_id bigint NOT NULL,
    experience integer DEFAULT 0 NOT NULL,
    happiness integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: horse_jockey_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.horse_jockey_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: horse_jockey_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.horse_jockey_relationships_id_seq OWNED BY public.horse_jockey_relationships.id;


--
-- Name: horse_sales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horse_sales (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    date date NOT NULL,
    seller_id bigint NOT NULL,
    buyer_id bigint NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    private boolean DEFAULT true NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: horse_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.horse_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: horse_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.horse_sales_id_seq OWNED BY public.horse_sales.id;


--
-- Name: horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.horses (
    id bigint NOT NULL,
    public_id character varying(12),
    name character varying(18),
    slug character varying,
    date_of_birth date NOT NULL,
    date_of_death date,
    age integer DEFAULT 0 NOT NULL,
    gender public.horse_gender NOT NULL,
    status public.horse_status DEFAULT 'unborn'::public.horse_status NOT NULL,
    sire_id bigint,
    dam_id bigint,
    owner_id bigint NOT NULL,
    breeder_id bigint NOT NULL,
    legacy_id integer,
    location_bred_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    leaser_id bigint
);


--
-- Name: COLUMN horses.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horses.gender IS 'colt, filly, mare, stallion, gelding';


--
-- Name: COLUMN horses.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.horses.status IS 'unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased';


--
-- Name: horses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.horses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: horses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.horses_id_seq OWNED BY public.horses.id;


--
-- Name: injuries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.injuries (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    date date NOT NULL,
    injury_type public.injury_types NOT NULL,
    rest_date date NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: injuries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.injuries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: injuries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.injuries_id_seq OWNED BY public.injuries.id;


--
-- Name: job_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_stats (
    id bigint NOT NULL,
    name character varying NOT NULL,
    last_run_at timestamp(6) with time zone,
    outcome jsonb,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: job_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_stats_id_seq OWNED BY public.job_stats.id;


--
-- Name: jockeys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jockeys (
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
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN jockeys.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.jockeys.status IS 'apprentice, veteran, retired';


--
-- Name: COLUMN jockeys.jockey_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.jockeys.jockey_type IS 'flat, jump';


--
-- Name: COLUMN jockeys.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.jockeys.gender IS 'male, female';


--
-- Name: jockeys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jockeys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jockeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jockeys_id_seq OWNED BY public.jockeys.id;


--
-- Name: lease_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lease_offers (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    owner_id bigint NOT NULL,
    leaser_id bigint,
    new_members_only boolean DEFAULT false NOT NULL,
    offer_start_date date NOT NULL,
    duration_months integer NOT NULL,
    fee integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: lease_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lease_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lease_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lease_offers_id_seq OWNED BY public.lease_offers.id;


--
-- Name: lease_termination_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lease_termination_requests (
    id bigint NOT NULL,
    lease_id bigint NOT NULL,
    leaser_accepted_end boolean DEFAULT false NOT NULL,
    owner_accepted_end boolean DEFAULT false NOT NULL,
    leaser_accepted_refund boolean DEFAULT false NOT NULL,
    owner_accepted_refund boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: lease_termination_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lease_termination_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lease_termination_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lease_termination_requests_id_seq OWNED BY public.lease_termination_requests.id;


--
-- Name: leases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leases (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    owner_id bigint NOT NULL,
    leaser_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    fee integer DEFAULT 0 NOT NULL,
    early_termination_date date,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: leases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leases_id_seq OWNED BY public.leases.id;


--
-- Name: lifetime_race_records; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.lifetime_race_records AS
 SELECT horse_id,
    sum(starts) AS starts,
    sum(stakes_starts) AS stakes_starts,
    sum(wins) AS wins,
    sum(stakes_wins) AS stakes_wins,
    sum(seconds) AS seconds,
    sum(stakes_seconds) AS stakes_seconds,
    sum(thirds) AS thirds,
    sum(stakes_thirds) AS stakes_thirds,
    sum(fourths) AS fourths,
    sum(stakes_fourths) AS stakes_fourths,
    sum(points) AS points,
    sum(earnings) AS earnings
   FROM public.race_records
  GROUP BY horse_id
  WITH NO DATA;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    country character varying NOT NULL,
    county character varying,
    name character varying NOT NULL,
    state character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    has_farm boolean DEFAULT true NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


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
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    read_at timestamp(6) with time zone,
    params jsonb,
    type character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: race_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_entries (
    id bigint NOT NULL,
    race_id bigint NOT NULL,
    date date NOT NULL,
    horse_id bigint NOT NULL,
    equipment integer DEFAULT 0 NOT NULL,
    post_parade integer DEFAULT 0 NOT NULL,
    jockey_id bigint,
    first_jockey_id bigint,
    second_jockey_id bigint,
    third_jockey_id bigint,
    racing_style public.racing_style,
    odd_id bigint,
    weight integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN race_entries.racing_style; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_entries.racing_style IS 'leading,off_pace,midpack,closing';


--
-- Name: race_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.race_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: race_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.race_entries_id_seq OWNED BY public.race_entries.id;


--
-- Name: race_odds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_odds (
    id bigint NOT NULL,
    display character varying NOT NULL,
    value numeric(3,1) NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: race_odds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.race_odds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: race_odds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.race_odds_id_seq OWNED BY public.race_odds.id;


--
-- Name: race_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_options (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    racehorse_type public.racehorse_type,
    minimum_distance numeric(3,1) DEFAULT 5.0 NOT NULL,
    maximum_distance numeric(3,1) DEFAULT 24.0 NOT NULL,
    calculated_minimum_distance numeric(3,1) DEFAULT 24.0 NOT NULL,
    calculated_maximum_distance numeric(3,1) DEFAULT 5.0 NOT NULL,
    runs_on_dirt boolean DEFAULT true NOT NULL,
    runs_on_turf boolean DEFAULT true NOT NULL,
    trains_on_dirt boolean DEFAULT true NOT NULL,
    trains_on_turf boolean DEFAULT true NOT NULL,
    trains_on_jumps boolean DEFAULT false NOT NULL,
    first_jockey_id bigint,
    second_jockey_id bigint,
    third_jockey_id bigint,
    racing_style public.racing_style,
    equipment integer DEFAULT 0 NOT NULL,
    note_for_next_race text,
    next_race_note_created_at timestamp(6) with time zone,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN race_options.racehorse_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_options.racehorse_type IS 'flat,jump';


--
-- Name: COLUMN race_options.racing_style; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.race_options.racing_style IS 'leading,off_pace,midpack,closing';


--
-- Name: race_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.race_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: race_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.race_options_id_seq OWNED BY public.race_options.id;


--
-- Name: race_result_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_result_horses (
    id bigint NOT NULL,
    race_id bigint NOT NULL,
    horse_id bigint NOT NULL,
    legacy_horse_id integer DEFAULT 0 NOT NULL,
    post_parade integer DEFAULT 1 NOT NULL,
    finish_position integer DEFAULT 1 NOT NULL,
    positions character varying NOT NULL,
    margins character varying NOT NULL,
    fractions character varying,
    jockey_id bigint,
    equipment integer DEFAULT 0 NOT NULL,
    odd_id bigint,
    speed_factor integer DEFAULT 0 NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: race_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_results (
    id bigint NOT NULL,
    date date NOT NULL,
    number integer DEFAULT 1 NOT NULL,
    race_type public.race_type DEFAULT 'maiden'::public.race_type NOT NULL,
    age public.race_age DEFAULT '2'::public.race_age NOT NULL,
    male_only boolean DEFAULT false NOT NULL,
    female_only boolean DEFAULT false NOT NULL,
    distance numeric(3,1) DEFAULT 5.0 NOT NULL,
    grade public.race_grade,
    surface_id bigint NOT NULL,
    condition public.track_condition,
    name character varying,
    purse bigint DEFAULT 0 NOT NULL,
    claiming_price integer,
    split public.race_splits,
    time_in_seconds numeric(7,3) DEFAULT 0.0 NOT NULL,
    slug character varying,
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
-- Name: race_qualifications; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.race_qualifications AS
 SELECT h.id AS horse_id,
        CASE ( SELECT count(*) AS count
               FROM public.lifetime_race_records
              WHERE ((lifetime_race_records.horse_id = h.id) AND (lifetime_race_records.wins = 0)))
            WHEN 1 THEN true
            ELSE false
        END AS maiden_qualified,
        CASE ( SELECT count(r.id) AS count
               FROM (public.race_result_horses rr
                 LEFT JOIN public.race_results r ON ((r.id = rr.race_id)))
              WHERE ((rr.horse_id = h.id) AND (r.date > GREATEST(horse_sales.sale_date, h.date_of_birth))))
            WHEN 3 THEN true
            ELSE false
        END AS claiming_qualified,
        CASE ( SELECT count(r.id) AS count
               FROM (public.race_result_horses rr
                 LEFT JOIN public.race_results r ON ((rr.race_id = r.id)))
              WHERE ((rr.horse_id = h.id) AND (r.date >= (CURRENT_DATE - '1 year'::interval)) AND (r.race_type = 'claiming'::public.race_type)))
            WHEN 0 THEN false
            ELSE true
        END AS starter_allowance_qualified,
        CASE allowance_wins.wins
            WHEN 0 THEN true
            ELSE false
        END AS nw1_allowance_qualified,
        CASE allowance_wins.wins
            WHEN 0 THEN true
            WHEN 1 THEN true
            ELSE false
        END AS nw2_allowance_qualified,
        CASE allowance_wins.wins
            WHEN 0 THEN true
            WHEN 1 THEN true
            WHEN 2 THEN true
            ELSE false
        END AS nw3_allowance_qualified,
        CASE ( SELECT count(r.id) AS count
               FROM (public.race_result_horses rr
                 LEFT JOIN public.race_results r ON ((rr.race_id = r.id)))
              WHERE ((rr.horse_id = h.id) AND (rr.finish_position <= 3) AND (r.race_type = 'allowance'::public.race_type)))
            WHEN 0 THEN false
            ELSE true
        END AS allowance_placed,
        CASE ( SELECT count(r.id) AS count
               FROM (public.race_result_horses rr
                 LEFT JOIN public.race_results r ON ((rr.race_id = r.id)))
              WHERE ((rr.horse_id = h.id) AND (rr.finish_position <= 3) AND (r.race_type = 'stakes'::public.race_type)))
            WHEN 0 THEN false
            ELSE true
        END AS stakes_placed
   FROM ((public.horses h
     LEFT JOIN ( SELECT count(r.id) AS wins,
            rr.horse_id
           FROM (public.race_result_horses rr
             LEFT JOIN public.race_results r ON ((rr.race_id = r.id)))
          WHERE ((rr.finish_position = 1) AND (r.race_type = ANY (ARRAY['starter_allowance'::public.race_type, 'nw1_allowance'::public.race_type, 'nw2_allowance'::public.race_type, 'nw3_allowance'::public.race_type, 'allowance'::public.race_type, 'stakes'::public.race_type])))
          GROUP BY rr.horse_id) allowance_wins ON ((h.id = allowance_wins.horse_id)))
     LEFT JOIN ( SELECT max(hs.date) AS sale_date,
            hs.horse_id
           FROM public.horse_sales hs
          GROUP BY hs.horse_id) horse_sales ON ((h.id = horse_sales.horse_id)))
  WHERE (h.status = 'racehorse'::public.horse_status)
  WITH NO DATA;


--
-- Name: race_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.race_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: race_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.race_records_id_seq OWNED BY public.race_records.id;


--
-- Name: race_result_horses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.race_result_horses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: race_result_horses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.race_result_horses_id_seq OWNED BY public.race_result_horses.id;


--
-- Name: race_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.race_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: race_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.race_results_id_seq OWNED BY public.race_results.id;


--
-- Name: race_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_schedules (
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
    surface_id bigint NOT NULL,
    name character varying,
    purse bigint DEFAULT 0 NOT NULL,
    claiming_price integer,
    qualification_required boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    entries_count integer DEFAULT 0 NOT NULL
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
-- Name: race_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.race_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: race_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.race_schedules_id_seq OWNED BY public.race_schedules.id;


--
-- Name: racehorse_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.racehorse_metadata (
    id bigint CONSTRAINT racehorse_stats_id_not_null NOT NULL,
    horse_id bigint CONSTRAINT racehorse_stats_horse_id_not_null NOT NULL,
    last_raced_at date,
    last_rested_at date,
    last_shipped_at date,
    energy_grade character varying DEFAULT 'F'::character varying CONSTRAINT racehorse_stats_energy_grade_not_null NOT NULL,
    fitness_grade character varying DEFAULT 'F'::character varying CONSTRAINT racehorse_stats_fitness_grade_not_null NOT NULL,
    racetrack_id bigint CONSTRAINT racehorse_stats_racetrack_id_not_null NOT NULL,
    at_home boolean DEFAULT true CONSTRAINT racehorse_stats_at_home_not_null NOT NULL,
    in_transit boolean DEFAULT false CONSTRAINT racehorse_stats_in_transit_not_null NOT NULL,
    created_at timestamp(6) with time zone CONSTRAINT racehorse_stats_created_at_not_null NOT NULL,
    updated_at timestamp(6) with time zone CONSTRAINT racehorse_stats_updated_at_not_null NOT NULL,
    rest_days_since_last_race integer DEFAULT 0 CONSTRAINT racehorse_stats_rest_days_since_last_race_not_null NOT NULL,
    workouts_since_last_race integer DEFAULT 0 CONSTRAINT racehorse_stats_workouts_since_last_race_not_null NOT NULL
);


--
-- Name: racehorse_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.racehorse_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: racehorse_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.racehorse_metadata_id_seq OWNED BY public.racehorse_metadata.id;


--
-- Name: racehorse_shipments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.racehorse_shipments (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    departure_date date NOT NULL,
    arrival_date date NOT NULL,
    mode public.shipping_mode NOT NULL,
    starting_location_id bigint NOT NULL,
    ending_location_id bigint NOT NULL,
    shipping_type public.shipping_type NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN racehorse_shipments.mode; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.racehorse_shipments.mode IS 'road, air';


--
-- Name: COLUMN racehorse_shipments.shipping_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.racehorse_shipments.shipping_type IS 'track_to_track, farm_to_track, track_to_farm';


--
-- Name: racehorse_shipments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.racehorse_shipments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: racehorse_shipments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.racehorse_shipments_id_seq OWNED BY public.racehorse_shipments.id;


--
-- Name: racetracks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.racetracks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying,
    public_id character varying(12),
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    location_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: racetracks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.racetracks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: racetracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.racetracks_id_seq OWNED BY public.racetracks.id;


--
-- Name: racing_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.racing_stats (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    acceleration integer DEFAULT 0 NOT NULL,
    average_speed integer DEFAULT 0 NOT NULL,
    break_speed integer DEFAULT 0 NOT NULL,
    closing integer DEFAULT 0 NOT NULL,
    consistency integer DEFAULT 0 NOT NULL,
    courage integer DEFAULT 0 NOT NULL,
    desired_equipment integer DEFAULT 0 NOT NULL,
    dirt integer DEFAULT 0 NOT NULL,
    energy integer DEFAULT 0 NOT NULL,
    energy_minimum integer DEFAULT 0 NOT NULL,
    energy_regain integer DEFAULT 0 NOT NULL,
    fitness integer DEFAULT 0 NOT NULL,
    "leading" integer DEFAULT 0 NOT NULL,
    loaf_percent integer DEFAULT 0 NOT NULL,
    loaf_threshold integer DEFAULT 0 NOT NULL,
    max_speed integer DEFAULT 0 NOT NULL,
    midpack integer DEFAULT 0 NOT NULL,
    min_speed integer DEFAULT 0 NOT NULL,
    natural_energy_current double precision DEFAULT 0.0 NOT NULL,
    natural_energy_gain numeric(5,3) DEFAULT 0.0 NOT NULL,
    natural_energy_loss integer DEFAULT 0 NOT NULL,
    off_pace integer DEFAULT 0 NOT NULL,
    peak_end_date date NOT NULL,
    peak_start_date date NOT NULL,
    pissy integer DEFAULT 0 NOT NULL,
    ratability integer DEFAULT 0 NOT NULL,
    soundness integer DEFAULT 0 NOT NULL,
    stamina integer DEFAULT 0 NOT NULL,
    steeplechase integer DEFAULT 0 NOT NULL,
    strides_per_second numeric(5,3) DEFAULT 0.0 NOT NULL,
    sustain integer DEFAULT 0 NOT NULL,
    track_fast integer DEFAULT 0 NOT NULL,
    track_good integer DEFAULT 0 NOT NULL,
    track_slow integer DEFAULT 0 NOT NULL,
    track_wet integer DEFAULT 0 NOT NULL,
    traffic integer DEFAULT 0 NOT NULL,
    turf integer DEFAULT 0 NOT NULL,
    turning integer DEFAULT 0 NOT NULL,
    weight integer DEFAULT 0 NOT NULL,
    xp_current integer DEFAULT 0 NOT NULL,
    xp_rate integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: racing_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.racing_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: racing_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.racing_stats_id_seq OWNED BY public.racing_stats.id;


--
-- Name: sale_offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sale_offers (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    owner_id bigint NOT NULL,
    buyer_id bigint,
    new_members_only boolean DEFAULT false NOT NULL,
    offer_start_date date NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: sale_offers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sale_offers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sale_offers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sale_offers_id_seq OWNED BY public.sale_offers.id;


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
    user_id integer,
    old_user_id uuid,
    data text,
    old_id uuid,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
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
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    theme character varying,
    locale character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    dark_theme character varying,
    dark_mode boolean DEFAULT false NOT NULL,
    time_zone character varying DEFAULT 'America/New_York'::character varying NOT NULL,
    website jsonb DEFAULT '{}'::jsonb,
    racing jsonb DEFAULT '{}'::jsonb
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: shipment_routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shipment_routes (
    id bigint NOT NULL,
    starting_location_id bigint NOT NULL,
    ending_location_id bigint NOT NULL,
    miles integer DEFAULT 0 NOT NULL,
    road_days integer,
    road_cost integer,
    air_days integer,
    air_cost integer,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: shipment_routes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shipment_routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shipment_routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shipment_routes_id_seq OWNED BY public.shipment_routes.id;


--
-- Name: stables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stables (
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
    racetrack_id bigint,
    user_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: stables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stables_id_seq OWNED BY public.stables.id;


--
-- Name: stud_foal_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stud_foal_records (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    born_foals_count integer DEFAULT 0 NOT NULL,
    raced_foals_count integer DEFAULT 0 NOT NULL,
    winning_foals_count integer DEFAULT 0 NOT NULL,
    stakes_winning_foals_count integer DEFAULT 0 NOT NULL,
    multi_stakes_winning_foals_count integer DEFAULT 0 NOT NULL,
    millionaire_foals_count integer DEFAULT 0 NOT NULL,
    multi_millionaire_foals_count integer DEFAULT 0 NOT NULL,
    total_foal_earnings bigint DEFAULT 0 NOT NULL,
    total_foal_points integer DEFAULT 0 NOT NULL,
    total_foal_races integer DEFAULT 0 NOT NULL,
    breed_ranking character varying,
    unborn_foals_count integer DEFAULT 0 NOT NULL,
    stillborn_foals_count integer DEFAULT 0 NOT NULL,
    crops_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: stud_foal_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stud_foal_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stud_foal_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stud_foal_records_id_seq OWNED BY public.stud_foal_records.id;


--
-- Name: track_surfaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.track_surfaces (
    id bigint NOT NULL,
    surface public.track_surface DEFAULT 'dirt'::public.track_surface NOT NULL,
    condition public.track_condition DEFAULT 'fast'::public.track_condition NOT NULL,
    racetrack_id bigint NOT NULL,
    banking integer NOT NULL,
    jumps integer DEFAULT 0 NOT NULL,
    length integer NOT NULL,
    turn_distance integer NOT NULL,
    turn_to_finish_length integer NOT NULL,
    width integer NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
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
-- Name: track_surfaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.track_surfaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: track_surfaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.track_surfaces_id_seq OWNED BY public.track_surfaces.id;


--
-- Name: training_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_schedules (
    id bigint NOT NULL,
    stable_id bigint NOT NULL,
    name character varying NOT NULL,
    horses_count integer DEFAULT 0 NOT NULL,
    description text,
    sunday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    monday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    tuesday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    wednesday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    thursday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    friday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    saturday_activities jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: training_schedules_horses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.training_schedules_horses (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    training_schedule_id bigint NOT NULL,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
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
-- Name: training_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.training_schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: training_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.training_schedules_id_seq OWNED BY public.training_schedules.id;


--
-- Name: user_push_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_push_subscriptions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    user_agent character varying,
    auth_key character varying,
    endpoint character varying,
    p256dh_key character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: user_push_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_push_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_push_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_push_subscriptions_id_seq OWNED BY public.user_push_subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
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
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: COLUMN users.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.status IS 'pending, active, deleted, banned';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: workout_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workout_comments (
    id bigint NOT NULL,
    comment_i18n_key character varying,
    stat public.workout_stats NOT NULL,
    stat_value integer,
    placeholders character varying,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL
);


--
-- Name: workout_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workout_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workout_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workout_comments_id_seq OWNED BY public.workout_comments.id;


--
-- Name: workouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workouts (
    id bigint NOT NULL,
    horse_id bigint NOT NULL,
    jockey_id bigint NOT NULL,
    date date NOT NULL,
    racetrack_id bigint NOT NULL,
    surface_id bigint NOT NULL,
    location_id bigint NOT NULL,
    condition public.track_condition NOT NULL,
    equipment integer DEFAULT 0 NOT NULL,
    comment_id bigint NOT NULL,
    effort integer DEFAULT 0 NOT NULL,
    confidence integer DEFAULT 0 NOT NULL,
    rank integer,
    time_in_seconds integer,
    activity1 public.workout_activities NOT NULL,
    distance1 integer DEFAULT 0 NOT NULL,
    activity2 public.workout_activities,
    distance2 integer DEFAULT 0,
    activity3 public.workout_activities,
    distance3 integer DEFAULT 0,
    created_at timestamp(6) with time zone NOT NULL,
    updated_at timestamp(6) with time zone NOT NULL,
    total_time_in_seconds integer DEFAULT 0,
    activity1_time_in_seconds integer DEFAULT 0,
    activity2_time_in_seconds integer DEFAULT 0,
    activity3_time_in_seconds integer DEFAULT 0
);


--
-- Name: COLUMN workouts.condition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.workouts.condition IS 'fast, good, slow, wet';


--
-- Name: COLUMN workouts.activity1; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.workouts.activity1 IS 'walk, jog, canter, gallop, breeze';


--
-- Name: COLUMN workouts.activity2; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.workouts.activity2 IS 'walk, jog, canter, gallop, breeze';


--
-- Name: COLUMN workouts.activity3; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.workouts.activity3 IS 'walk, jog, canter, gallop, breeze';


--
-- Name: workouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workouts_id_seq OWNED BY public.workouts.id;


--
-- Name: activations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activations ALTER COLUMN id SET DEFAULT nextval('public.activations_id_seq'::regclass);


--
-- Name: activity_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_points ALTER COLUMN id SET DEFAULT nextval('public.activity_points_id_seq'::regclass);


--
-- Name: auction_bids id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_bids ALTER COLUMN id SET DEFAULT nextval('public.auction_bids_id_seq'::regclass);


--
-- Name: auction_consignment_configs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_consignment_configs ALTER COLUMN id SET DEFAULT nextval('public.auction_consignment_configs_id_seq'::regclass);


--
-- Name: auction_horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_horses ALTER COLUMN id SET DEFAULT nextval('public.auction_horses_id_seq'::regclass);


--
-- Name: auctions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auctions ALTER COLUMN id SET DEFAULT nextval('public.auctions_id_seq'::regclass);


--
-- Name: broodmare_foal_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_foal_records ALTER COLUMN id SET DEFAULT nextval('public.broodmare_foal_records_id_seq'::regclass);


--
-- Name: broodmare_shipments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_shipments ALTER COLUMN id SET DEFAULT nextval('public.broodmare_shipments_id_seq'::regclass);


--
-- Name: budget_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.budget_transactions ALTER COLUMN id SET DEFAULT nextval('public.budget_transactions_id_seq'::regclass);


--
-- Name: future_race_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.future_race_entries ALTER COLUMN id SET DEFAULT nextval('public.future_race_entries_id_seq'::regclass);


--
-- Name: game_activity_points id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_activity_points ALTER COLUMN id SET DEFAULT nextval('public.game_activity_points_id_seq'::regclass);


--
-- Name: game_alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.game_alerts ALTER COLUMN id SET DEFAULT nextval('public.game_alerts_id_seq'::regclass);


--
-- Name: historical_injuries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historical_injuries ALTER COLUMN id SET DEFAULT nextval('public.historical_injuries_id_seq'::regclass);


--
-- Name: horse_appearances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_appearances ALTER COLUMN id SET DEFAULT nextval('public.horse_appearances_id_seq'::regclass);


--
-- Name: horse_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_attributes ALTER COLUMN id SET DEFAULT nextval('public.horse_attributes_id_seq'::regclass);


--
-- Name: horse_genetics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_genetics ALTER COLUMN id SET DEFAULT nextval('public.horse_genetics_id_seq'::regclass);


--
-- Name: horse_jockey_relationships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_jockey_relationships ALTER COLUMN id SET DEFAULT nextval('public.horse_jockey_relationships_id_seq'::regclass);


--
-- Name: horse_sales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_sales ALTER COLUMN id SET DEFAULT nextval('public.horse_sales_id_seq'::regclass);


--
-- Name: horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses ALTER COLUMN id SET DEFAULT nextval('public.horses_id_seq'::regclass);


--
-- Name: injuries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.injuries ALTER COLUMN id SET DEFAULT nextval('public.injuries_id_seq'::regclass);


--
-- Name: job_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_stats ALTER COLUMN id SET DEFAULT nextval('public.job_stats_id_seq'::regclass);


--
-- Name: jockeys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jockeys ALTER COLUMN id SET DEFAULT nextval('public.jockeys_id_seq'::regclass);


--
-- Name: lease_offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_offers ALTER COLUMN id SET DEFAULT nextval('public.lease_offers_id_seq'::regclass);


--
-- Name: lease_termination_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_termination_requests ALTER COLUMN id SET DEFAULT nextval('public.lease_termination_requests_id_seq'::regclass);


--
-- Name: leases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leases ALTER COLUMN id SET DEFAULT nextval('public.leases_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


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
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: race_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries ALTER COLUMN id SET DEFAULT nextval('public.race_entries_id_seq'::regclass);


--
-- Name: race_odds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_odds ALTER COLUMN id SET DEFAULT nextval('public.race_odds_id_seq'::regclass);


--
-- Name: race_options id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_options ALTER COLUMN id SET DEFAULT nextval('public.race_options_id_seq'::regclass);


--
-- Name: race_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_records ALTER COLUMN id SET DEFAULT nextval('public.race_records_id_seq'::regclass);


--
-- Name: race_result_horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses ALTER COLUMN id SET DEFAULT nextval('public.race_result_horses_id_seq'::regclass);


--
-- Name: race_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_results ALTER COLUMN id SET DEFAULT nextval('public.race_results_id_seq'::regclass);


--
-- Name: race_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_schedules ALTER COLUMN id SET DEFAULT nextval('public.race_schedules_id_seq'::regclass);


--
-- Name: racehorse_metadata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_metadata ALTER COLUMN id SET DEFAULT nextval('public.racehorse_metadata_id_seq'::regclass);


--
-- Name: racehorse_shipments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_shipments ALTER COLUMN id SET DEFAULT nextval('public.racehorse_shipments_id_seq'::regclass);


--
-- Name: racetracks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racetracks ALTER COLUMN id SET DEFAULT nextval('public.racetracks_id_seq'::regclass);


--
-- Name: racing_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racing_stats ALTER COLUMN id SET DEFAULT nextval('public.racing_stats_id_seq'::regclass);


--
-- Name: sale_offers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_offers ALTER COLUMN id SET DEFAULT nextval('public.sale_offers_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: shipment_routes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_routes ALTER COLUMN id SET DEFAULT nextval('public.shipment_routes_id_seq'::regclass);


--
-- Name: stables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stables ALTER COLUMN id SET DEFAULT nextval('public.stables_id_seq'::regclass);


--
-- Name: stud_foal_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stud_foal_records ALTER COLUMN id SET DEFAULT nextval('public.stud_foal_records_id_seq'::regclass);


--
-- Name: track_surfaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_surfaces ALTER COLUMN id SET DEFAULT nextval('public.track_surfaces_id_seq'::regclass);


--
-- Name: training_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules ALTER COLUMN id SET DEFAULT nextval('public.training_schedules_id_seq'::regclass);


--
-- Name: training_schedules_horses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules_horses ALTER COLUMN id SET DEFAULT nextval('public.training_schedules_horses_id_seq'::regclass);


--
-- Name: user_push_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_push_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.user_push_subscriptions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workout_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_comments ALTER COLUMN id SET DEFAULT nextval('public.workout_comments_id_seq'::regclass);


--
-- Name: workouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts ALTER COLUMN id SET DEFAULT nextval('public.workouts_id_seq'::regclass);


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
-- Name: boardings boardings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boardings
    ADD CONSTRAINT boardings_pkey PRIMARY KEY (id);


--
-- Name: broodmare_foal_records broodmare_foal_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_foal_records
    ADD CONSTRAINT broodmare_foal_records_pkey PRIMARY KEY (id);


--
-- Name: broodmare_shipments broodmare_shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_shipments
    ADD CONSTRAINT broodmare_shipments_pkey PRIMARY KEY (id);


--
-- Name: budget_transactions budget_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.budget_transactions
    ADD CONSTRAINT budget_transactions_pkey PRIMARY KEY (id);


--
-- Name: data_migrations data_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_migrations
    ADD CONSTRAINT data_migrations_pkey PRIMARY KEY (version);


--
-- Name: future_race_entries future_race_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.future_race_entries
    ADD CONSTRAINT future_race_entries_pkey PRIMARY KEY (id);


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
-- Name: historical_injuries historical_injuries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historical_injuries
    ADD CONSTRAINT historical_injuries_pkey PRIMARY KEY (id);


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
-- Name: horse_jockey_relationships horse_jockey_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_jockey_relationships
    ADD CONSTRAINT horse_jockey_relationships_pkey PRIMARY KEY (id);


--
-- Name: horse_sales horse_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_sales
    ADD CONSTRAINT horse_sales_pkey PRIMARY KEY (id);


--
-- Name: horses horses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT horses_pkey PRIMARY KEY (id);


--
-- Name: injuries injuries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.injuries
    ADD CONSTRAINT injuries_pkey PRIMARY KEY (id);


--
-- Name: job_stats job_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_stats
    ADD CONSTRAINT job_stats_pkey PRIMARY KEY (id);


--
-- Name: jockeys jockeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jockeys
    ADD CONSTRAINT jockeys_pkey PRIMARY KEY (id);


--
-- Name: lease_offers lease_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_offers
    ADD CONSTRAINT lease_offers_pkey PRIMARY KEY (id);


--
-- Name: lease_termination_requests lease_termination_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_termination_requests
    ADD CONSTRAINT lease_termination_requests_pkey PRIMARY KEY (id);


--
-- Name: leases leases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leases
    ADD CONSTRAINT leases_pkey PRIMARY KEY (id);


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
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: race_entries race_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries
    ADD CONSTRAINT race_entries_pkey PRIMARY KEY (id);


--
-- Name: race_odds race_odds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_odds
    ADD CONSTRAINT race_odds_pkey PRIMARY KEY (id);


--
-- Name: race_options race_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_options
    ADD CONSTRAINT race_options_pkey PRIMARY KEY (id);


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
-- Name: racehorse_metadata racehorse_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_metadata
    ADD CONSTRAINT racehorse_metadata_pkey PRIMARY KEY (id);


--
-- Name: racehorse_shipments racehorse_shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_shipments
    ADD CONSTRAINT racehorse_shipments_pkey PRIMARY KEY (id);


--
-- Name: racetracks racetracks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racetracks
    ADD CONSTRAINT racetracks_pkey PRIMARY KEY (id);


--
-- Name: racing_stats racing_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racing_stats
    ADD CONSTRAINT racing_stats_pkey PRIMARY KEY (id);


--
-- Name: sale_offers sale_offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_offers
    ADD CONSTRAINT sale_offers_pkey PRIMARY KEY (id);


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
-- Name: shipment_routes shipment_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_routes
    ADD CONSTRAINT shipment_routes_pkey PRIMARY KEY (id);


--
-- Name: stables stables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stables
    ADD CONSTRAINT stables_pkey PRIMARY KEY (id);


--
-- Name: stud_foal_records stud_foal_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stud_foal_records
    ADD CONSTRAINT stud_foal_records_pkey PRIMARY KEY (id);


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
-- Name: workout_comments workout_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workout_comments
    ADD CONSTRAINT workout_comments_pkey PRIMARY KEY (id);


--
-- Name: workouts workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (id);


--
-- Name: idx_on_horse_id_first_jockey_id_second_jockey_id_th_b7c0ac41cd; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_horse_id_first_jockey_id_second_jockey_id_th_b7c0ac41cd ON public.race_options USING btree (horse_id, first_jockey_id, second_jockey_id, third_jockey_id);


--
-- Name: idx_on_multi_stakes_winning_foals_count_d86a3500a8; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_multi_stakes_winning_foals_count_d86a3500a8 ON public.broodmare_foal_records USING btree (multi_stakes_winning_foals_count);


--
-- Name: idx_on_starting_location_id_ending_location_id_4088f67c10; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_starting_location_id_ending_location_id_4088f67c10 ON public.shipment_routes USING btree (starting_location_id, ending_location_id);


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
-- Name: index_auction_bids_on_bid_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_bids_on_bid_at ON public.auction_bids USING btree (bid_at);


--
-- Name: index_auction_bids_on_bidder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_bids_on_bidder_id ON public.auction_bids USING btree (bidder_id);


--
-- Name: index_auction_bids_on_current_high_bid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_bids_on_current_high_bid ON public.auction_bids USING btree (current_high_bid);


--
-- Name: index_auction_bids_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auction_bids_on_horse_id ON public.auction_bids USING btree (horse_id) WHERE (current_high_bid = true);


--
-- Name: index_auction_configs_on_horse_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auction_configs_on_horse_type ON public.auction_consignment_configs USING btree (auction_id, lower((horse_type)::text));


--
-- Name: index_auction_consignment_configs_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_consignment_configs_on_auction_id ON public.auction_consignment_configs USING btree (auction_id);


--
-- Name: index_auction_horses_on_auction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_horses_on_auction_id ON public.auction_horses USING btree (auction_id);


--
-- Name: index_auction_horses_on_buyer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_horses_on_buyer_id ON public.auction_horses USING btree (buyer_id);


--
-- Name: index_auction_horses_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auction_horses_on_horse_id ON public.auction_horses USING btree (horse_id);


--
-- Name: index_auction_horses_on_seller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auction_horses_on_seller_id ON public.auction_horses USING btree (seller_id);


--
-- Name: index_auction_horses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auction_horses_on_slug ON public.auction_horses USING btree (slug);


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
-- Name: index_auctions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auctions_on_slug ON public.auctions USING btree (slug);


--
-- Name: index_auctions_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_auctions_on_start_time ON public.auctions USING btree (start_time);


--
-- Name: index_auctions_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_auctions_on_title ON public.auctions USING btree (lower((title)::text));


--
-- Name: index_boardings_on_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_end_date ON public.boardings USING btree (end_date);


--
-- Name: index_boardings_on_horse_id_and_location_id_and_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_boardings_on_horse_id_and_location_id_and_start_date ON public.boardings USING btree (horse_id, location_id, start_date);


--
-- Name: index_boardings_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_location_id ON public.boardings USING btree (location_id);


--
-- Name: index_boardings_on_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boardings_on_start_date ON public.boardings USING btree (start_date);


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
-- Name: index_broodmare_foal_records_on_stillborn_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_stillborn_foals_count ON public.broodmare_foal_records USING btree (stillborn_foals_count);


--
-- Name: index_broodmare_foal_records_on_total_foal_points; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_total_foal_points ON public.broodmare_foal_records USING btree (total_foal_points);


--
-- Name: index_broodmare_foal_records_on_total_foal_races; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_total_foal_races ON public.broodmare_foal_records USING btree (total_foal_races);


--
-- Name: index_broodmare_foal_records_on_unborn_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_unborn_foals_count ON public.broodmare_foal_records USING btree (unborn_foals_count);


--
-- Name: index_broodmare_foal_records_on_winning_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_foal_records_on_winning_foals_count ON public.broodmare_foal_records USING btree (winning_foals_count);


--
-- Name: index_broodmare_shipments_on_arrival_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_shipments_on_arrival_date ON public.broodmare_shipments USING btree (arrival_date);


--
-- Name: index_broodmare_shipments_on_ending_farm_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_shipments_on_ending_farm_id ON public.broodmare_shipments USING btree (ending_farm_id);


--
-- Name: index_broodmare_shipments_on_horse_id_and_departure_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_broodmare_shipments_on_horse_id_and_departure_date ON public.broodmare_shipments USING btree (horse_id, departure_date);


--
-- Name: index_broodmare_shipments_on_mode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_shipments_on_mode ON public.broodmare_shipments USING btree (mode);


--
-- Name: index_broodmare_shipments_on_starting_farm_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broodmare_shipments_on_starting_farm_id ON public.broodmare_shipments USING btree (starting_farm_id);


--
-- Name: index_budget_transactions_on_activity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_transactions_on_activity_type ON public.budget_transactions USING btree (activity_type);


--
-- Name: index_budget_transactions_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_transactions_on_description ON public.budget_transactions USING btree (description);


--
-- Name: index_budget_transactions_on_legacy_budget_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_transactions_on_legacy_budget_id ON public.budget_transactions USING btree (legacy_budget_id);


--
-- Name: index_budget_transactions_on_legacy_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_transactions_on_legacy_stable_id ON public.budget_transactions USING btree (legacy_stable_id);


--
-- Name: index_budget_transactions_on_stable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_budget_transactions_on_stable_id ON public.budget_transactions USING btree (stable_id);


--
-- Name: index_future_race_entries_on_auto_enter; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_auto_enter ON public.future_race_entries USING btree (auto_enter);


--
-- Name: index_future_race_entries_on_auto_ship; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_auto_ship ON public.future_race_entries USING btree (auto_ship);


--
-- Name: index_future_race_entries_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_date ON public.future_race_entries USING btree (date);


--
-- Name: index_future_race_entries_on_equipment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_equipment ON public.future_race_entries USING btree (equipment);


--
-- Name: index_future_race_entries_on_first_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_first_jockey_id ON public.future_race_entries USING btree (first_jockey_id);


--
-- Name: index_future_race_entries_on_horse_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_future_race_entries_on_horse_id_and_date ON public.future_race_entries USING btree (horse_id, date);


--
-- Name: index_future_race_entries_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_race_id ON public.future_race_entries USING btree (race_id);


--
-- Name: index_future_race_entries_on_racing_style; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_racing_style ON public.future_race_entries USING btree (racing_style);


--
-- Name: index_future_race_entries_on_second_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_second_jockey_id ON public.future_race_entries USING btree (second_jockey_id);


--
-- Name: index_future_race_entries_on_ship_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_ship_date ON public.future_race_entries USING btree (ship_date);


--
-- Name: index_future_race_entries_on_ship_mode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_ship_mode ON public.future_race_entries USING btree (ship_mode);


--
-- Name: index_future_race_entries_on_ship_only_if_horse_is_entered; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_ship_only_if_horse_is_entered ON public.future_race_entries USING btree (ship_only_if_horse_is_entered);


--
-- Name: index_future_race_entries_on_ship_when_entries_open; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_ship_when_entries_open ON public.future_race_entries USING btree (ship_when_entries_open);


--
-- Name: index_future_race_entries_on_ship_when_horse_is_entered; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_ship_when_horse_is_entered ON public.future_race_entries USING btree (ship_when_horse_is_entered);


--
-- Name: index_future_race_entries_on_third_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_future_race_entries_on_third_jockey_id ON public.future_race_entries USING btree (third_jockey_id);


--
-- Name: index_game_activity_points_on_activity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_activity_points_on_activity_type ON public.game_activity_points USING btree (activity_type);


--
-- Name: index_game_alerts_on_display_to_newbies; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_alerts_on_display_to_newbies ON public.game_alerts USING btree (display_to_newbies);


--
-- Name: index_game_alerts_on_display_to_non_newbies; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_alerts_on_display_to_non_newbies ON public.game_alerts USING btree (display_to_non_newbies);


--
-- Name: index_game_alerts_on_end_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_alerts_on_end_time ON public.game_alerts USING btree (end_time);


--
-- Name: index_game_alerts_on_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_game_alerts_on_start_time ON public.game_alerts USING btree (start_time);


--
-- Name: index_historical_injuries_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_historical_injuries_on_date ON public.historical_injuries USING btree (date);


--
-- Name: index_historical_injuries_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_historical_injuries_on_horse_id ON public.historical_injuries USING btree (horse_id);


--
-- Name: index_historical_injuries_on_injury_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_historical_injuries_on_injury_type ON public.historical_injuries USING btree (injury_type);


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
-- Name: index_horse_jockey_relationships_on_horse_id_and_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_horse_jockey_relationships_on_horse_id_and_jockey_id ON public.horse_jockey_relationships USING btree (horse_id, jockey_id);


--
-- Name: index_horse_jockey_relationships_on_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horse_jockey_relationships_on_jockey_id ON public.horse_jockey_relationships USING btree (jockey_id);


--
-- Name: index_horse_sales_on_buyer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horse_sales_on_buyer_id ON public.horse_sales USING btree (buyer_id);


--
-- Name: index_horse_sales_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horse_sales_on_date ON public.horse_sales USING btree (date);


--
-- Name: index_horse_sales_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horse_sales_on_horse_id ON public.horse_sales USING btree (horse_id);


--
-- Name: index_horse_sales_on_seller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horse_sales_on_seller_id ON public.horse_sales USING btree (seller_id);


--
-- Name: index_horses_on_age; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_age ON public.horses USING btree (age);


--
-- Name: index_horses_on_breeder_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_breeder_id ON public.horses USING btree (breeder_id);


--
-- Name: index_horses_on_dam_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_dam_id ON public.horses USING btree (dam_id);


--
-- Name: index_horses_on_date_of_birth; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_date_of_birth ON public.horses USING btree (date_of_birth);


--
-- Name: index_horses_on_date_of_death; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_date_of_death ON public.horses USING btree (date_of_death);


--
-- Name: index_horses_on_gender; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_gender ON public.horses USING btree (gender);


--
-- Name: index_horses_on_leaser_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_leaser_id ON public.horses USING btree (leaser_id);


--
-- Name: index_horses_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_legacy_id ON public.horses USING btree (legacy_id);


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
-- Name: index_horses_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_public_id ON public.horses USING btree (public_id);


--
-- Name: index_horses_on_sire_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_sire_id ON public.horses USING btree (sire_id);


--
-- Name: index_horses_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_slug ON public.horses USING btree (slug);


--
-- Name: index_horses_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_horses_on_status ON public.horses USING btree (status);


--
-- Name: index_injuries_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_injuries_on_date ON public.injuries USING btree (date);


--
-- Name: index_injuries_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_injuries_on_horse_id ON public.injuries USING btree (horse_id);


--
-- Name: index_injuries_on_injury_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_injuries_on_injury_type ON public.injuries USING btree (injury_type);


--
-- Name: index_injuries_on_rest_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_injuries_on_rest_date ON public.injuries USING btree (rest_date);


--
-- Name: index_job_stats_on_last_run_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_stats_on_last_run_at ON public.job_stats USING btree (last_run_at);


--
-- Name: index_job_stats_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_job_stats_on_name ON public.job_stats USING btree (name);


--
-- Name: index_jockeys_on_date_of_birth; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_date_of_birth ON public.jockeys USING btree (date_of_birth);


--
-- Name: index_jockeys_on_first_name_and_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_jockeys_on_first_name_and_last_name ON public.jockeys USING btree (first_name, last_name);


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
-- Name: index_jockeys_on_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_last_name ON public.jockeys USING btree (last_name);


--
-- Name: index_jockeys_on_legacy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_legacy_id ON public.jockeys USING btree (legacy_id);


--
-- Name: index_jockeys_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_public_id ON public.jockeys USING btree (public_id);


--
-- Name: index_jockeys_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_slug ON public.jockeys USING btree (slug);


--
-- Name: index_jockeys_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_status ON public.jockeys USING btree (status);


--
-- Name: index_jockeys_on_unique_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_jockeys_on_unique_name ON public.jockeys USING btree (first_name, lower((last_name)::text));


--
-- Name: index_jockeys_on_weight; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jockeys_on_weight ON public.jockeys USING btree (weight);


--
-- Name: index_lease_offers_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lease_offers_on_horse_id ON public.lease_offers USING btree (horse_id);


--
-- Name: index_lease_offers_on_leaser_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lease_offers_on_leaser_id ON public.lease_offers USING btree (leaser_id);


--
-- Name: index_lease_offers_on_offer_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lease_offers_on_offer_start_date ON public.lease_offers USING btree (offer_start_date);


--
-- Name: index_lease_offers_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lease_offers_on_owner_id ON public.lease_offers USING btree (owner_id);


--
-- Name: index_lease_termination_requests_on_lease_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lease_termination_requests_on_lease_id ON public.lease_termination_requests USING btree (lease_id);


--
-- Name: index_leases_on_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leases_on_active ON public.leases USING btree (active);


--
-- Name: index_leases_on_early_termination_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leases_on_early_termination_date ON public.leases USING btree (early_termination_date);


--
-- Name: index_leases_on_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leases_on_end_date ON public.leases USING btree (end_date);


--
-- Name: index_leases_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_leases_on_horse_id ON public.leases USING btree (horse_id) WHERE (active = true);


--
-- Name: index_leases_on_leaser_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leases_on_leaser_id ON public.leases USING btree (leaser_id);


--
-- Name: index_leases_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leases_on_owner_id ON public.leases USING btree (owner_id);


--
-- Name: index_leases_on_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leases_on_start_date ON public.leases USING btree (start_date);


--
-- Name: index_lifetime_race_records_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lifetime_race_records_on_horse_id ON public.lifetime_race_records USING btree (horse_id);


--
-- Name: index_locations_on_country_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_country_and_name ON public.locations USING btree (country, name);


--
-- Name: index_locations_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_locations_on_name ON public.locations USING btree (name);


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
-- Name: index_notifications_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_user_id ON public.notifications USING btree (user_id);


--
-- Name: index_race_entries_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_date ON public.race_entries USING btree (date);


--
-- Name: index_race_entries_on_equipment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_equipment ON public.race_entries USING btree (equipment);


--
-- Name: index_race_entries_on_first_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_first_jockey_id ON public.race_entries USING btree (first_jockey_id);


--
-- Name: index_race_entries_on_horse_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_race_entries_on_horse_id_and_date ON public.race_entries USING btree (horse_id, date);


--
-- Name: index_race_entries_on_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_jockey_id ON public.race_entries USING btree (jockey_id);


--
-- Name: index_race_entries_on_odd_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_odd_id ON public.race_entries USING btree (odd_id);


--
-- Name: index_race_entries_on_post_parade; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_post_parade ON public.race_entries USING btree (post_parade);


--
-- Name: index_race_entries_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_race_id ON public.race_entries USING btree (race_id);


--
-- Name: index_race_entries_on_racing_style; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_racing_style ON public.race_entries USING btree (racing_style);


--
-- Name: index_race_entries_on_second_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_second_jockey_id ON public.race_entries USING btree (second_jockey_id);


--
-- Name: index_race_entries_on_third_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_entries_on_third_jockey_id ON public.race_entries USING btree (third_jockey_id);


--
-- Name: index_race_odds_on_display; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_odds_on_display ON public.race_odds USING btree (display);


--
-- Name: index_race_options_on_calculated_maximum_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_calculated_maximum_distance ON public.race_options USING btree (calculated_maximum_distance);


--
-- Name: index_race_options_on_calculated_minimum_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_calculated_minimum_distance ON public.race_options USING btree (calculated_minimum_distance);


--
-- Name: index_race_options_on_first_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_first_jockey_id ON public.race_options USING btree (first_jockey_id);


--
-- Name: index_race_options_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_race_options_on_horse_id ON public.race_options USING btree (horse_id);


--
-- Name: index_race_options_on_maximum_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_maximum_distance ON public.race_options USING btree (maximum_distance);


--
-- Name: index_race_options_on_minimum_distance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_minimum_distance ON public.race_options USING btree (minimum_distance);


--
-- Name: index_race_options_on_next_race_note_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_next_race_note_created_at ON public.race_options USING btree (next_race_note_created_at);


--
-- Name: index_race_options_on_racehorse_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_racehorse_type ON public.race_options USING btree (racehorse_type);


--
-- Name: index_race_options_on_racing_style; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_racing_style ON public.race_options USING btree (racing_style);


--
-- Name: index_race_options_on_second_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_second_jockey_id ON public.race_options USING btree (second_jockey_id);


--
-- Name: index_race_options_on_third_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_options_on_third_jockey_id ON public.race_options USING btree (third_jockey_id);


--
-- Name: index_race_qualifications_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_race_qualifications_on_horse_id ON public.race_qualifications USING btree (horse_id);


--
-- Name: index_race_records_on_horse_id_and_year_and_result_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_race_records_on_horse_id_and_year_and_result_type ON public.race_records USING btree (horse_id, year, result_type);


--
-- Name: index_race_records_on_result_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_records_on_result_type ON public.race_records USING btree (result_type);


--
-- Name: index_race_records_on_stakes_starts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_records_on_stakes_starts ON public.race_records USING btree (stakes_starts);


--
-- Name: index_race_records_on_stakes_wins; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_records_on_stakes_wins ON public.race_records USING btree (stakes_wins);


--
-- Name: index_race_records_on_starts; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_records_on_starts ON public.race_records USING btree (starts);


--
-- Name: index_race_records_on_wins; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_records_on_wins ON public.race_records USING btree (wins);


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
-- Name: index_race_results_on_grade; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_grade ON public.race_results USING btree (grade);


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
-- Name: index_race_results_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_race_results_on_slug ON public.race_results USING btree (slug);


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
-- Name: index_racehorse_metadata_on_at_home; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_at_home ON public.racehorse_metadata USING btree (at_home);


--
-- Name: index_racehorse_metadata_on_energy_grade; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_energy_grade ON public.racehorse_metadata USING btree (energy_grade);


--
-- Name: index_racehorse_metadata_on_fitness_grade; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_fitness_grade ON public.racehorse_metadata USING btree (fitness_grade);


--
-- Name: index_racehorse_metadata_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_racehorse_metadata_on_horse_id ON public.racehorse_metadata USING btree (horse_id);


--
-- Name: index_racehorse_metadata_on_in_transit; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_in_transit ON public.racehorse_metadata USING btree (in_transit);


--
-- Name: index_racehorse_metadata_on_last_raced_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_last_raced_at ON public.racehorse_metadata USING btree (last_raced_at);


--
-- Name: index_racehorse_metadata_on_last_rested_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_last_rested_at ON public.racehorse_metadata USING btree (last_rested_at);


--
-- Name: index_racehorse_metadata_on_last_shipped_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_last_shipped_at ON public.racehorse_metadata USING btree (last_shipped_at);


--
-- Name: index_racehorse_metadata_on_racetrack_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_racetrack_id ON public.racehorse_metadata USING btree (racetrack_id);


--
-- Name: index_racehorse_metadata_on_rest_days_since_last_race; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_rest_days_since_last_race ON public.racehorse_metadata USING btree (rest_days_since_last_race);


--
-- Name: index_racehorse_metadata_on_workouts_since_last_race; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_metadata_on_workouts_since_last_race ON public.racehorse_metadata USING btree (workouts_since_last_race);


--
-- Name: index_racehorse_shipments_on_arrival_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_shipments_on_arrival_date ON public.racehorse_shipments USING btree (arrival_date);


--
-- Name: index_racehorse_shipments_on_ending_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_shipments_on_ending_location_id ON public.racehorse_shipments USING btree (ending_location_id);


--
-- Name: index_racehorse_shipments_on_horse_id_and_departure_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_racehorse_shipments_on_horse_id_and_departure_date ON public.racehorse_shipments USING btree (horse_id, departure_date);


--
-- Name: index_racehorse_shipments_on_mode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_shipments_on_mode ON public.racehorse_shipments USING btree (mode);


--
-- Name: index_racehorse_shipments_on_shipping_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_shipments_on_shipping_type ON public.racehorse_shipments USING btree (shipping_type);


--
-- Name: index_racehorse_shipments_on_starting_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racehorse_shipments_on_starting_location_id ON public.racehorse_shipments USING btree (starting_location_id);


--
-- Name: index_racetracks_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_racetracks_on_location_id ON public.racetracks USING btree (location_id);


--
-- Name: index_racetracks_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_racetracks_on_name ON public.racetracks USING btree (lower((name)::text));


--
-- Name: index_racetracks_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racetracks_on_public_id ON public.racetracks USING btree (public_id);


--
-- Name: index_racetracks_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_racetracks_on_slug ON public.racetracks USING btree (slug);


--
-- Name: index_racing_stats_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_racing_stats_on_horse_id ON public.racing_stats USING btree (horse_id);


--
-- Name: index_sale_offers_on_buyer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sale_offers_on_buyer_id ON public.sale_offers USING btree (buyer_id);


--
-- Name: index_sale_offers_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sale_offers_on_horse_id ON public.sale_offers USING btree (horse_id);


--
-- Name: index_sale_offers_on_offer_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sale_offers_on_offer_start_date ON public.sale_offers USING btree (offer_start_date);


--
-- Name: index_sale_offers_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sale_offers_on_owner_id ON public.sale_offers USING btree (owner_id);


--
-- Name: index_sessions_on_old_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_old_id ON public.sessions USING btree (old_id);


--
-- Name: index_sessions_on_old_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_old_user_id ON public.sessions USING btree (old_user_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_session_id ON public.sessions USING btree (session_id);


--
-- Name: index_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_user_id ON public.sessions USING btree (user_id);


--
-- Name: index_settings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_settings_on_user_id ON public.settings USING btree (user_id);


--
-- Name: index_shipment_routes_on_air_days; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shipment_routes_on_air_days ON public.shipment_routes USING btree (air_days);


--
-- Name: index_shipment_routes_on_ending_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shipment_routes_on_ending_location_id ON public.shipment_routes USING btree (ending_location_id);


--
-- Name: index_shipment_routes_on_road_days; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shipment_routes_on_road_days ON public.shipment_routes USING btree (road_days);


--
-- Name: index_stables_on_available_balance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_available_balance ON public.stables USING btree (available_balance);


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
-- Name: index_stables_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_public_id ON public.stables USING btree (public_id);


--
-- Name: index_stables_on_racetrack_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_racetrack_id ON public.stables USING btree (racetrack_id);


--
-- Name: index_stables_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_slug ON public.stables USING btree (slug);


--
-- Name: index_stables_on_total_balance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stables_on_total_balance ON public.stables USING btree (total_balance);


--
-- Name: index_stables_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_stables_on_user_id ON public.stables USING btree (user_id);


--
-- Name: index_stud_foal_records_on_born_foals_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stud_foal_records_on_born_foals_count ON public.stud_foal_records USING btree (born_foals_count);


--
-- Name: index_stud_foal_records_on_horse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_stud_foal_records_on_horse_id ON public.stud_foal_records USING btree (horse_id);


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
-- Name: index_users_on_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_admin ON public.users USING btree (admin) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_users_on_developer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_developer ON public.users USING btree (developer) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_users_on_discourse_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_discourse_id ON public.users USING btree (discourse_id) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_name ON public.users USING btree (name) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_users_on_public_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_public_id ON public.users USING btree (public_id) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_slug ON public.users USING btree (slug) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username) WHERE (discarded_at IS NOT NULL);


--
-- Name: index_workout_comments_on_stat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workout_comments_on_stat ON public.workout_comments USING btree (stat);


--
-- Name: index_workout_comments_on_stat_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workout_comments_on_stat_value ON public.workout_comments USING btree (stat_value);


--
-- Name: index_workouts_on_activity1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_activity1 ON public.workouts USING btree (activity1);


--
-- Name: index_workouts_on_activity1_time_in_seconds; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_activity1_time_in_seconds ON public.workouts USING btree (activity1_time_in_seconds);


--
-- Name: index_workouts_on_activity2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_activity2 ON public.workouts USING btree (activity2);


--
-- Name: index_workouts_on_activity2_time_in_seconds; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_activity2_time_in_seconds ON public.workouts USING btree (activity2_time_in_seconds);


--
-- Name: index_workouts_on_activity3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_activity3 ON public.workouts USING btree (activity3);


--
-- Name: index_workouts_on_activity3_time_in_seconds; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_activity3_time_in_seconds ON public.workouts USING btree (activity3_time_in_seconds);


--
-- Name: index_workouts_on_comment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_comment_id ON public.workouts USING btree (comment_id);


--
-- Name: index_workouts_on_condition; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_condition ON public.workouts USING btree (condition);


--
-- Name: index_workouts_on_confidence; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_confidence ON public.workouts USING btree (confidence);


--
-- Name: index_workouts_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_date ON public.workouts USING btree (date);


--
-- Name: index_workouts_on_distance1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_distance1 ON public.workouts USING btree (distance1);


--
-- Name: index_workouts_on_distance2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_distance2 ON public.workouts USING btree (distance2);


--
-- Name: index_workouts_on_distance3; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_distance3 ON public.workouts USING btree (distance3);


--
-- Name: index_workouts_on_effort; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_effort ON public.workouts USING btree (effort);


--
-- Name: index_workouts_on_equipment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_equipment ON public.workouts USING btree (equipment);


--
-- Name: index_workouts_on_horse_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_workouts_on_horse_id_and_date ON public.workouts USING btree (horse_id, date);


--
-- Name: index_workouts_on_jockey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_jockey_id ON public.workouts USING btree (jockey_id);


--
-- Name: index_workouts_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_location_id ON public.workouts USING btree (location_id);


--
-- Name: index_workouts_on_racetrack_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_racetrack_id ON public.workouts USING btree (racetrack_id);


--
-- Name: index_workouts_on_rank; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_rank ON public.workouts USING btree (rank);


--
-- Name: index_workouts_on_surface_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_surface_id ON public.workouts USING btree (surface_id);


--
-- Name: index_workouts_on_time_in_seconds; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_time_in_seconds ON public.workouts USING btree (time_in_seconds);


--
-- Name: index_workouts_on_total_time_in_seconds; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workouts_on_total_time_in_seconds ON public.workouts USING btree (total_time_in_seconds);


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
-- Name: race_options fk_rails_01f82343eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_options
    ADD CONSTRAINT fk_rails_01f82343eb FOREIGN KEY (second_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: workouts fk_rails_049e476bcd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT fk_rails_049e476bcd FOREIGN KEY (jockey_id) REFERENCES public.jockeys(id);


--
-- Name: race_results fk_rails_06818a8fab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_results
    ADD CONSTRAINT fk_rails_06818a8fab FOREIGN KEY (surface_id) REFERENCES public.track_surfaces(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: race_schedules fk_rails_0831641203; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_schedules
    ADD CONSTRAINT fk_rails_0831641203 FOREIGN KEY (surface_id) REFERENCES public.track_surfaces(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sale_offers fk_rails_09052401bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_offers
    ADD CONSTRAINT fk_rails_09052401bc FOREIGN KEY (owner_id) REFERENCES public.stables(id);


--
-- Name: horse_sales fk_rails_0b809fb199; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_sales
    ADD CONSTRAINT fk_rails_0b809fb199 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: race_entries fk_rails_0d25b537c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries
    ADD CONSTRAINT fk_rails_0d25b537c4 FOREIGN KEY (jockey_id) REFERENCES public.jockeys(id);


--
-- Name: auction_horses fk_rails_0ff758e7f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_horses
    ADD CONSTRAINT fk_rails_0ff758e7f8 FOREIGN KEY (auction_id) REFERENCES public.auctions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: horse_genetics fk_rails_10e493203b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_genetics
    ADD CONSTRAINT fk_rails_10e493203b FOREIGN KEY (horse_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: racehorse_shipments fk_rails_11743aea75; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_shipments
    ADD CONSTRAINT fk_rails_11743aea75 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: workouts fk_rails_1177451f68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT fk_rails_1177451f68 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: shipment_routes fk_rails_132893d71e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_routes
    ADD CONSTRAINT fk_rails_132893d71e FOREIGN KEY (starting_location_id) REFERENCES public.locations(id);


--
-- Name: race_result_horses fk_rails_1fdef5dc32; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT fk_rails_1fdef5dc32 FOREIGN KEY (race_id) REFERENCES public.race_results(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: racehorse_metadata fk_rails_2685265a1f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_metadata
    ADD CONSTRAINT fk_rails_2685265a1f FOREIGN KEY (racetrack_id) REFERENCES public.racetracks(id);


--
-- Name: user_push_subscriptions fk_rails_2762779401; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_push_subscriptions
    ADD CONSTRAINT fk_rails_2762779401 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: future_race_entries fk_rails_2947652e21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.future_race_entries
    ADD CONSTRAINT fk_rails_2947652e21 FOREIGN KEY (first_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: auction_consignment_configs fk_rails_2d96c0c08a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_consignment_configs
    ADD CONSTRAINT fk_rails_2d96c0c08a FOREIGN KEY (auction_id) REFERENCES public.auctions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: future_race_entries fk_rails_30632c54bf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.future_race_entries
    ADD CONSTRAINT fk_rails_30632c54bf FOREIGN KEY (third_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: stables fk_rails_337ce4ea4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stables
    ADD CONSTRAINT fk_rails_337ce4ea4d FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: racehorse_shipments fk_rails_3480687307; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_shipments
    ADD CONSTRAINT fk_rails_3480687307 FOREIGN KEY (starting_location_id) REFERENCES public.locations(id);


--
-- Name: race_options fk_rails_380027c283; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_options
    ADD CONSTRAINT fk_rails_380027c283 FOREIGN KEY (third_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: motor_alert_locks fk_rails_38d1b2960e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_alert_locks
    ADD CONSTRAINT fk_rails_38d1b2960e FOREIGN KEY (alert_id) REFERENCES public.motor_alerts(id);


--
-- Name: injuries fk_rails_3f46265a72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.injuries
    ADD CONSTRAINT fk_rails_3f46265a72 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: lease_termination_requests fk_rails_413af159d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_termination_requests
    ADD CONSTRAINT fk_rails_413af159d7 FOREIGN KEY (lease_id) REFERENCES public.leases(id);


--
-- Name: workouts fk_rails_41bba41962; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT fk_rails_41bba41962 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: broodmare_shipments fk_rails_4b660bbb6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_shipments
    ADD CONSTRAINT fk_rails_4b660bbb6a FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: leases fk_rails_53972bd5e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leases
    ADD CONSTRAINT fk_rails_53972bd5e0 FOREIGN KEY (owner_id) REFERENCES public.stables(id);


--
-- Name: horse_jockey_relationships fk_rails_54ae17d60f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_jockey_relationships
    ADD CONSTRAINT fk_rails_54ae17d60f FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: settings fk_rails_5676777bf1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT fk_rails_5676777bf1 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: training_schedules_horses fk_rails_5699b9eba5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules_horses
    ADD CONSTRAINT fk_rails_5699b9eba5 FOREIGN KEY (horse_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sale_offers fk_rails_58132ad6b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_offers
    ADD CONSTRAINT fk_rails_58132ad6b6 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: race_result_horses fk_rails_5a43ac707f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT fk_rails_5a43ac707f FOREIGN KEY (horse_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: budget_transactions fk_rails_5fead07b30; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.budget_transactions
    ADD CONSTRAINT fk_rails_5fead07b30 FOREIGN KEY (stable_id) REFERENCES public.stables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: racehorse_shipments fk_rails_61598134a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_shipments
    ADD CONSTRAINT fk_rails_61598134a3 FOREIGN KEY (ending_location_id) REFERENCES public.locations(id);


--
-- Name: workouts fk_rails_62b0d2407d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT fk_rails_62b0d2407d FOREIGN KEY (comment_id) REFERENCES public.workout_comments(id);


--
-- Name: auction_horses fk_rails_68ba859655; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_horses
    ADD CONSTRAINT fk_rails_68ba859655 FOREIGN KEY (horse_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stables fk_rails_6c0fff5a3e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stables
    ADD CONSTRAINT fk_rails_6c0fff5a3e FOREIGN KEY (racetrack_id) REFERENCES public.racetracks(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: racetracks fk_rails_7135862009; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racetracks
    ADD CONSTRAINT fk_rails_7135862009 FOREIGN KEY (location_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: race_result_horses fk_rails_7254168319; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT fk_rails_7254168319 FOREIGN KEY (odd_id) REFERENCES public.race_results(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: sale_offers fk_rails_7486325072; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sale_offers
    ADD CONSTRAINT fk_rails_7486325072 FOREIGN KEY (buyer_id) REFERENCES public.stables(id);


--
-- Name: broodmare_shipments fk_rails_7e5650d355; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_shipments
    ADD CONSTRAINT fk_rails_7e5650d355 FOREIGN KEY (starting_farm_id) REFERENCES public.stables(id);


--
-- Name: future_race_entries fk_rails_83ce026761; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.future_race_entries
    ADD CONSTRAINT fk_rails_83ce026761 FOREIGN KEY (second_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: horses fk_rails_86505356a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_86505356a0 FOREIGN KEY (leaser_id) REFERENCES public.stables(id);


--
-- Name: race_entries fk_rails_8658d2cce7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries
    ADD CONSTRAINT fk_rails_8658d2cce7 FOREIGN KEY (first_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: motor_alerts fk_rails_8828951644; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_alerts
    ADD CONSTRAINT fk_rails_8828951644 FOREIGN KEY (query_id) REFERENCES public.motor_queries(id);


--
-- Name: track_surfaces fk_rails_8a3fdd3bd1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track_surfaces
    ADD CONSTRAINT fk_rails_8a3fdd3bd1 FOREIGN KEY (racetrack_id) REFERENCES public.racetracks(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: race_entries fk_rails_8a4149a29a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries
    ADD CONSTRAINT fk_rails_8a4149a29a FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: racing_stats fk_rails_8a43836593; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racing_stats
    ADD CONSTRAINT fk_rails_8a43836593 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: boardings fk_rails_91c5c287e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boardings
    ADD CONSTRAINT fk_rails_91c5c287e6 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: race_entries fk_rails_925294d708; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries
    ADD CONSTRAINT fk_rails_925294d708 FOREIGN KEY (odd_id) REFERENCES public.race_odds(id);


--
-- Name: stud_foal_records fk_rails_97dfbe062f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stud_foal_records
    ADD CONSTRAINT fk_rails_97dfbe062f FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: horses fk_rails_99146e7c92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_99146e7c92 FOREIGN KEY (owner_id) REFERENCES public.stables(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: activity_points fk_rails_9921842c69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_points
    ADD CONSTRAINT fk_rails_9921842c69 FOREIGN KEY (budget_id) REFERENCES public.budget_transactions(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: horse_sales fk_rails_9e272e949b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_sales
    ADD CONSTRAINT fk_rails_9e272e949b FOREIGN KEY (seller_id) REFERENCES public.stables(id);


--
-- Name: activity_points fk_rails_a3b05b12f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_points
    ADD CONSTRAINT fk_rails_a3b05b12f2 FOREIGN KEY (stable_id) REFERENCES public.stables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: training_schedules_horses fk_rails_a48e7af8f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules_horses
    ADD CONSTRAINT fk_rails_a48e7af8f9 FOREIGN KEY (training_schedule_id) REFERENCES public.training_schedules(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: future_race_entries fk_rails_a52f4526d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.future_race_entries
    ADD CONSTRAINT fk_rails_a52f4526d8 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: auction_bids fk_rails_a66160d8e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_bids
    ADD CONSTRAINT fk_rails_a66160d8e4 FOREIGN KEY (auction_id) REFERENCES public.auctions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: horse_attributes fk_rails_a783c29acc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_attributes
    ADD CONSTRAINT fk_rails_a783c29acc FOREIGN KEY (horse_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: race_options fk_rails_a899329ee8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_options
    ADD CONSTRAINT fk_rails_a899329ee8 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: broodmare_shipments fk_rails_a92440001b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_shipments
    ADD CONSTRAINT fk_rails_a92440001b FOREIGN KEY (ending_farm_id) REFERENCES public.stables(id);


--
-- Name: auction_bids fk_rails_ad9350f9f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_bids
    ADD CONSTRAINT fk_rails_ad9350f9f6 FOREIGN KEY (bidder_id) REFERENCES public.stables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: notifications fk_rails_b080fb4855; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_rails_b080fb4855 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: horses fk_rails_b1757e50ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_b1757e50ec FOREIGN KEY (breeder_id) REFERENCES public.stables(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT VALID;


--
-- Name: leases fk_rails_b1c449ef3a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leases
    ADD CONSTRAINT fk_rails_b1c449ef3a FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: lease_offers fk_rails_b25d1a1f1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_offers
    ADD CONSTRAINT fk_rails_b25d1a1f1b FOREIGN KEY (owner_id) REFERENCES public.stables(id);


--
-- Name: horse_sales fk_rails_b43ef5c431; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_sales
    ADD CONSTRAINT fk_rails_b43ef5c431 FOREIGN KEY (buyer_id) REFERENCES public.stables(id);


--
-- Name: boardings fk_rails_b7a9ec2495; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boardings
    ADD CONSTRAINT fk_rails_b7a9ec2495 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: motor_taggable_tags fk_rails_ba9ebe2280; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_taggable_tags
    ADD CONSTRAINT fk_rails_ba9ebe2280 FOREIGN KEY (tag_id) REFERENCES public.motor_tags(id);


--
-- Name: race_records fk_rails_c25fca6795; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_records
    ADD CONSTRAINT fk_rails_c25fca6795 FOREIGN KEY (horse_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: racehorse_metadata fk_rails_c4775ac331; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.racehorse_metadata
    ADD CONSTRAINT fk_rails_c4775ac331 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: training_schedules fk_rails_c52806e045; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.training_schedules
    ADD CONSTRAINT fk_rails_c52806e045 FOREIGN KEY (stable_id) REFERENCES public.stables(id) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


--
-- Name: auction_bids fk_rails_c7783844e2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_bids
    ADD CONSTRAINT fk_rails_c7783844e2 FOREIGN KEY (horse_id) REFERENCES public.auction_horses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: activations fk_rails_c968676a56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activations
    ADD CONSTRAINT fk_rails_c968676a56 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auction_horses fk_rails_cb41915e73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_horses
    ADD CONSTRAINT fk_rails_cb41915e73 FOREIGN KEY (seller_id) REFERENCES public.stables(id);


--
-- Name: horses fk_rails_d484f5dff4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_d484f5dff4 FOREIGN KEY (sire_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: future_race_entries fk_rails_de9df9406c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.future_race_entries
    ADD CONSTRAINT fk_rails_de9df9406c FOREIGN KEY (race_id) REFERENCES public.race_schedules(id);


--
-- Name: leases fk_rails_e02745fa92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leases
    ADD CONSTRAINT fk_rails_e02745fa92 FOREIGN KEY (leaser_id) REFERENCES public.stables(id);


--
-- Name: race_entries fk_rails_e0db8a9c1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries
    ADD CONSTRAINT fk_rails_e0db8a9c1c FOREIGN KEY (third_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: shipment_routes fk_rails_e3744a828e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shipment_routes
    ADD CONSTRAINT fk_rails_e3744a828e FOREIGN KEY (ending_location_id) REFERENCES public.locations(id);


--
-- Name: lease_offers fk_rails_e4810d6ca8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_offers
    ADD CONSTRAINT fk_rails_e4810d6ca8 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: historical_injuries fk_rails_e4cca4bab6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historical_injuries
    ADD CONSTRAINT fk_rails_e4cca4bab6 FOREIGN KEY (horse_id) REFERENCES public.horses(id);


--
-- Name: horses fk_rails_e50f0d1f41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_e50f0d1f41 FOREIGN KEY (location_bred_id) REFERENCES public.locations(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: race_options fk_rails_e55e3a4cf5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_options
    ADD CONSTRAINT fk_rails_e55e3a4cf5 FOREIGN KEY (first_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: horse_jockey_relationships fk_rails_e6dddc69ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_jockey_relationships
    ADD CONSTRAINT fk_rails_e6dddc69ab FOREIGN KEY (jockey_id) REFERENCES public.jockeys(id);


--
-- Name: race_entries fk_rails_ea1274a9a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries
    ADD CONSTRAINT fk_rails_ea1274a9a3 FOREIGN KEY (race_id) REFERENCES public.race_schedules(id);


--
-- Name: auctions fk_rails_eb22f53e21; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auctions
    ADD CONSTRAINT fk_rails_eb22f53e21 FOREIGN KEY (auctioneer_id) REFERENCES public.stables(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: horse_appearances fk_rails_edfc2b0987; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horse_appearances
    ADD CONSTRAINT fk_rails_edfc2b0987 FOREIGN KEY (horse_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: auction_horses fk_rails_ee9966d91f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.auction_horses
    ADD CONSTRAINT fk_rails_ee9966d91f FOREIGN KEY (buyer_id) REFERENCES public.stables(id);


--
-- Name: broodmare_foal_records fk_rails_f03f5afd0c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broodmare_foal_records
    ADD CONSTRAINT fk_rails_f03f5afd0c FOREIGN KEY (horse_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: race_result_horses fk_rails_f05befc048; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_result_horses
    ADD CONSTRAINT fk_rails_f05befc048 FOREIGN KEY (jockey_id) REFERENCES public.jockeys(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: workouts fk_rails_f459544cd4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT fk_rails_f459544cd4 FOREIGN KEY (racetrack_id) REFERENCES public.racetracks(id);


--
-- Name: race_entries fk_rails_f7f1d20e77; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_entries
    ADD CONSTRAINT fk_rails_f7f1d20e77 FOREIGN KEY (second_jockey_id) REFERENCES public.jockeys(id);


--
-- Name: lease_offers fk_rails_fb816dc261; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lease_offers
    ADD CONSTRAINT fk_rails_fb816dc261 FOREIGN KEY (leaser_id) REFERENCES public.stables(id);


--
-- Name: horses fk_rails_fc5ea1ce34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.horses
    ADD CONSTRAINT fk_rails_fc5ea1ce34 FOREIGN KEY (dam_id) REFERENCES public.horses(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: workouts fk_rails_fd31a75744; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT fk_rails_fd31a75744 FOREIGN KEY (surface_id) REFERENCES public.track_surfaces(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260209211310'),
('20260209144047'),
('20260205135545'),
('20260123120534'),
('20260123093229'),
('20260122140512'),
('20260121202130'),
('20260121154836'),
('20260121124511'),
('20260121114008'),
('20260119143652'),
('20260107185127'),
('20260105110324'),
('20251230104641'),
('20251229150423'),
('20251203101405'),
('20251129091043'),
('20251128204314'),
('20251128200158'),
('20251126225534'),
('20251122162900'),
('20251122155624'),
('20251121104735'),
('20251120144348'),
('20251119150441'),
('20251118205558'),
('20251118164459'),
('20251118162700'),
('20251118135018'),
('20251118125017'),
('20251118103702'),
('20251115124230'),
('20251114085550'),
('20251113202832'),
('20251111175717'),
('20251109221006'),
('20251108220626'),
('20251108095210'),
('20251107213855'),
('20251106205042'),
('20251105225706'),
('20251105191035'),
('20251105190103'),
('20251104131317'),
('20251103195539'),
('20251103195523'),
('20251103132832'),
('20251103101559'),
('20251102193414'),
('20251102185333'),
('20251102180612'),
('20251102174639'),
('20251102162634'),
('20251102151433'),
('20251102145553'),
('20251102142852'),
('20251102140614'),
('20251102120401'),
('20251102115205'),
('20251101223740'),
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
('20220721204945'),
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

