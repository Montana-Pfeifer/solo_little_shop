class AddCouponIdToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :coupon_id, :integer
    add_index :invoices, :coupon_id
    add_foreign_key :invoices, :coupons
  end
end
