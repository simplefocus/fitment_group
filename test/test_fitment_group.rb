# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/fitment_group'
require_relative '../lib/db_tasks'
require_relative '../lib/load_ftp_data_source'


class TestFitmentGroup < Minitest::Test
#TODO: define connection first and initiate it so we dont have to connect everytime

  # def test_db_task
  #   data_source = LoadFtpDataSource.new()
  #   db = DbTasks.new('localhost', 'root_user', 'P@s$w0rd123!', 'fitmenßt_group', data_source)
  #   db.create_tables()
  #   db.populate_tables()
  # end

  # def test_not_staggered_accura_fmk_returns
  #   fg = FitmentGroupLookup.new('localhost', 'root_user', 'P@s$w0rd123!', 'fitment_group')
  #   fmks = fg.start("8.5x19","5x120","64.10","1452","40")
  #   assert_includes(fmks, 222744)
  # end

  def test_lifted_kits
    fg = FitmentGroupLookup.new('localhost', 'root_user', 'P@s$w0rd123!', 'fitment_group')
    fmks = fg.start("10x20","5x139.7","87","2900","-24")
    assert_includes(fmks, 25864)
  end

  # def test_wheel_fits_staggered_Aston_Martin
  #   fitment_lookup =  FitmentGroupLookup.new('localhost', 'root_user', 'P@s$w0rd123!', 'fitment_group')
  #   fmks = fitment_lookup.start("10x22","5x128","75.10","1584","25") 
  #   assert_includes(fmks, 225573)
  # end

  #  def test_wheel_staggered_fitting_only_rear
  #   fitment_lookup =  FitmentGroupLookup.new('localhost', 'root_user', 'P@s$w0rd123!', 'fitment_group')
  #   fmks = fitment_lookup.start("10.5x22","5x112","66.70","1672","30")
  #   assert_includes(fmks, 201582)
  # end

  #   def test_returns_only_fmks
  #     fitment_lookup =  FitmentGroupLookup.new('localhost', 'root_user', 'P@s$w0rd123!', 'fitment_group')
  #       fmks = fitment_lookup.start("10x22","5x128","75.10","1672","30")
  #     fmks.each do |fmk|
  #       assert_instance_of(Integer, fmk)
  #     end
  # end

  # def test_plus_size_wheel_retrieves_right_fmk
  #   fitment_lookup =  FitmentGroupLookup.new('localhost', 'root_user', 'P@s$w0rd123!', 'fitment_group')
  #   fmks = fitment_lookup.start("9.5x22", "5x120", "64.10", "1485","40")
  #   assert_includes(fmks, 223247)
  # end

end
