class LoadFtpDataSource
    #TODO: initialize with ftp credentials
    def initialize
        load_ftp_data!
    end

    def chassis_data
        return @chassis
    end

    def cars_data
        return @cars
    end

    def chassis_model_data
        return @chassis_models
    end

    def plus_sizes_data
        return @plus_sizes
    end

    def lifted_kit_data
        return @lifted_kits
    end

    def minus_sizes_data
        return @minus_sizes
    end

    private
    def load_ftp_data!
        Net::FTP.open('ftp.fitmentgroup.com') do |ftp|
            ftp.login('wheelhippo', 'WheelHippo11W27')

            ftp.chdir('LiftedApplications')
            ftp.gettextfile('PlusSizes_LiftedOther.csv')
            @lifted_kits = File.new('PlusSizes_LiftedOther.csv')

            ftp.chdir('../FitmentData')
            ftp.gettextfile('Chassis.csv')
            @chassis = File.new('Chassis.csv')

            ftp.gettextfile('ChassisModels.csv')
            @chassis_models = File.new('ChassisModels.csv')

            ftp.gettextfile('PlusSizes.csv')
            @plus_sizes = File.new('PlusSizes.csv')

            ftp.gettextfile('MinusSizes.csv')
            @minus_sizes = File.new('MinusSizes.csv')

            files = ftp.chdir('tireandwheel')
            ftp.gettextfile('tirewheel-smart-submodel-vehicles.csv')
            @cars = File.new('tirewheel-smart-submodel-vehicles.csv')
        end
    end 
end
