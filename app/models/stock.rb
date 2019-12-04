class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks
  
  def self.find_by_(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
  
  def self.new_from_lookup(ticker_symbol)
    begin
      client = IEX::Api::Client.new(publishable_token: 'pk_29e8610e20b645abaffb0441b873a420')
      looked_up_stock = client.quote(ticker_symbol)
      new(name: looked_up_stock.company_name, 
          ticker: looked_up_stock.symbol, last_price: looked_up_stock.latest_price)
    rescue Exception => e
      return nil
    end
  end
  
  def self.strip_commas(number)
    number.gsub(",","")
  end
end
