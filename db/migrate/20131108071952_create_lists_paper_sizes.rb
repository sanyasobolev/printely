class CreateListsPaperSizes < ActiveRecord::Migration
  def change
    create_table :lists_paper_sizes do |t|
      t.string :size
      t.string :size_iso_216
      t.timestamps
    end
    Lists::PaperSize.create(:size => '10x15', :size_iso_216 => 'A6')
    Lists::PaperSize.create(:size => '21x29,7', :size_iso_216 => 'A4')
  end
end
