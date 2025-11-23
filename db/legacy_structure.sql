-- note: only used for CI

-- -------------------------------------------------------------
-- TablePlus 6.7.1(636)
--
-- https://tableplus.com/
--
-- Database: finalfurlong
-- Generation Time: 2025-10-04 19:51:00.6790
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


CREATE TABLE `auto_entry_status` (
                                     `id` int NOT NULL AUTO_INCREMENT,
                                     `user_id` int NOT NULL,
                                     `horse_id` int NOT NULL,
                                     `status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
    `race_date` date DEFAULT NULL,
    `race_num` tinyint NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    UNIQUE KEY `horse_id` (`horse_id`,`race_date`),
    KEY `status` (`status`) USING BTREE,
    KEY `user_id` (`user_id`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=69217 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `auto_shipping_status` (
                                        `id` int NOT NULL AUTO_INCREMENT,
                                        `user_id` int NOT NULL,
                                        `horse_id` int NOT NULL,
                                        `status` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
    `ship_date` date DEFAULT NULL,
    `location` int NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `horse_id` (`horse_id`,`ship_date`),
    KEY `status` (`status`) USING BTREE,
    KEY `user_id` (`user_id`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=935 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `ff_activity` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Stable` int DEFAULT NULL,
                               `Date` date DEFAULT NULL,
                               `Type` tinyint NOT NULL DEFAULT '0',
                               `budget` int DEFAULT NULL,
                               `amount` int DEFAULT NULL,
                               `balance` int DEFAULT NULL,
                               PRIMARY KEY (`ID`),
    KEY `Stable` (`Stable`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=126233 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_activity_pts` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Keyword` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
    `1stYearPts` tinyint NOT NULL DEFAULT '0',
    `2ndYearPts` tinyint NOT NULL DEFAULT '0',
    `OtherPts` tinyint NOT NULL DEFAULT '0',
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_admin` (
                            `ID` int NOT NULL AUTO_INCREMENT,
                            `Members` int NOT NULL DEFAULT '75',
                            `StartingHorses` tinyint NOT NULL DEFAULT '1',
                            `StartingBudget` int NOT NULL DEFAULT '0',
                            `SatDeadline` date DEFAULT NULL,
                            `WedDeadline` date DEFAULT NULL,
                            `EFUpdate` date NOT NULL,
                            `RacerLimit` int NOT NULL DEFAULT '25',
                            `StudLimit` int NOT NULL DEFAULT '5',
                            `BroodmareLimit` int NOT NULL DEFAULT '25',
                            `YearlingLimit` tinyint NOT NULL DEFAULT '0',
                            `WeanlingLimit` tinyint NOT NULL DEFAULT '0',
                            `HorseLimit` int NOT NULL DEFAULT '150',
                            `NoteLimit` tinyint NOT NULL,
                            `BugPassword` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_alerts` (
                             `ID` int NOT NULL AUTO_INCREMENT,
                             `Date` date NOT NULL,
                             `Expire` date DEFAULT NULL,
                             `Alert` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
                             `Newbies` tinyint(1) NOT NULL DEFAULT '1',
    `NonNewbies` tinyint(1) NOT NULL DEFAULT '1',
    PRIMARY KEY (`ID`),
    KEY `Date` (`Date`) USING BTREE,
    KEY `Expire` (`Expire`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_auctionbids` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Auction` int NOT NULL DEFAULT '0',
                                  `Horse` int NOT NULL DEFAULT '0',
                                  `Bidder` int NOT NULL DEFAULT '0',
                                  `CurrentBid` int NOT NULL DEFAULT '0',
                                  `MaxBid` int DEFAULT NULL,
                                  `Email` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'N',
    `Message` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Time` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=7123 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_auctionhorses` (
                                    `ID` int NOT NULL AUTO_INCREMENT,
                                    `Auction` int NOT NULL DEFAULT '0',
                                    `Horse` int NOT NULL DEFAULT '0',
                                    `Reserve` int DEFAULT NULL,
                                    `Max` int DEFAULT NULL,
                                    `Comment` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Sold` tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`ID`),
    UNIQUE KEY `Auction` (`Auction`,`Horse`),
    KEY `Horse` (`Horse`) USING BTREE,
    KEY `Sold` (`Sold`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=6556 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_auctions` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
                               `End` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
                               `Auctioneer` int NOT NULL DEFAULT '0',
                               `Title` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `SellTime` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT '12',
    `AllowRes` tinyint(1) NOT NULL DEFAULT '1',
    `AllowOutside` tinyint(1) NOT NULL DEFAULT '0',
    `AllowStatus` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'All',
    `SpendingCap` int DEFAULT NULL,
    `ConsignLimit` tinyint DEFAULT NULL,
    `PerPerson` tinyint DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `End` (`End`) USING BTREE,
    KEY `Start` (`Start`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_bcstuds` (
                              `ID` int NOT NULL AUTO_INCREMENT,
                              `Stud` int DEFAULT NULL,
                              `Year` int NOT NULL DEFAULT '0',
                              PRIMARY KEY (`ID`),
    KEY `Stud` (`Stud`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=1618 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_boarding` (
                               `id` int NOT NULL AUTO_INCREMENT,
                               `horse_id` int NOT NULL,
                               `farm_id` int NOT NULL,
                               `start_date` date NOT NULL,
                               `end_date` date DEFAULT NULL,
                               `days` tinyint NOT NULL,
                               PRIMARY KEY (`id`),
    UNIQUE KEY `unique_boarding` (`horse_id`,`farm_id`,`start_date`),
    KEY `end_date` (`end_date`) USING BTREE,
    KEY `farm_id` (`farm_id`) USING BTREE,
    KEY `horse_end_date` (`horse_id`,`end_date`) USING BTREE,
    KEY `horse_id` (`horse_id`) USING BTREE,
    KEY `start_date` (`start_date`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=41721 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_breed_rankings` (
                                     `ID` int NOT NULL AUTO_INCREMENT,
                                     `Ranking` varchar(25) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `MinPts` tinyint NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_breedings` (
                                `ID` int NOT NULL AUTO_INCREMENT,
                                `Mare` int NOT NULL DEFAULT '0',
                                `Owner` int NOT NULL DEFAULT '0',
                                `Stud` int DEFAULT NULL,
                                `MareComments` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `StudComments` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Status` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'P',
    `Date` date DEFAULT NULL,
    `Due` date DEFAULT NULL,
    `CustomFee` int DEFAULT '0',
    PRIMARY KEY (`ID`),
    KEY `Mare` (`Mare`) USING BTREE,
    KEY `Stud` (`Stud`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=171577 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_budgets` (
                              `ID` int NOT NULL AUTO_INCREMENT,
                              `Stable` int DEFAULT NULL,
                              `Date` date DEFAULT NULL,
                              `Description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `Amount` int DEFAULT NULL,
    `Balance` int DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `Date` (`Date`) USING BTREE,
    KEY `description` (`Description`) USING BTREE,
    KEY `Stable` (`Stable`) USING BTREE,
    KEY `stable_date_description` (`Stable`,`Date`,`Description`) USING BTREE,
    KEY `stable_description` (`Stable`,`Description`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=2392640 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `ff_claims` (
                             `ID` int NOT NULL AUTO_INCREMENT,
                             `Date` date DEFAULT NULL,
                             `RaceDay` date DEFAULT NULL,
                             `RaceNum` int DEFAULT NULL,
                             `Horse` int DEFAULT NULL,
                             `Owner` int DEFAULT NULL,
                             `Claimer` int DEFAULT NULL,
                             `Price` int DEFAULT NULL,
                             PRIMARY KEY (`ID`),
    UNIQUE KEY `RaceDay` (`RaceDay`,`Claimer`),
    KEY `Claimer` (`Claimer`) USING BTREE,
    KEY `horse` (`Horse`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=916 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_colorwar` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Team` int NOT NULL DEFAULT '0',
                               `Activity` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Points` int NOT NULL DEFAULT '0',
    `PtsAvail` int NOT NULL DEFAULT '0',
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_comments` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Comment` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_activities` (
                                    `ID` int NOT NULL AUTO_INCREMENT,
                                    `Activity` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Start` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `End` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_entries` (
                                 `ID` int NOT NULL AUTO_INCREMENT,
                                 `Team` int NOT NULL,
                                 `Member` int NOT NULL,
                                 `Horse` int NOT NULL,
                                 `Race` int NOT NULL,
                                 `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                 PRIMARY KEY (`ID`),
    UNIQUE KEY `Horse` (`Horse`,`Race`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_guess_order` (
                                     `id` int NOT NULL AUTO_INCREMENT,
                                     `guesser_id` int NOT NULL,
                                     `last_date` date NOT NULL,
                                     `active` tinyint(1) NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_guesses` (
                                 `id` int NOT NULL AUTO_INCREMENT,
                                 `secret_id` int NOT NULL,
                                 `guesser_id` int NOT NULL,
                                 `guessed_id` int NOT NULL,
                                 `correct` tinyint(1) NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_prize_offers` (
                                      `id` int NOT NULL AUTO_INCREMENT,
                                      `year` char(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `user_id` int NOT NULL,
    `horse_id` int NOT NULL,
    PRIMARY KEY (`id`),
    KEY `user_horse` (`user_id`,`horse_id`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf32 COLLATE=utf32_unicode_ci;

CREATE TABLE `ff_cw_prizes` (
                                `id` int NOT NULL AUTO_INCREMENT,
                                `year` char(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `user_id` int NOT NULL,
    `type` tinyint NOT NULL,
    `value` int NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=863 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_race_votes` (
                                    `ID` int NOT NULL AUTO_INCREMENT,
                                    `Team` int NOT NULL,
                                    `Entry` int NOT NULL,
                                    `Member` int NOT NULL,
                                    `Vote` tinyint(1) NOT NULL,
    `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_results` (
                                 `id` int NOT NULL AUTO_INCREMENT,
                                 `year` char(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `user_id` int NOT NULL,
    `position` tinyint NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `year` (`year`,`user_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_scores` (
                                `ID` int NOT NULL AUTO_INCREMENT,
                                `Team` int NOT NULL,
                                `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                `Activity` int NOT NULL,
                                `Description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Points` int NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_secrets` (
                                 `member_id` int NOT NULL,
                                 `secret` mediumtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                                 `guessed` tinyint(1) NOT NULL,
    `guesser_id` int NOT NULL,
    `active` tinyint(1) NOT NULL,
    PRIMARY KEY (`member_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_settings` (
                                  `id` int NOT NULL AUTO_INCREMENT,
                                  `name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `value` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_signups` (
                                 `id` int NOT NULL AUTO_INCREMENT,
                                 `year` int NOT NULL,
                                 `user_id` int NOT NULL,
                                 `captain` tinyint NOT NULL,
                                 `date` date NOT NULL,
                                 PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_cw_teams` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Team` int NOT NULL,
                               `Member` int NOT NULL,
                               `Captain` tinyint(1) NOT NULL DEFAULT '0',
    `Start` timestamp NOT NULL DEFAULT '2012-02-19 19:00:00',
    `End` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
    PRIMARY KEY (`ID`),
    KEY `Member` (`Member`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_deleted_stables` (
                                      `id` int NOT NULL,
                                      `date` date NOT NULL,
                                      `balance` int NOT NULL,
                                      `horses` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                                      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_distinct_errors` (
                                      `error_details` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
                                      `error_file` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
    `error_line` int DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_donations` (
                                `txn_id` varchar(19) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `user_id` int NOT NULL,
    `amount` float(9,2) NOT NULL,
    `date` date NOT NULL,
    PRIMARY KEY (`txn_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_equipment` (
                                `ID` int NOT NULL AUTO_INCREMENT,
                                `Equipment` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `equipment` (`Equipment`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_faq` (
                          `ID` int NOT NULL AUTO_INCREMENT,
                          `Category` tinyint NOT NULL DEFAULT '0',
                          `Question` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                          `Answer` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                          PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_faq_answers` (
                                  `id` int NOT NULL AUTO_INCREMENT,
                                  `category` tinyint NOT NULL,
                                  `question` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `answer` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `order` tinyint NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_faq_articles` (
                                   `FileID` int unsigned NOT NULL AUTO_INCREMENT,
                                   `ParentID` tinyint unsigned NOT NULL DEFAULT '0',
                                   `Title` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `AuthorID` tinyint unsigned NOT NULL DEFAULT '0',
    `CatID` tinyint unsigned NOT NULL DEFAULT '0',
    `Category` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Keywords` varchar(80) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Articledata` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci,
    `Approved` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT 'N',
    `Views` int DEFAULT '0',
    `RatingTotal` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
    `RatedTotal` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
    `SubmitDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`FileID`),
    KEY `Keywords` (`Keywords`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_faq_categories` (
                                     `id` int unsigned NOT NULL AUTO_INCREMENT,
                                     `category` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `parent` tinyint NOT NULL DEFAULT '0',
    `approved` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT 'Y',
    PRIMARY KEY (`id`),
    KEY `parent_search` (`parent`,`approved`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_faq_questions` (
                                    `QuestionID` int NOT NULL AUTO_INCREMENT,
                                    `Question` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                                    `Name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Email` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Respond` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'N',
    PRIMARY KEY (`QuestionID`),
    KEY `Name` (`Name`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_farms` (
                            `id` int NOT NULL AUTO_INCREMENT,
                            `track_id` int NOT NULL,
                            PRIMARY KEY (`id`),
    UNIQUE KEY `track_id` (`track_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_foalrecords` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Horse` int NOT NULL DEFAULT '0',
                                  `DC` enum('B','I','C','S','P') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'B',
    `Starts` int NOT NULL DEFAULT '0',
    `Stakes` int NOT NULL DEFAULT '0',
    `Wins` int NOT NULL DEFAULT '0',
    `StakesWn` int NOT NULL DEFAULT '0',
    `Seconds` int NOT NULL DEFAULT '0',
    `StakesSds` int NOT NULL DEFAULT '0',
    `Thirds` int NOT NULL DEFAULT '0',
    `StakesTds` int NOT NULL DEFAULT '0',
    `Fourths` int NOT NULL DEFAULT '0',
    `StakesFs` int NOT NULL DEFAULT '0',
    `Points` int NOT NULL DEFAULT '0',
    `Earnings` int NOT NULL DEFAULT '0',
    `FlatSC` enum('F','SC') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'F',
    PRIMARY KEY (`ID`),
    KEY `DC` (`DC`) USING BTREE,
    KEY `Horse` (`Horse`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=692899 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_futureentries` (
                                    `ID` int NOT NULL AUTO_INCREMENT,
                                    `DateEntered` datetime NOT NULL,
                                    `Race` int NOT NULL DEFAULT '0',
                                    `Horse` int NOT NULL DEFAULT '0',
                                    `Equipment` tinyint DEFAULT NULL,
                                    `Jockey` tinyint DEFAULT NULL,
                                    `Jock2` tinyint DEFAULT NULL,
                                    `Jock3` tinyint DEFAULT NULL,
                                    `Instructions` tinyint DEFAULT NULL,
                                    `AutoEnter` tinyint(1) NOT NULL DEFAULT '0',
    `AutoShip` tinyint(1) NOT NULL DEFAULT '0',
    `ShipMethod` enum('R','A','*') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'R',
    `RaceDate` date DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `HorseRace` (`Horse`,`Race`)
    ) ENGINE=InnoDB AUTO_INCREMENT=74922 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_futureevents` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Horse` int DEFAULT NULL,
                                   `Date` date DEFAULT NULL,
                                   `Event` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `event_search` (`Event`,`Date`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=741 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_futureshipping` (
                                     `ID` int NOT NULL AUTO_INCREMENT,
                                     `Horse` int NOT NULL,
                                     `ToTrack` int DEFAULT NULL,
                                     `ToFarm` int DEFAULT NULL,
                                     `Mode` enum('R','A','*') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'R' COMMENT '* = choose best method',
    `Date` date NOT NULL,
    `RaceLink` int DEFAULT NULL,
    `Status` enum('S','P','D') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'S',
    PRIMARY KEY (`ID`),
    UNIQUE KEY `Horse` (`Horse`,`ToTrack`,`Date`)
    ) ENGINE=InnoDB AUTO_INCREMENT=5060 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_brankings` (
                                      `Horse` int NOT NULL,
                                      `Ranking` int NOT NULL,
                                      `Points` int NOT NULL DEFAULT '0',
                                      `Foals` int NOT NULL DEFAULT '0',
                                      `Races` int NOT NULL,
                                      PRIMARY KEY (`Horse`),
    KEY `idx_points` (`Points`) USING BTREE,
    KEY `idx_ranking` (`Ranking`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_bsrankings` (
                                       `Horse` int NOT NULL,
                                       `Ranking` int NOT NULL,
                                       `Points` int NOT NULL DEFAULT '0',
                                       `Foals` int NOT NULL DEFAULT '0',
                                       `Races` int NOT NULL,
                                       PRIMARY KEY (`Horse`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_colors` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Color` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Abbr` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_comments` (
                                     `ID` int NOT NULL AUTO_INCREMENT,
                                     `Horse` int NOT NULL,
                                     `CommentID` tinyint NOT NULL DEFAULT '0',
                                     PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_events` (
                                   `id` int NOT NULL AUTO_INCREMENT,
                                   `event` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_history` (
                                    `id` int NOT NULL AUTO_INCREMENT,
                                    `horseId` int NOT NULL,
                                    `eventId` tinyint NOT NULL,
                                    `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                    `value` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `horseId` (`horseId`,`eventId`,`date`)
    ) ENGINE=InnoDB AUTO_INCREMENT=73754 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_injuries` (
                                     `ID` int NOT NULL AUTO_INCREMENT,
                                     `Horse` int NOT NULL,
                                     `Injury` tinyint NOT NULL,
                                     `Date` date NOT NULL,
                                     `Leg` varchar(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `Date` (`Date`) USING BTREE,
    KEY `date_horse` (`Date`,`Horse`) USING BTREE,
    KEY `Horse` (`Horse`) USING BTREE,
    KEY `Horse_2` (`Horse`,`Injury`) USING BTREE,
    KEY `horse_date` (`Horse`,`Date`) USING BTREE,
    KEY `Injury` (`Injury`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=26183 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_jockeys` (
                                    `ID` int NOT NULL AUTO_INCREMENT,
                                    `Horse` int NOT NULL DEFAULT '0',
                                    `Jockey` int NOT NULL DEFAULT '0',
                                    `XP` tinyint NOT NULL DEFAULT '0',
                                    `Happy` tinyint NOT NULL DEFAULT '0',
                                    PRIMARY KEY (`ID`),
    KEY `Horse` (`Horse`,`Jockey`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=927276 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_latest_claiming_race` (
                                                 `id` int NOT NULL AUTO_INCREMENT,
                                                 `horse` int NOT NULL,
                                                 `race_id` int NOT NULL,
                                                 `date` date NOT NULL,
                                                 PRIMARY KEY (`id`),
    UNIQUE KEY `Horse` (`horse`),
    KEY `race` (`race_id`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=4001 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_latest_injuries` (
                                            `ID` int NOT NULL AUTO_INCREMENT,
                                            `Horse` int NOT NULL,
                                            `Injury` tinyint NOT NULL,
                                            `Date` date NOT NULL,
                                            `Leg` varchar(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `Horse` (`Horse`),
    KEY `Date` (`Date`) USING BTREE,
    KEY `date_horse` (`Date`,`Horse`) USING BTREE,
    KEY `Horse_2` (`Horse`,`Injury`) USING BTREE,
    KEY `horse_date` (`Horse`,`Date`) USING BTREE,
    KEY `Injury` (`Injury`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=11072 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_markings` (
                                     `ID` int NOT NULL AUTO_INCREMENT,
                                     `Marking` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_sales` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Horse` int NOT NULL,
                                  `Date` date NOT NULL,
                                  `Seller` int DEFAULT NULL,
                                  `Buyer` int DEFAULT NULL,
                                  `Price` int DEFAULT NULL,
                                  `PT` tinyint(1) NOT NULL DEFAULT '1',
    PRIMARY KEY (`ID`),
    KEY `Buyer` (`Buyer`) USING BTREE,
    KEY `Date` (`Date`) USING BTREE,
    KEY `Horse` (`Horse`) USING BTREE,
    KEY `PT` (`PT`) USING BTREE,
    KEY `Seller` (`Seller`) USING BTREE,
    KEY `Seller Date` (`Date`,`Seller`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=40384 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_shipping` (
                                     `ID` int NOT NULL AUTO_INCREMENT,
                                     `Horse` int NOT NULL,
                                     `Date` date NOT NULL,
                                     `Arrive` date NOT NULL,
                                     `FromTrack` int DEFAULT NULL,
                                     `ToTrack` int DEFAULT NULL,
                                     `FromFarm` int DEFAULT NULL,
                                     `ToFarm` int DEFAULT NULL,
                                     `Mode` enum('A','R') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`),
    KEY `Date` (`Date`) USING BTREE,
    KEY `Horse` (`Horse`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=505201 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_status` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Status` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`),
    KEY `Status` (`Status`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horse_titles` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Title` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Abbr` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Points` int NOT NULL,
    PRIMARY KEY (`ID`),
    KEY `Abbr` (`Abbr`) USING BTREE,
    KEY `Points` (`Points`) USING BTREE,
    KEY `Title` (`Title`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_horses` (
                             `ID` int NOT NULL AUTO_INCREMENT,
                             `Name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `Gender` enum('C','F','G','M','S') CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Status` tinyint DEFAULT NULL,
    `Location` int NOT NULL DEFAULT '59',
    `Boarded` tinyint(1) NOT NULL DEFAULT '0',
    `InTransit` tinyint(1) NOT NULL DEFAULT '0',
    `Owner` int DEFAULT NULL,
    `Leased` tinyint(1) NOT NULL DEFAULT '0',
    `Breeder` int DEFAULT NULL,
    `LocBred` int NOT NULL DEFAULT '10',
    `DOB` date DEFAULT NULL,
    `DOD` date DEFAULT NULL,
    `Sire` int DEFAULT NULL,
    `Dam` int DEFAULT NULL,
    `SireSire` int DEFAULT NULL,
    `SireDam` int DEFAULT NULL,
    `DamSire` int DEFAULT NULL,
    `DamDam` int DEFAULT NULL,
    `SalePrice` int DEFAULT '-1',
    `SellTo` int DEFAULT '0',
    `StudPrice` int DEFAULT '-1',
    `Outside` tinyint DEFAULT '0',
    `MaresPerStable` tinyint DEFAULT '0',
    `Approval` enum('Y','N') CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT 'N',
    `FFMares` tinyint(1) NOT NULL DEFAULT '0',
    `Comments` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci,
    `OwnerComments` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci,
    `Color` tinyint DEFAULT NULL,
    `Face` tinyint DEFAULT '3',
    `RFmarkings` tinyint DEFAULT '3',
    `LFmarkings` tinyint DEFAULT '3',
    `RHmarkings` tinyint DEFAULT '3',
    `LHmarkings` tinyint DEFAULT '3',
    `Height` varchar(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `CurrentHeight` double(3,1) NOT NULL DEFAULT '0.0',
    `FoalHeight` tinyint DEFAULT NULL,
    `FacePic` tinyint DEFAULT '18',
    `RFPic` tinyint DEFAULT '18',
    `LFPic` tinyint DEFAULT '18',
    `RHPic` tinyint DEFAULT '18',
    `LHPic` tinyint DEFAULT '18',
    `Allele` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Break` int DEFAULT NULL,
    `Min` int DEFAULT NULL,
    `Ave` int DEFAULT NULL,
    `Max` int DEFAULT NULL,
    `Stamina` int DEFAULT NULL,
    `Sustain` tinyint DEFAULT NULL,
    `Consistency` tinyint DEFAULT NULL,
    `Fast` tinyint DEFAULT NULL,
    `Good` tinyint DEFAULT NULL,
    `Wet` tinyint DEFAULT NULL,
    `Slow` tinyint DEFAULT NULL,
    `Dirt` tinyint DEFAULT NULL,
    `Turf` tinyint DEFAULT NULL,
    `SC` tinyint DEFAULT NULL,
    `Courage` tinyint DEFAULT NULL,
    `BPF` tinyint DEFAULT NULL,
    `ImmDate` date DEFAULT NULL,
    `HBDate` date DEFAULT NULL,
    `Lead` tinyint DEFAULT NULL,
    `Pace` tinyint DEFAULT NULL,
    `Midpack` tinyint DEFAULT NULL,
    `Close` tinyint DEFAULT NULL,
    `Soundness` tinyint DEFAULT NULL,
    `GenSound` tinyint DEFAULT NULL,
    `Fitness` tinyint DEFAULT NULL,
    `DisplayFitness` char(1) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT NULL,
    `Pissy` int DEFAULT NULL,
    `Ratability` int DEFAULT NULL,
    `Equipment` tinyint DEFAULT NULL,
    `DefaultEquip` tinyint DEFAULT NULL,
    `DefaultJock1` int DEFAULT NULL,
    `DefaultJock2` int DEFAULT NULL,
    `DefaultJock3` int DEFAULT NULL,
    `DefaultInstructions` tinyint DEFAULT NULL,
    `DefaultWorkoutTrack` int DEFAULT NULL,
    `EnergyMin` tinyint DEFAULT NULL,
    `SPS` double(5,3) DEFAULT NULL,
    `LoafThresh` int DEFAULT NULL,
    `LoafStride` int DEFAULT NULL,
    `LoafPct` tinyint NOT NULL DEFAULT '0',
    `Acceleration` int DEFAULT NULL,
    `Traffic` int DEFAULT NULL,
    `EnergyRegain` tinyint DEFAULT NULL,
    `EnergyCurrent` int DEFAULT NULL,
    `DisplayEnergy` char(1) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT NULL,
    `NaturalEnergy` double(4,1) NOT NULL DEFAULT '0.0',
    `NELoss` tinyint DEFAULT NULL,
    `NEGain` double(3,2) DEFAULT NULL,
    `XPRate` tinyint DEFAULT NULL,
    `XPCurrent` tinyint DEFAULT NULL,
    `Turning` int DEFAULT NULL,
    `Weight` int DEFAULT NULL,
    `BMBPF` tinyint DEFAULT NULL,
    `DC` char(3) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Immature` char(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Hasbeen` char(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Retire` date DEFAULT NULL,
    `Die` date DEFAULT NULL,
    `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `slug` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `LastRaceId` int DEFAULT NULL,
    `LastRaceFinishers` int DEFAULT NULL,
    `RacesCount` int DEFAULT NULL,
    `RestDayCount` int DEFAULT NULL,
    `can_be_sold` tinyint(1) NOT NULL DEFAULT '0',
    `leaser` int DEFAULT '0',
    `rails_id` char(36) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    `consigned_auction_id` char(36) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    `last_synced_to_rails_at` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `Boarded` (`Boarded`) USING BTREE,
    KEY `Breeder` (`Breeder`) USING BTREE,
    KEY `Dam` (`Dam`) USING BTREE,
    KEY `DamDam` (`DamDam`) USING BTREE,
    KEY `DamSire` (`DamSire`) USING BTREE,
    KEY `Dam_2` (`Dam`,`DOB`) USING BTREE,
    KEY `DC` (`DC`) USING BTREE,
    KEY `DefaultJock1` (`DefaultJock1`) USING BTREE,
    KEY `DisplayEnergy` (`DisplayEnergy`) USING BTREE,
    KEY `DOB` (`DOB`) USING BTREE,
    KEY `DOD` (`DOD`) USING BTREE,
    KEY `EnergyCurrent` (`EnergyCurrent`) USING BTREE,
    KEY `Fitness` (`Fitness`) USING BTREE,
    KEY `Gender` (`Gender`) USING BTREE,
    KEY `LastRace` (`LastRaceId`) USING BTREE,
    KEY `Leased` (`Leased`) USING BTREE,
    KEY `Leaser` (`leaser`) USING BTREE,
    KEY `Location` (`Location`) USING BTREE,
    KEY `Name` (`Name`) USING BTREE,
    KEY `NatEn` (`NaturalEnergy`) USING BTREE,
    KEY `Owner` (`Owner`) USING BTREE,
    KEY `owner_price` (`Owner`,`SalePrice`) USING BTREE,
    KEY `SalePrice` (`SalePrice`) USING BTREE,
    KEY `SellTo` (`SellTo`) USING BTREE,
    KEY `Sire` (`Sire`) USING BTREE,
    KEY `SireDam` (`SireDam`) USING BTREE,
    KEY `SireSire` (`SireSire`) USING BTREE,
    KEY `Sire_2` (`Sire`,`Dam`) USING BTREE,
    KEY `Status` (`Status`) USING BTREE,
    KEY `Status_2` (`Status`,`Sire`,`Dam`) USING BTREE,
    KEY `status_location` (`Status`,`Location`) USING BTREE,
    KEY `Status_Owner` (`Status`,`Owner`) USING BTREE,
    KEY `Status_Owner_Leased` (`Status`,`Owner`,`Leased`) USING BTREE,
    KEY `idx_display_fitness` (`DisplayFitness`),
    KEY `idx_fitness` (`Fitness`),
    KEY `idx_fitness_all` (`DisplayFitness`,`Fitness`),
    KEY `idx_energy_all` (`DisplayEnergy`,`EnergyCurrent`)
    ) ENGINE=InnoDB AUTO_INCREMENT=64163 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_hoty_cats` (
                                `ID` int NOT NULL AUTO_INCREMENT,
                                `Name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `name` (`Name`)
    ) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_hoty_winners` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Year` int NOT NULL DEFAULT '0',
                                   `Category` tinyint NOT NULL DEFAULT '0',
                                   `Winner` int NOT NULL DEFAULT '0',
                                   PRIMARY KEY (`ID`),
    KEY `Category` (`Category`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=368 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_injuries` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Horse` int NOT NULL DEFAULT '0',
                               `Date` date DEFAULT NULL,
                               `Injury` tinyint DEFAULT NULL,
                               `Rest` date DEFAULT NULL,
                               `VetDate` date DEFAULT NULL,
                               PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=26061 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_injury_types` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Injury` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Line` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_jockey_instructions` (
                                          `ID` int NOT NULL AUTO_INCREMENT,
                                          `Instructions` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Text` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_jockey_records` (
                                     `ID` int NOT NULL AUTO_INCREMENT,
                                     `Jockey` int NOT NULL,
                                     `Year` int NOT NULL,
                                     `Starts` int NOT NULL DEFAULT '0',
                                     `Stakes` int NOT NULL DEFAULT '0',
                                     `Wins` int NOT NULL DEFAULT '0',
                                     `StakesWn` int NOT NULL DEFAULT '0',
                                     `Seconds` int NOT NULL DEFAULT '0',
                                     `StakesSds` int NOT NULL DEFAULT '0',
                                     `Thirds` int NOT NULL DEFAULT '0',
                                     `StakesTds` int NOT NULL DEFAULT '0',
                                     `Fourths` int NOT NULL DEFAULT '0',
                                     `StakesFs` int NOT NULL DEFAULT '0',
                                     `Earnings` int NOT NULL DEFAULT '0',
                                     PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=33006 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_jockey_status` (
                                    `ID` int NOT NULL AUTO_INCREMENT,
                                    `Status` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_jockeys` (
                              `ID` int NOT NULL AUTO_INCREMENT,
                              `First` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Last` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Gender` enum('M','F') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'M',
    `Status` tinyint NOT NULL DEFAULT '1',
    `DOB` date NOT NULL DEFAULT '0000-00-00',
    `Height` tinyint NOT NULL DEFAULT '0',
    `Weight` int NOT NULL DEFAULT '0',
    `Break` int NOT NULL DEFAULT '0',
    `Min` int NOT NULL DEFAULT '0',
    `Ave` int NOT NULL DEFAULT '0',
    `Max` int NOT NULL DEFAULT '0',
    `Consistency` tinyint NOT NULL DEFAULT '0',
    `Fast` tinyint NOT NULL DEFAULT '0',
    `Good` tinyint NOT NULL DEFAULT '0',
    `Wet` tinyint NOT NULL DEFAULT '0',
    `Slow` tinyint NOT NULL DEFAULT '0',
    `Dirt` tinyint NOT NULL DEFAULT '0',
    `Turf` tinyint NOT NULL DEFAULT '0',
    `SC` tinyint NOT NULL DEFAULT '0',
    `Courage` tinyint NOT NULL DEFAULT '0',
    `Lead` tinyint NOT NULL DEFAULT '0',
    `Pace` tinyint NOT NULL DEFAULT '0',
    `Midpack` tinyint NOT NULL DEFAULT '0',
    `Close` tinyint NOT NULL DEFAULT '0',
    `Pissy` tinyint NOT NULL DEFAULT '0',
    `Rating` tinyint NOT NULL DEFAULT '0',
    `LoafThresh` tinyint NOT NULL DEFAULT '0',
    `Acceleration` tinyint NOT NULL DEFAULT '0',
    `Traffic` tinyint NOT NULL DEFAULT '0',
    `XPRate` double(2,1) NOT NULL DEFAULT '0.0',
    `XPCurrent` tinyint NOT NULL DEFAULT '0',
    `Turning` int NOT NULL DEFAULT '0',
    `Strength` tinyint NOT NULL DEFAULT '0',
    `Looking` tinyint NOT NULL DEFAULT '0',
    `WhipSec` int NOT NULL DEFAULT '0',
    `slug` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `First` (`First`) USING BTREE,
    KEY `Gender` (`Gender`) USING BTREE,
    KEY `Last` (`Last`) USING BTREE,
    KEY `Status` (`Status`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_jocklines` (
                                `ID` int NOT NULL AUTO_INCREMENT,
                                `Line` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Stat` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Value` tinyint DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `stat_search` (`Stat`,`Value`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_leases` (
                             `ID` int NOT NULL AUTO_INCREMENT,
                             `horse` int DEFAULT NULL,
                             `owner` int DEFAULT NULL,
                             `leaser` int DEFAULT NULL,
                             `fee` int DEFAULT NULL,
                             `Start` date NOT NULL,
                             `End` date DEFAULT NULL,
                             `Terminated` date DEFAULT NULL,
                             `Active` tinyint(1) NOT NULL DEFAULT '0',
    `OwnerEnd` tinyint(1) NOT NULL DEFAULT '0',
    `OwnerEndDate` date DEFAULT NULL,
    `LeaserEnd` tinyint(1) NOT NULL DEFAULT '0',
    `LeaserEndDate` date DEFAULT NULL,
    `OwnerRefund` tinyint(1) NOT NULL DEFAULT '0',
    `LeaserRefund` tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`ID`),
    UNIQUE KEY `horse_dates` (`horse`,`Start`,`End`),
    KEY `horse` (`horse`) USING BTREE,
    KEY `Leaser` (`leaser`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=7679 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_log_errors` (
                                 `ID` int NOT NULL AUTO_INCREMENT,
                                 `Error_type` enum('DB','PHP') CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL DEFAULT 'PHP',
    `Error_details` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
    `Error_file` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
    `Error_line` int DEFAULT NULL,
    `User` int DEFAULT NULL,
    `Skin` tinyint DEFAULT NULL,
    `Date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `Unique Error` (`Error_type`,`Error_file`,`Error_line`)
    ) ENGINE=InnoDB AUTO_INCREMENT=486064 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_log_quitting` (
                                   `id` int NOT NULL AUTO_INCREMENT,
                                   `user_id` int NOT NULL,
                                   `budget_amount` int NOT NULL,
                                   `horse_list` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
                                   `quit_date` date NOT NULL,
                                   `auto_quit` tinyint NOT NULL DEFAULT '0',
                                   PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_log_sale_actions` (
                                       `id` int NOT NULL AUTO_INCREMENT,
                                       `action` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_log_sales` (
                                `id` int NOT NULL AUTO_INCREMENT,
                                `horse` int NOT NULL DEFAULT '0',
                                `action_id` int NOT NULL DEFAULT '0',
                                `user_id` int NOT NULL,
                                `price` int DEFAULT NULL,
                                `sellto` int DEFAULT NULL,
                                `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                `active` tinyint(1) NOT NULL DEFAULT '1',
    PRIMARY KEY (`id`),
    KEY `horse_date` (`horse`,`date`) USING BTREE,
    KEY `horse_price` (`horse`,`price`) USING BTREE,
    KEY `horse_sellto` (`horse`,`sellto`) USING BTREE,
    KEY `price_active` (`price`,`active`) USING BTREE,
    KEY `sellto_active` (`sellto`,`active`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=39100 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_marking_images` (
                                     `id` int NOT NULL AUTO_INCREMENT,
                                     `marking_id` int NOT NULL,
                                     `image` varchar(25) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `marking_id` (`marking_id`,`image`)
    ) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_nom_bs` (
                             `ID` int NOT NULL AUTO_INCREMENT,
                             `Stable` int NOT NULL DEFAULT '0',
                             `BS` tinyint NOT NULL DEFAULT '0',
                             PRIMARY KEY (`ID`),
    KEY `series` (`BS`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=93 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_nominations` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Race` int NOT NULL DEFAULT '0',
                                  `Horse` int NOT NULL DEFAULT '0',
                                  `Year` int DEFAULT NULL,
                                  PRIMARY KEY (`ID`),
    UNIQUE KEY `Race_Horse_Year` (`Race`,`Horse`,`Year`),
    KEY `Race` (`Race`) USING BTREE,
    KEY `Race_Horse` (`Race`,`Horse`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=24533 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_nominations_sup` (
                                      `id` int NOT NULL AUTO_INCREMENT,
                                      `horse` int NOT NULL,
                                      `race` int NOT NULL,
                                      `year` int NOT NULL,
                                      PRIMARY KEY (`id`),
    KEY `race` (`race`) USING BTREE,
    KEY `year` (`year`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_nomraces` (
                               `ID` int unsigned NOT NULL AUTO_INCREMENT,
                               `Race` int unsigned NOT NULL DEFAULT '0',
                               `Weanling` int unsigned DEFAULT NULL,
                               `Yearling` int unsigned DEFAULT NULL,
                               `2yo` int unsigned DEFAULT NULL,
                               `3yo` int unsigned DEFAULT NULL,
                               `3yo+` int unsigned DEFAULT NULL,
                               `4yo+` int unsigned DEFAULT NULL,
                               `Period` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'A',
    PRIMARY KEY (`ID`),
    KEY `Race` (`Race`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_odds` (
                           `ID` int NOT NULL AUTO_INCREMENT,
                           `Odds` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Dec` double(3,1) NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_pedigrees` (
                                `id` int NOT NULL AUTO_INCREMENT,
                                `horse` varchar(18) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `sire` varchar(18) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `dam` varchar(18) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `sire_sire` varchar(18) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `sire_dam` varchar(18) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `dam_sire` varchar(18) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `dam_dam` varchar(18) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `gender` enum('M','F') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `user_id` int NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `horse` (`horse`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_qual_horses` (
                                  `id` int NOT NULL AUTO_INCREMENT,
                                  `horse_id` int NOT NULL,
                                  `race_id` int NOT NULL,
                                  `wins` int DEFAULT '0',
                                  `stakes_wins` int DEFAULT '0',
                                  `places` int DEFAULT '0',
                                  `stakes_places` int DEFAULT '0',
                                  `shows` int DEFAULT '0',
                                  `stakes_shows` int DEFAULT '0',
                                  `fourths` int DEFAULT '0',
                                  `stakes_fourths` int DEFAULT '0',
                                  `points` int DEFAULT '0',
                                  `earnings` int DEFAULT '0',
                                  `bc_wins` int DEFAULT '0',
                                  `bc_places` int DEFAULT '0',
                                  `bc_shows` int DEFAULT '0',
                                  `bc_points` int DEFAULT '0',
                                  PRIMARY KEY (`id`),
    UNIQUE KEY `horse_id` (`horse_id`,`race_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=2952 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_qual_races` (
                                 `id` int NOT NULL AUTO_INCREMENT,
                                 `race_id` int NOT NULL,
                                 PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_race_ages` (
                                `ID` int NOT NULL AUTO_INCREMENT,
                                `Age` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_race_grades` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Grade` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Abbr` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_race_types` (
                                 `ID` int NOT NULL AUTO_INCREMENT,
                                 `Type` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`),
    KEY `type` (`Type`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_raceentries` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Race` int NOT NULL DEFAULT '0',
                                  `Horse` int NOT NULL DEFAULT '0',
                                  `Equipment` tinyint DEFAULT NULL,
                                  `PP` tinyint DEFAULT NULL,
                                  `Jockey` int DEFAULT NULL,
                                  `Jock2` int DEFAULT NULL,
                                  `Jock3` int DEFAULT NULL,
                                  `Instructions` tinyint DEFAULT NULL,
                                  `Odds` tinyint DEFAULT NULL,
                                  `Weight` int DEFAULT NULL,
                                  `EntryDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`ID`),
    UNIQUE KEY `race_horse` (`Race`,`Horse`),
    KEY `equipment` (`Equipment`) USING BTREE,
    KEY `Horse` (`Horse`) USING BTREE,
    KEY `race` (`Race`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=742436 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_racerecords` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Horse` int NOT NULL DEFAULT '0',
                                  `Year` int NOT NULL DEFAULT '0',
                                  `Starts` tinyint NOT NULL DEFAULT '0',
                                  `Stakes` tinyint NOT NULL DEFAULT '0',
                                  `Wins` tinyint NOT NULL DEFAULT '0',
                                  `StakesWn` tinyint NOT NULL DEFAULT '0',
                                  `Seconds` tinyint NOT NULL DEFAULT '0',
                                  `StakesSds` tinyint NOT NULL DEFAULT '0',
                                  `Thirds` tinyint NOT NULL DEFAULT '0',
                                  `StakesTds` tinyint NOT NULL DEFAULT '0',
                                  `Fourths` tinyint NOT NULL DEFAULT '0',
                                  `StakesFs` tinyint NOT NULL DEFAULT '0',
                                  `Points` int NOT NULL DEFAULT '0',
                                  `Earnings` bigint NOT NULL DEFAULT '0',
                                  `FlatSC` enum('F','SC') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'F',
    PRIMARY KEY (`ID`),
    KEY `Earnings` (`Earnings`) USING BTREE,
    KEY `FlatSC` (`FlatSC`) USING BTREE,
    KEY `Horse` (`Horse`) USING BTREE,
    KEY `Points` (`Points`) USING BTREE,
    KEY `StakesWn` (`StakesWn`) USING BTREE,
    KEY `wins` (`Wins`) USING BTREE,
    KEY `Year` (`Year`) USING BTREE,
    KEY `Year_FSC` (`Year`,`FlatSC`) USING BTREE,
    KEY `year_horse` (`Year`,`Horse`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=162543 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_racerecords_allowance` (
                                            `id` int NOT NULL AUTO_INCREMENT,
                                            `horse` int NOT NULL DEFAULT '0',
                                            `wins` int NOT NULL DEFAULT '0',
                                            PRIMARY KEY (`id`),
    UNIQUE KEY `Horse` (`horse`),
    KEY `wins` (`wins`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=33120 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_racerecords_lifetime` (
                                           `ID` int NOT NULL AUTO_INCREMENT,
                                           `Horse` int NOT NULL DEFAULT '0',
                                           `Starts` tinyint NOT NULL DEFAULT '0',
                                           `Stakes` tinyint NOT NULL DEFAULT '0',
                                           `Wins` tinyint NOT NULL DEFAULT '0',
                                           `StakesWn` tinyint NOT NULL DEFAULT '0',
                                           `Seconds` tinyint NOT NULL DEFAULT '0',
                                           `StakesSds` tinyint NOT NULL DEFAULT '0',
                                           `Thirds` tinyint NOT NULL DEFAULT '0',
                                           `StakesTds` tinyint NOT NULL DEFAULT '0',
                                           `Fourths` tinyint NOT NULL DEFAULT '0',
                                           `StakesFs` tinyint NOT NULL DEFAULT '0',
                                           `Points` int NOT NULL DEFAULT '0',
                                           `Earnings` int NOT NULL DEFAULT '0',
                                           PRIMARY KEY (`ID`),
    UNIQUE KEY `Horse` (`Horse`),
    KEY `Earnings` (`Earnings`) USING BTREE,
    KEY `Points` (`Points`) USING BTREE,
    KEY `StakesWn` (`StakesWn`) USING BTREE,
    KEY `wins` (`Wins`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=119338 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_raceresults` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Date` date DEFAULT NULL,
                                  `Num` tinyint DEFAULT NULL,
                                  `Distance` double(3,1) DEFAULT NULL,
    `Grade` tinyint DEFAULT NULL,
    `Type` tinyint NOT NULL DEFAULT '0',
    `Age` int NOT NULL DEFAULT '0',
    `Gender` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Condition` tinyint NOT NULL DEFAULT '0',
    `Purse` bigint DEFAULT NULL,
    `RaceName` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Time` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Location` int NOT NULL DEFAULT '0',
    `SplitType` enum('4Q','2F') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '2F',
    PRIMARY KEY (`ID`),
    UNIQUE KEY `Num_Date` (`Num`,`Date`),
    KEY `Age` (`Age`) USING BTREE,
    KEY `Date` (`Date`) USING BTREE,
    KEY `Distance` (`Distance`) USING BTREE,
    KEY `Gender` (`Gender`) USING BTREE,
    KEY `Grade` (`Grade`) USING BTREE,
    KEY `Location` (`Location`) USING BTREE,
    KEY `RaceName` (`RaceName`) USING BTREE,
    KEY `RaceNum` (`Num`) USING BTREE,
    KEY `Surface` (`Condition`) USING BTREE,
    KEY `Time` (`Time`) USING BTREE,
    KEY `Type` (`Type`) USING BTREE,
    KEY `Type_Date` (`Type`,`Date`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=106298 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_raceresults_oof` (
                                      `ID` int NOT NULL AUTO_INCREMENT,
                                      `RaceID` int DEFAULT NULL,
                                      `Horse` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `PP` tinyint NOT NULL,
    `RL` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `MarL` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Fractions` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Jockey` int DEFAULT NULL,
    `Equip` tinyint DEFAULT NULL,
    `SF` int NOT NULL DEFAULT '0',
    `Pos` tinyint NOT NULL DEFAULT '0',
    `Odds` tinyint DEFAULT NULL,
    `Weight` int DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `Equip` (`Equip`) USING BTREE,
    KEY `Horse` (`Horse`) USING BTREE,
    KEY `Horse_Race` (`Horse`,`RaceID`) USING BTREE,
    KEY `Pos` (`Pos`) USING BTREE,
    KEY `position_horse` (`Pos`,`Horse`) USING BTREE,
    KEY `RaceID` (`RaceID`,`Horse`) USING BTREE,
    KEY `RaceNum` (`RaceID`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=773023 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_races` (
                            `ID` int NOT NULL AUTO_INCREMENT,
                            `DayNum` tinyint NOT NULL,
                            `Date` date NOT NULL DEFAULT '0000-00-00',
                            `Num` tinyint DEFAULT NULL,
                            `Location` tinyint NOT NULL,
                            `Type` tinyint NOT NULL,
                            `Name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Grade` int DEFAULT NULL,
    `Age` int NOT NULL,
    `Gender` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Distance` double(3,1) NOT NULL,
    `Purse` bigint DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `Age` (`Age`) USING BTREE,
    KEY `Date` (`Date`) USING BTREE,
    KEY `Distance` (`Distance`) USING BTREE,
    KEY `Grade` (`Grade`) USING BTREE,
    KEY `location` (`Location`) USING BTREE,
    KEY `Num` (`Num`) USING BTREE,
    KEY `Purse` (`Purse`) USING BTREE,
    KEY `Race` (`Name`) USING BTREE,
    KEY `Track` (`Location`) USING BTREE,
    KEY `type` (`Type`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=5253 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_sctrials` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Horse` int NOT NULL DEFAULT '0',
                               `Jockey` int NOT NULL DEFAULT '0',
                               `Date` date NOT NULL DEFAULT '0000-00-00',
                               `Condition` tinyint NOT NULL,
                               `Location` int NOT NULL DEFAULT '0',
                               `Distance` tinyint NOT NULL DEFAULT '0',
                               `Comment` tinyint NOT NULL,
                               `Time` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `Horse` (`Horse`,`Jockey`,`Condition`,`Location`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=17613 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_shipping` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Start` tinyint NOT NULL DEFAULT '0',
                               `End` tinyint NOT NULL DEFAULT '0',
                               `Miles` int NOT NULL DEFAULT '0',
                               `RDay` tinyint DEFAULT NULL,
                               `REn` tinyint DEFAULT NULL,
                               `RFit` tinyint DEFAULT NULL,
                               `RCost` int DEFAULT NULL,
                               `ADay` tinyint DEFAULT NULL,
                               `AEn` tinyint DEFAULT NULL,
                               `AFit` tinyint DEFAULT NULL,
                               `ACost` int DEFAULT NULL,
                               `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                               PRIMARY KEY (`ID`),
    UNIQUE KEY `Start` (`Start`,`End`)
    ) ENGINE=InnoDB AUTO_INCREMENT=381 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_shipping_old` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Start` tinyint NOT NULL DEFAULT '0',
                                   `End` tinyint NOT NULL DEFAULT '0',
                                   `Miles` int NOT NULL DEFAULT '0',
                                   `RDay` tinyint DEFAULT NULL,
                                   `REn` tinyint DEFAULT NULL,
                                   `RFit` tinyint DEFAULT NULL,
                                   `RCost` int DEFAULT NULL,
                                   `ADay` tinyint DEFAULT NULL,
                                   `AEn` tinyint DEFAULT NULL,
                                   `AFit` tinyint DEFAULT NULL,
                                   `ACost` int DEFAULT NULL,
                                   PRIMARY KEY (`ID`),
    UNIQUE KEY `Start` (`Start`,`End`)
    ) ENGINE=InnoDB AUTO_INCREMENT=381 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_skins` (
                            `ID` int NOT NULL AUTO_INCREMENT,
                            `Skin` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Description` text CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `BackgroundImage` varchar(200) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `PageBackground` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `MenuLink` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '000',
    `TableHead` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `TableRow1` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `TableRow2` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Active` tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_speedrecords` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `RaceID` int NOT NULL DEFAULT '0',
                                   `Horse` varchar(25) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
    `Time` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Distance` double(3,1) DEFAULT NULL,
    `Track` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Gender` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `NewRec` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`),
    KEY `Distance` (`Distance`) USING BTREE,
    KEY `Gender` (`Gender`) USING BTREE,
    KEY `Horse` (`Horse`) USING BTREE,
    KEY `RaceID` (`RaceID`) USING BTREE,
    KEY `Time` (`Time`) USING BTREE,
    KEY `Track` (`Track`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=10330 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_stable_notes` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Stable` int NOT NULL,
                                   `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   `Title` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Text` longtext CHARACTER SET latin1 COLLATE latin1_swedish_ci,
    `Private` tinyint(1) NOT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `Stable` (`Stable`,`Created`,`Title`)
    ) ENGINE=InnoDB AUTO_INCREMENT=2769 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_stablerrs` (
                                `ID` int NOT NULL AUTO_INCREMENT,
                                `Stable` int NOT NULL DEFAULT '0',
                                `Year` int DEFAULT NULL,
                                `Races` int NOT NULL DEFAULT '0',
                                `stakes` int NOT NULL DEFAULT '0',
                                `Win` int NOT NULL DEFAULT '0',
                                `stakeswin` int NOT NULL DEFAULT '0',
                                `Place` int NOT NULL DEFAULT '0',
                                `stakesplace` int NOT NULL DEFAULT '0',
                                `Shows` int NOT NULL DEFAULT '0',
                                `stakesshow` int NOT NULL DEFAULT '0',
                                `Fourth` int NOT NULL DEFAULT '0',
                                `stakesfourth` int NOT NULL DEFAULT '0',
                                `Money` int NOT NULL DEFAULT '0',
                                PRIMARY KEY (`ID`),
    UNIQUE KEY `stable_year` (`Stable`,`Year`),
    KEY `Stable` (`Stable`) USING BTREE,
    KEY `Year` (`Year`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=1545 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_stables` (
                              `id` int NOT NULL,
                              `totalBalance` int DEFAULT '0',
                              `availableBalance` int DEFAULT '0',
                              `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                              `slug` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_tcbs_titles` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Title` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_tcbs_winners` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `TCBS` char(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Title` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Year` int NOT NULL DEFAULT '0',
    `Winner` int NOT NULL DEFAULT '0',
    PRIMARY KEY (`ID`),
    KEY `Title` (`Title`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_track_conditions` (
                                       `ID` int NOT NULL AUTO_INCREMENT,
                                       `Condition` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_track_types` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `Type` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_track_weather` (
                                    `ID` int NOT NULL,
                                    `WFast` tinyint NOT NULL,
                                    `WGood` tinyint NOT NULL,
                                    `WWet` tinyint NOT NULL,
                                    `WSlow` tinyint NOT NULL,
                                    `SFast` tinyint NOT NULL,
                                    `SGood` tinyint NOT NULL,
                                    `SWet` tinyint NOT NULL,
                                    `SSlow` tinyint NOT NULL,
                                    `UFast` tinyint NOT NULL,
                                    `UGood` tinyint NOT NULL,
                                    `UWet` tinyint NOT NULL,
                                    `USlow` tinyint NOT NULL,
                                    `FFast` tinyint NOT NULL,
                                    `FGood` tinyint NOT NULL,
                                    `FWet` tinyint NOT NULL,
                                    `FSlow` tinyint NOT NULL,
                                    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_trackdata` (
                                `ID` int NOT NULL AUTO_INCREMENT,
                                `Name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Abbr` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Location` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `DTSC` varchar(12) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Condition` varchar(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Width` int DEFAULT NULL,
    `Length` int DEFAULT NULL,
    `TurnToFinish` int DEFAULT NULL,
    `TurnDistance` int DEFAULT NULL,
    `Banking` tinyint DEFAULT NULL,
    `Jumps` tinyint DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `Condition` (`Condition`) USING BTREE,
    KEY `DTSC` (`DTSC`) USING BTREE,
    KEY `Location` (`Location`) USING BTREE,
    KEY `Name` (`Name`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_training_schedule_details` (
                                                `ID` int NOT NULL AUTO_INCREMENT,
                                                `Schedule` int NOT NULL,
                                                `Day` char(1) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Activity1` tinyint NOT NULL,
    `Distance1` tinyint NOT NULL,
    `Activity2` tinyint DEFAULT NULL,
    `Distance2` tinyint DEFAULT NULL,
    `Activity3` tinyint DEFAULT NULL,
    `Distance3` tinyint DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `Day` (`Day`) USING BTREE,
    KEY `Schedule` (`Schedule`,`Day`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=50174 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_training_schedule_horses` (
                                               `Horse` int NOT NULL,
                                               `Schedule` int NOT NULL,
                                               PRIMARY KEY (`Horse`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_training_schedules` (
                                         `ID` int NOT NULL AUTO_INCREMENT,
                                         `Stable` int DEFAULT NULL,
                                         `Horse` int DEFAULT NULL,
                                         `Name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `Description` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `horse` (`Horse`) USING BTREE,
    KEY `stable` (`Stable`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=17438 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_user_colors` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `User` int NOT NULL,
                                  `PageBackground` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `MenuLink` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `TableHead` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `TableRow1` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `TableRow2` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_user_ips` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `User` int NOT NULL DEFAULT '0',
                               `IP` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=11898 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_user_styles` (
                                  `ID` int NOT NULL AUTO_INCREMENT,
                                  `User` int NOT NULL DEFAULT '0',
                                  `Skin` tinyint NOT NULL DEFAULT '1',
                                  `FontSize` varchar(2) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '10',
    `Link` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'text-decoration: none',
    `LinkActive` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'text-decoration: none',
    `LinkHover` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'text-decoration: none',
    `Colt` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '00F',
    `Filly` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'F00',
    `Gelding` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '090',
    PRIMARY KEY (`ID`),
    UNIQUE KEY `User` (`User`),
    KEY `Skin` (`Skin`) USING BTREE,
    KEY `User_2` (`User`,`Skin`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=1294 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_users` (
                            `ID` int NOT NULL AUTO_INCREMENT,
                            `Username` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
    `Password` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin DEFAULT NULL,
    `Status` char(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'A',
    `StableName` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
    `Name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
    `ForumID` int DEFAULT NULL,
    `BugID` int DEFAULT NULL,
    `Email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
    `Admin` tinyint(1) NOT NULL DEFAULT '0',
    `TrackID` int DEFAULT NULL,
    `TrackMiles` tinyint DEFAULT NULL,
    `RefID` int NOT NULL DEFAULT '0',
    `Flag` tinyint(1) DEFAULT '0',
    `LastLogin` datetime DEFAULT NULL,
    `PrevLogin` datetime DEFAULT NULL,
    `LastEntry` datetime DEFAULT NULL,
    `LastBought` datetime DEFAULT NULL,
    `LastSold` datetime DEFAULT NULL,
    `LastStudBred` datetime DEFAULT NULL,
    `LastMareBred` datetime DEFAULT NULL,
    `JoinDate` date NOT NULL,
    `IP` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    `FlagDate` date DEFAULT NULL,
    `Emailed` tinyint(1) NOT NULL DEFAULT '0',
    `EmailVal` tinyint(1) NOT NULL DEFAULT '0',
    `Approval` tinyint(1) NOT NULL DEFAULT '0',
    `Description` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
    `Birthday` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `Birthyear` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `Level` tinyint unsigned NOT NULL DEFAULT '0',
    `Cheating` tinyint NOT NULL DEFAULT '0',
    `Timestamp` int NOT NULL DEFAULT '0',
    `CreateAuction` tinyint(1) NOT NULL DEFAULT '1',
    `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `slug` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT NULL,
    `user_id` int DEFAULT NULL,
    `discourse_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    `discourse_id` int DEFAULT NULL,
    `discourse_api_key` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    `rails_activated_at` datetime DEFAULT NULL,
    `rails_id` char(36) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    PRIMARY KEY (`ID`),
    UNIQUE KEY `email_unique` (`Email`),
    UNIQUE KEY `username_unique` (`Username`),
    KEY `Email` (`Email`) USING BTREE,
    KEY `ForumID` (`ForumID`) USING BTREE,
    KEY `JoinDate` (`JoinDate`) USING BTREE,
    KEY `LastBought` (`LastBought`) USING BTREE,
    KEY `LastEntry` (`LastEntry`) USING BTREE,
    KEY `LastLogin` (`LastLogin`) USING BTREE,
    KEY `LastMareBred` (`LastMareBred`) USING BTREE,
    KEY `LastSold` (`LastSold`) USING BTREE,
    KEY `LastStudBred` (`LastStudBred`) USING BTREE,
    KEY `Name` (`Name`) USING BTREE,
    KEY `Password` (`Password`) USING BTREE,
    KEY `StableName` (`StableName`) USING BTREE,
    KEY `Status` (`Status`) USING BTREE,
    KEY `Username` (`Username`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=4090 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_userwarnings` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `User` int DEFAULT NULL,
                                   `DateGiven` date DEFAULT NULL,
                                   `DateFulfilled` date DEFAULT NULL,
                                   `Type` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_visitors` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `IP` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Date` date NOT NULL DEFAULT '0000-00-00',
    PRIMARY KEY (`ID`),
    UNIQUE KEY `IP` (`IP`,`Date`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_visitors_log` (
                                   `ID` int NOT NULL AUTO_INCREMENT,
                                   `Date` date NOT NULL,
                                   `Visitors` int NOT NULL DEFAULT '0',
                                   PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=3712 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_weather` (
                              `ID` int NOT NULL AUTO_INCREMENT,
                              `Track` int NOT NULL,
                              `Day` tinyint NOT NULL,
                              `Condition` tinyint NOT NULL,
                              `Rain` tinyint NOT NULL,
                              PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=43341 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_workout_bonuses` (
                                      `ID` int NOT NULL AUTO_INCREMENT,
                                      `Horse` int NOT NULL DEFAULT '0',
                                      `Stat` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    `Bonus` tinyint NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=11516769 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_workout_types` (
                                    `ID` int NOT NULL AUTO_INCREMENT,
                                    `Type` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
    PRIMARY KEY (`ID`)
    ) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `ff_workouts` (
                               `ID` int NOT NULL AUTO_INCREMENT,
                               `Horse` int NOT NULL DEFAULT '0',
                               `Jockey` int NOT NULL DEFAULT '0',
                               `Date` date NOT NULL DEFAULT '0000-00-00',
                               `DTSC` tinyint NOT NULL,
                               `Condition` tinyint NOT NULL,
                               `Location` int NOT NULL DEFAULT '0',
                               `Activity1` tinyint NOT NULL,
                               `Distance1` tinyint NOT NULL DEFAULT '0',
                               `Activity2` tinyint DEFAULT NULL,
                               `Distance2` tinyint DEFAULT NULL,
                               `Activity3` tinyint DEFAULT NULL,
                               `Distance3` tinyint DEFAULT NULL,
                               `Effort` tinyint NOT NULL DEFAULT '0',
                               `Equipment` tinyint DEFAULT NULL,
                               `confidence` int DEFAULT '0',
                               `Comment` tinyint NOT NULL,
                               `Time` double(6,2) DEFAULT NULL,
    `Rank` int DEFAULT NULL,
    PRIMARY KEY (`ID`),
    KEY `date` (`Date`) USING BTREE,
    KEY `date_location` (`Date`,`Location`) USING BTREE,
    KEY `horse` (`Horse`) USING BTREE,
    KEY `horse_date` (`Horse`,`Date`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=12332681 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `horse_broodmares_mv` (
                                       `horse_id` int unsigned NOT NULL AUTO_INCREMENT,
                                       `horse_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `height` double(22,0) DEFAULT NULL,
    `allele` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `color_id` int DEFAULT NULL,
    `color` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_id` int DEFAULT NULL,
    `sire_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_id` int DEFAULT NULL,
    `dam_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_sire_id` int DEFAULT NULL,
    `sire_sire_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_dam_id` int DEFAULT NULL,
    `sire_dam_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_sire_id` int DEFAULT NULL,
    `dam_sire_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_dam_id` int DEFAULT NULL,
    `dam_dam_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_sire_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_dam_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_sire_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_dam_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dirt_level` int DEFAULT NULL,
    `dirt_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `turf_level` int DEFAULT NULL,
    `turf_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sc_level` int DEFAULT NULL,
    `sc_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sprint_level` int DEFAULT NULL,
    `sprint_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `classic_level` int DEFAULT NULL,
    `classic_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `endurance_level` int DEFAULT NULL,
    `endurance_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `race_record` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `starts` int NOT NULL DEFAULT '0',
    `earnings` bigint NOT NULL DEFAULT '0',
    `points` int NOT NULL DEFAULT '0',
    `title` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    PRIMARY KEY (`horse_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=58461 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `horse_parents_mv` (
                                    `horse_id` int unsigned NOT NULL AUTO_INCREMENT,
                                    `foal_count` int NOT NULL DEFAULT '0',
                                    `racers_count` int NOT NULL DEFAULT '0',
                                    `winners_count` int NOT NULL DEFAULT '0',
                                    `titled_horses_count` int NOT NULL DEFAULT '0',
                                    `stakes_winners_count` int NOT NULL DEFAULT '0',
                                    `multi_stakes_winners_count` int NOT NULL DEFAULT '0',
                                    `millionaires_count` int NOT NULL DEFAULT '0',
                                    `total_foal_earnings` bigint NOT NULL DEFAULT '0',
                                    `dirt_runners_count` int NOT NULL DEFAULT '0',
                                    `dirt_otb_count` int NOT NULL DEFAULT '0',
                                    `dirt_level` int NOT NULL DEFAULT '0',
                                    `dirt_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `turf_runners_count` int NOT NULL DEFAULT '0',
    `turf_otb_count` int NOT NULL DEFAULT '0',
    `turf_level` int NOT NULL DEFAULT '0',
    `turf_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `sc_runners_count` int NOT NULL DEFAULT '0',
    `sc_otb_count` int NOT NULL DEFAULT '0',
    `sc_level` int NOT NULL DEFAULT '0',
    `sc_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `sprinters_count` int NOT NULL DEFAULT '0',
    `sprinters_otb_count` int NOT NULL DEFAULT '0',
    `sprinters_level` int NOT NULL DEFAULT '0',
    `sprinters_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `classic_count` int NOT NULL DEFAULT '0',
    `classic_otb_count` int NOT NULL DEFAULT '0',
    `classic_level` int NOT NULL DEFAULT '0',
    `classic_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `endurance_count` int NOT NULL DEFAULT '0',
    `endurance_otb_count` int NOT NULL DEFAULT '0',
    `endurance_level` int NOT NULL DEFAULT '0',
    `endurance_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `fast_runners_count` int NOT NULL DEFAULT '0',
    `fast_otb_count` int NOT NULL DEFAULT '0',
    `fast_level` int NOT NULL DEFAULT '0',
    `fast_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `good_runners_count` int NOT NULL DEFAULT '0',
    `good_otb_count` int NOT NULL DEFAULT '0',
    `good_level` int NOT NULL DEFAULT '0',
    `good_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `wet_runners_count` int NOT NULL DEFAULT '0',
    `wet_otb_count` int NOT NULL DEFAULT '0',
    `wet_level` int NOT NULL DEFAULT '0',
    `wet_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `slow_runners_count` int NOT NULL DEFAULT '0',
    `slow_otb_count` int NOT NULL DEFAULT '0',
    `slow_level` int NOT NULL DEFAULT '0',
    `slow_level_text` varchar(40) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'Maiden',
    `breed_ranking_id` int DEFAULT NULL,
    `breed_ranking_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `broodmare_sire_ranking_id` int DEFAULT NULL,
    `broodmare_sire_ranking_name` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    PRIMARY KEY (`horse_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=60197 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `horse_racehorses_mv` (
                                       `horse_id` int NOT NULL,
                                       `horse_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `age` tinyint DEFAULT NULL,
    `gender` enum('C','F','G','M','S') CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `leased` tinyint(1) NOT NULL DEFAULT '0',
    `leaser` int DEFAULT '0',
    `owner` int DEFAULT '0',
    `location` int DEFAULT '0',
    `track_name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `entered_to_race` tinyint(1) NOT NULL DEFAULT '0',
    `in_transit` tinyint(1) NOT NULL DEFAULT '0',
    `boarded` tinyint NOT NULL DEFAULT '0',
    `can_be_sold` tinyint(1) NOT NULL DEFAULT '0',
    `flat_steeplechase` enum('F','SC') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'F',
    `energy_grade` char(1) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT NULL,
    `fitness_grade` char(1) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT NULL,
    `default_equipment` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `default_jockey` int DEFAULT NULL,
    `second_jockey` int DEFAULT NULL,
    `third_jockey` int DEFAULT NULL,
    `riding_instructions` int DEFAULT NULL,
    `wins_count` int NOT NULL DEFAULT '0',
    `allowance_wins_count` int NOT NULL DEFAULT '0',
    `last_race_id` int DEFAULT NULL,
    `last_race_finishers` int DEFAULT NULL,
    `races_count` int NOT NULL DEFAULT '0',
    `rest_days_count` int NOT NULL DEFAULT '0',
    `injury_flag_expiration` date DEFAULT NULL,
    UNIQUE KEY `horse_id` (`horse_id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `horse_stallions_mv` (
                                      `horse_id` int unsigned NOT NULL AUTO_INCREMENT,
                                      `horse_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `height` double(3,1) DEFAULT NULL,
    `allele` varchar(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `color_id` int DEFAULT NULL,
    `color` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_id` int DEFAULT NULL,
    `sire_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_id` int DEFAULT NULL,
    `dam_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_sire_id` int DEFAULT NULL,
    `sire_sire_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_dam_id` int DEFAULT NULL,
    `sire_dam_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_sire_id` int DEFAULT NULL,
    `dam_sire_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_dam_id` int DEFAULT NULL,
    `dam_dam_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_sire_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `sire_dam_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_sire_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dam_dam_dosage` varchar(3) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `dirt_level` int NOT NULL DEFAULT '0',
    `dirt_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unraced',
    `turf_level` int NOT NULL DEFAULT '0',
    `turf_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unraced',
    `sc_level` int NOT NULL DEFAULT '0',
    `sc_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unraced',
    `sprint_level` int NOT NULL DEFAULT '0',
    `sprint_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unraced',
    `classic_level` int NOT NULL DEFAULT '0',
    `classic_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unraced',
    `endurance_level` int NOT NULL DEFAULT '0',
    `endurance_level_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unraced',
    `race_record` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'Unraced',
    `starts` int NOT NULL DEFAULT '0',
    `earnings` bigint NOT NULL DEFAULT '0',
    `points` int NOT NULL DEFAULT '0',
    `title` varchar(5) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    PRIMARY KEY (`horse_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=60197 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `horse_training_schedules_mv` (
                                               `horse_id` int NOT NULL,
                                               `horse_name` varchar(18) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    `age` tinyint DEFAULT NULL,
    `gender` enum('C','F','G','M','S') CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `leased` tinyint(1) NOT NULL DEFAULT '0',
    `leaser` int DEFAULT '0',
    `owner` int DEFAULT '0',
    `flat_steeplechase` enum('F','SC') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'F',
    `energy_current` tinyint DEFAULT NULL,
    `fitness` tinyint DEFAULT NULL,
    `energy_grade` char(1) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT NULL,
    `fitness_grade` char(1) CHARACTER SET latin1 COLLATE latin1_general_cs DEFAULT NULL,
    `default_equipment` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `default_jockey` int DEFAULT NULL,
    `race_entry_id` int DEFAULT NULL,
    `default_workout_track` int DEFAULT NULL,
    `track_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
    `latest_injury_date` date DEFAULT NULL,
    `training_schedule_id` int DEFAULT NULL,
    `training_schedule_horse_id` int DEFAULT NULL,
    UNIQUE KEY `horse_id` (`horse_id`),
    KEY `leaser_leased` (`leaser`,`leased`) USING BTREE,
    KEY `owner_leased` (`owner`,`leased`) USING BTREE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `pending_retirements` (
                                       `id` int unsigned NOT NULL AUTO_INCREMENT,
                                       `horse_id` int DEFAULT NULL,
                                       `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
                                       PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=2625 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `schema_migrations` (
                                     `version` bigint NOT NULL,
                                     `inserted_at` datetime DEFAULT NULL,
                                     PRIMARY KEY (`version`)
    ) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `user_alerts` (
                               `id` int NOT NULL AUTO_INCREMENT,
                               `user_id` int DEFAULT NULL,
                               `activates_at` date NOT NULL,
                               `expires_at` date DEFAULT NULL,
                               `message` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
                               `reference_id` int DEFAULT NULL,
                               `reference_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    `read_at` date DEFAULT NULL,
    `dismissed_at` date DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `user_date` (`user_id`,`activates_at`) USING BTREE,
    KEY `user_expire` (`user_id`,`expires_at`) USING BTREE
    ) ENGINE=InnoDB AUTO_INCREMENT=843 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE `user_preferences` (
                                    `user_id` int unsigned NOT NULL AUTO_INCREMENT,
                                    `training_energy_minimum` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
    PRIMARY KEY (`user_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=4090 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `users` (
                         `id` bigint unsigned NOT NULL AUTO_INCREMENT,
                         `email` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    `password_hash` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
    `sessions` text CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci,
    `legacy_user_id` int DEFAULT NULL,
    `inserted_at` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `legacy_user_id` (`legacy_user_id`),
    CONSTRAINT `users_ibfk_1` FOREIGN KEY (`legacy_user_id`) REFERENCES `ff_users` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
    ) ENGINE=InnoDB AUTO_INCREMENT=4626 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
