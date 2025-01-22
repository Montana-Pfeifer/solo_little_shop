class Api::V1::InvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])

    if params[:status].present?
      valid_statuses = ['shipped', 'returned', 'packaged']
      unless valid_statuses.include?(params[:status])
        return render json: { error: "Invalid status parameter" }, status: :unprocessable_entity
      end

      case params[:status]
      when 'shipped'
        invoices = Invoice.find_shipped_invoices(merchant)
      when 'returned'
        invoices = Invoice.find_returned_invoices(merchant)
      when 'packaged'
        invoices = Invoice.find_packaged_invoices(merchant)
      end
    else
      invoices = Invoice.find_all_invoices(merchant)
    end

    if invoices.empty?
      return render json: { data: [] }, status: :ok
    end

    render json: InvoiceSerializer.format_invoices(invoices), status: :ok
  end
end
