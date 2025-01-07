require 'rails_helper'

describe Transaction do
  describe "relationships" do
    it { should belong_to :invoices }
  end
end