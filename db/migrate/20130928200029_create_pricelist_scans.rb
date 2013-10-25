# encoding: utf-8
class CreatePricelistScans < ActiveRecord::Migration
  def self.up
    create_table :pricelist_scans do |t|
      t.string :work_name
      t.string :work_desc
      t.float  :price_min, :default => 0
      t.float  :price_max, :default => 0
      t.timestamps
    end
    
  PricelistScan.create(
    :id => '1',
    :work_name => 'scan',
    :work_desc => 'Сканирование документов')

  PricelistScan.create(
    :id => '2',
    :work_name => 'base_correction',
    :work_desc => 'Базовая коррекция')
    
  PricelistScan.create(
    :id => '3',
    :work_name => 'coloring',
    :work_desc => 'Раскраска')
    
  PricelistScan.create(
    :id => '4',
    :work_name => 'restoration',
    :work_desc => 'Реставрация')    
  end
  
  def self.down
    drop_table :pricelist_scans
  end
end
