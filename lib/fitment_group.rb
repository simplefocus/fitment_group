# frozen_string_literal: true

require_relative "fitment_group/version"

require 'mysql2'

class FitmentGroupLookup

  def initialize(host, user, pw, db)
    @client = Mysql2::Client.new(:host => host, :username => user, :password => pw, :database => db)
  end

  def start(rim_size, bolt_pattern, hubbore, max_wheel_load, offset)
    sql = @client.prepare("
    SELECT cars.FG_FMK
    FROM cars
        join chassis ON cars.FG_ChassisID = chassis.ChassisID
        join chassis_models ON cars.FG_ChassisID = chassis.ChassisID
        AND cars.FG_ModelID = chassis_models.ModelID
    WHERE cars.RimSize = '#{rim_size}'
        AND cars.BoltPattern = '#{bolt_pattern}'
        AND cars.Hubbore <= '#{hubbore}'
        AND chassis.MaxWheelLoad <= '#{max_wheel_load}'
        AND '#{offset}' between chassis_models.OffsetMinF AND chassis_models.OffsetMaxF
    UNION
    SELECT cars.FG_FMK
    FROM cars
        join chassis ON cars.FG_ChassisID = chassis.ChassisID
        join chassis_models ON cars.FG_ChassisID = chassis.ChassisID
        AND cars.FG_ModelID = chassis_models.ModelID
    WHERE cars.IsStaggered = 'True'
        AND (
            cars.RimSizeR = '#{rim_size}'
            OR (
                cars.RimSize = '#{rim_size}'
                AND cars.RimSizeR IS NULL
            )
        )
        AND cars.BoltPattern = '#{bolt_pattern}'
        AND (
            cars.HubboreR <= '#{hubbore}'
            OR (
                cars.Hubbore <= '#{hubbore}'
                AND cars.HubboreR IS NULL
            )
        )
        AND chassis.MaxWheelLoad <= '#{max_wheel_load}'
        AND '#{offset}' between chassis_models.OffsetMinR AND chassis_models.OffsetMaxR
    UNION
    SELECT cars.FG_FMK
    FROM cars
        join chassis ON cars.FG_ChassisID = chassis.ChassisID
        join chassis_models ON cars.FG_ChassisID = chassis.ChassisID
        AND cars.FG_ModelID = chassis_models.ModelID
        join plus_sizes ON cars.FG_ChassisID = plus_sizes.ChassisID
    WHERE plus_sizes.WheelSize = '#{rim_size}'
        AND cars.BoltPattern = '#{bolt_pattern}'
        AND cars.Hubbore <= '#{hubbore}'
        AND chassis.MaxWheelLoad <= '#{max_wheel_load}'
        AND '#{offset}' between plus_sizes.OffsetMin AND plus_sizes.OffsetMax
    UNION
    SELECT cars.FG_FMK
    FROM cars
        join chassis ON cars.FG_ChassisID = chassis.ChassisID
        join chassis_models ON cars.FG_ChassisID = chassis.ChassisID
        AND cars.FG_ModelID = chassis_models.ModelID
        join lifted_kits ON cars.FG_ChassisID = lifted_kits.ChassisID
    WHERE lifted_kits.WheelSize = '#{rim_size}'
        AND cars.BoltPattern = '#{bolt_pattern}'
        AND cars.Hubbore <= '#{hubbore}'
        AND chassis.MaxWheelLoad <= '#{max_wheel_load}'
        AND '#{offset}' between lifted_kits.OffsetMin AND lifted_kits.OffsetMax
    UNION
    SELECT cars.FG_FMK
    FROM cars
        join chassis ON cars.FG_ChassisID = chassis.ChassisID
        join chassis_models ON cars.FG_ChassisID = chassis.ChassisID
        AND cars.FG_ModelID = chassis_models.ModelID
        join minus_sizes ON cars.FG_ChassisID = minus_sizes.ChassisID
    WHERE minus_sizes.WheelSize = '#{rim_size}'
        AND cars.BoltPattern = '#{bolt_pattern}'
        AND cars.Hubbore <= '#{hubbore}'
        AND chassis.MaxWheelLoad <= '#{max_wheel_load}'
        AND '#{offset}' between minus_sizes.OffsetMin AND minus_sizes.OffsetMax
     ")

    car_matches = sql.execute()
    fmks =[];
    car_matches.each do |match|
      fmks.append(match["FG_FMK"]) unless fmks.include?(match)
    end
    puts fmks
    return fmks
  end
end

