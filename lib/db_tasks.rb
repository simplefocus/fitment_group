require 'mysql2'
require 'csv'
require 'net/ftp'

class DbTasks
    def initialize(host, user, pw, db, fg_datasource)
        @client = Mysql2::Client.new(:host => 'localhost', :username => 'root_user', :password => 'P@s$w0rd123!', :database => 'fitment_group')
        @fg_datasource = fg_datasource
    end

    def  create_tables
        @client.query("
            CREATE TABLE if not exists minus_sizes (
                ChassisID integer, 
                WheelSize VARCHAR(255), 
                TireSize VARCHAR(255), 
                FrontRearOrBoth VARCHAR(255), 
                OffsetMin INTEGER NOT NULL, 
                OffsetMax INTEGER NOT NULL, 
                PRIMARY KEY (ChassisID,WheelSize,OffsetMin,OffsetMax)
           );
        ")

        @client.query("
            CREATE TABLE if not exists plus_sizes(
                ChassisID INT NOT NULL,
                PlusSizeType VARCHAR(255), 
                WheelSize VARCHAR(255), 
                Tire1 VARCHAR(255), 
                Tire2 VARCHAR(255), 
                Tire3 VARCHAR(255), 
                Tire4 VARCHAR(255), 
                Tire5 VARCHAR(255), 
                Tire6 VARCHAR(255), 
                Tire7 VARCHAR(255), 
                Tire8 VARCHAR(255), 
                OffsetMin INTEGER NOT NULL, 
                OffsetMax INTEGER NOT NULL, 
                PRIMARY KEY (ChassisID, WheelSize,OffsetMin,OffsetMax)
           );           
        ")

        @client.query("
            CREATE TABLE if not exists chassis_models (
                ChassisID INT NOT NULL,
                ModelID INT NOT NULL,
                PMetric VARCHAR(255),
                TireSize VARCHAR(255),
                LoadIndex VARCHAR(255),
                SpeedRating VARCHAR(255),
                TireSizeRear VARCHAR(255),
                LoadIndexRear VARCHAR(255),
                SpeedRatingRear VARCHAR(255),
                WheelSize VARCHAR(255),
                WheelSizeRear VARCHAR(255),
                RunflatFront VARCHAR(255),
                RunflatRear VARCHAR(255),
                ExtraLoadFront VARCHAR(255),
                ExtraLoadRear VARCHAR(255),
                TPFrontPSI VARCHAR(255),
                TPRearPSI VARCHAR(255),
                OffsetMinF INTEGER NOT NULL, 
                OffsetMaxF INTEGER NOT NULL, 
                OffsetMinR INTEGER, 
                OffsetMaxR INTEGER, 
                RimWidth VARCHAR(255), 
                RimDiameter VARCHAR(255), 
                PRIMARY KEY (ChassisID, ModelID)
            );
        ")

        @client.query("
            CREATE TABLE if not exists chassis (
                ChassisID int not null,
                BoltPattern  VARCHAR(255),
                Hubbore  VARCHAR(255),
                HubboreRear  VARCHAR(255),
                MaxWheelLoad  INTEGER,
                Nutorbolt    VARCHAR(255),
                NutBoltThreadType    VARCHAR(255),
                NutBoltHex   VARCHAR(255),
                BoltLength VARCHAR(255),
                Minboltlength VARCHAR(255),
                Maxboltlength VARCHAR(255),
                NutBoltTorque VARCHAR(255),
                AxleWeightFront VARCHAR(255),
                AxleWeightRear  VARCHAR(255),
                TPMS VARCHAR(255),
                DriveTypeName   VARCHAR(255),
                VCDB_RegionID   VARCHAR(255),
                RegionName  VARCHAR(255),
                CustomNote  VARCHAR(255),
                PMetric VARCHAR(255),
                TireSize VARCHAR(255),
                LoadIndex     VARCHAR(255),
                SpeedIndex    VARCHAR(255),
                LoadRange   VARCHAR(255),
                TireSizeR   VARCHAR(255),
                LoadIndexR  VARCHAR(255),
                SpeedIndexR VARCHAR(255),
                LoadRangeR  VARCHAR(255),
                RimWidth VARCHAR(255),
                RimDiameter VARCHAR(255),
                RimSize VARCHAR(255),
                RimWidthR   VARCHAR(255),
                RimDiameterR VARCHAR(255),
                RimSizeR VARCHAR(255),
                BoltPattern2 VARCHAR(255),
                Hubbore2 VARCHAR(255),
                HubboreR VARCHAR(255),
                IsStaggered VARCHAR(255),
                SmartSubmodelDescription VARCHAR(255),
                NumSizesForSubmodel VARCHAR(255),
                PRIMARY KEY (ChassisID)
            );")
        @client.query("
            CREATE TABLE if not exists cars (
                FG_FMK INTEGER,
                FG_ChassisID INTEGER,
                FG_ModelID INTEGER,
                VCDB_VehicleID INTEGER,
                VCDB_BaseVehicleID INTEGER,
                Year INTEGER,
                VCDB_MakeID INTEGER,
                MakeName VARCHAR(255),
                VCDB_ModelID INTEGER, 
                ModelName VARCHAR(255),
                VCDB_SubmodelID INTEGER,
                SubmodelName VARCHAR(255),
                VCDB_BodyTypeID VARCHAR(255),
                BodyTypeName VARCHAR(255),
                VCDB_DriveTypeID VARCHAR(255),
                DriveTypeName VARCHAR(255),
                VCDB_RegionID VARCHAR(255),
                RegionName VARCHAR(255),
                CustomNote VARCHAR(255),
                PMetric VARCHAR(255),
                TireSize VARCHAR(255),
                LoadIndex VARCHAR(255),
                SpeedIndex VARCHAR(255),
                LoadRange VARCHAR(255),
                TireSizeR VARCHAR(255),
                LoadIndexR VARCHAR(255),
                SpeedIndexR VARCHAR(255),
                LoadRangeR VARCHAR(255),
                RimWidth VARCHAR(255),
                RimDiameter VARCHAR(255),
                RimSize VARCHAR(255),
                RimWidthR VARCHAR(255),
                RimDiameterR VARCHAR(255),
                RimSizeR VARCHAR(255),
                BoltPattern VARCHAR(255),
                Hubbore VARCHAR(255),
                HubboreR VARCHAR(255),
                IsStaggered VARCHAR(255),
                SmartSubmodelDescription VARCHAR(255),
                NumSizesForSubmodel VARCHAR(255),
                PRIMARY KEY (FG_FMK)
        );
        ")

        @client.query("UPDATE cars SET HubboreR=NULL WHERE HubboreR=''")
        @client.query("UPDATE cars SET RimSizeR=NULL WHERE RimSizeR=''")
    end

    def populate_tables
        # IMPORTS FROM CSV
        # show warning to see un-imported rows

        @client.query("LOAD DATA local INFILE '#{File.absolute_path(@fg_datasource.cars_data.path)}'
        INTO TABLE cars
        FIELDS TERMINATED BY ','
        ENCLOSED BY '\"'
        LINES TERMINATED BY '\\n'
        IGNORE 1 ROWS;")
        @client.query("show warnings").inspect

        @client.query("LOAD DATA LOCAL INFILE '#{File.absolute_path(@fg_datasource.chassis_data.path)}'
        INTO TABLE chassis
        FIELDS TERMINATED BY ','
        ENCLOSED BY '\"'
        LINES TERMINATED BY '\\n'
        IGNORE 1 ROWS;")
        @client.query("show warnings")

        @client.query("LOAD DATA LOCAL INFILE '#{File.absolute_path(@fg_datasource.chassis_model_data.path)}'
        INTO TABLE chassis_models
        FIELDS TERMINATED BY ','
        ENCLOSED BY '\"'
        LINES TERMINATED BY '\\n'
        IGNORE 1 ROWS;")
        @client.query("show warnings")

        @client.query(" LOAD DATA LOCAL INFILE '#{File.absolute_path(@fg_datasource.plus_sizes_data.path)}'
        INTO TABLE plus_sizes
        FIELDS TERMINATED BY ','
        ENCLOSED BY '\"'
        LINES TERMINATED BY '\\n'
        IGNORE 1 ROWS;")
        @client.query("show warnings")

        @client.query("LOAD DATA LOCAL INFILE '#{File.absolute_path(@fg_datasource.minus_sizes_data.path)}'
        INTO TABLE minus_sizes
        FIELDS TERMINATED BY ','
        ENCLOSED BY '\"'
        LINES TERMINATED BY '\\n'
        IGNORE 1 ROWS;")
        @client.query("show warnings")
    end
end