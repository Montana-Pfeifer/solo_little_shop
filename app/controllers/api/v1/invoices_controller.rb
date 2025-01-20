require 'rails_helper'

class Api::V1::InvoicesController < ApplicationController

  def index

    merchant = Merchant.find(params[:merchant_id])

    if params[:status].present?
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

    render json: InvoiceSerializer.format_invoices(invoices)
  end
end