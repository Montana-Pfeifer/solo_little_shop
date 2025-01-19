class AddUniqueIndexOnCodeAndMerchantIdToCoupons < ActiveRecord::Migration[6.0]
  def change
    add_index :coupons, [:code, :merchant_id], unique: true
  end
end
