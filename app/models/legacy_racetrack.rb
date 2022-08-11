class LegacyRacetrack < LegacyRecord
  self.table_name = "ff_trackdata"
  self.primary_key = "ID"
end

# CREATE TABLE `ff_trackdata` (
#  `ID` int NOT NULL AUTO_INCREMENT,
#  `Name` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
#  `Abbr` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
#  `Location` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
#  `DTSC` varchar(12) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
#  `Condition` varchar(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
#  `Width` smallint DEFAULT NULL,
#  `Length` smallint DEFAULT NULL,
#  `TurnToFinish` smallint DEFAULT NULL,
#  `TurnDistance` smallint DEFAULT NULL,
#  `Banking` tinyint DEFAULT NULL,
#  `Jumps` tinyint DEFAULT NULL,
#  `ID`),
# ) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

# == Schema Information
#
# Table name: ff_trackdata
#
#  Abbr         :string(5)        not null
#  Banking      :integer
#  Condition    :string(4)        indexed
#  DTSC         :string(12)       indexed
#  ID           :integer          not null, primary key
#  Jumps        :integer
#  Length       :integer
#  Location     :string(255)      not null, indexed
#  Name         :string(255)      indexed
#  TurnDistance :integer
#  TurnToFinish :integer
#  Width        :integer
#
# Indexes
#
#  Condition  (Condition)
#  DTSC       (DTSC)
#  Location   (Location)
#  Name       (Name)
#
