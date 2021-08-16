module Cryptoexchange::Exchanges
  module Whitebit
    module Services
      class Trades < Cryptoexchange::Services::Market
        def fetch(market_pair)
          output = super(ticker_url(market_pair))
          adapt(output, market_pair)
        end

        def ticker_url(market_pair)
          "#{Cryptoexchange::Exchanges::Whitebit::Market::API_URL}/v1/public/history?market=#{market_pair.base}_#{market_pair.target}&lastId=0&limit=100"
        end

        def adapt(output, market_pair)
          output.collect do |trade|
            tr = Cryptoexchange::Models::Trade.new
            tr.trade_id  = trade['id']
            tr.base      = market_pair.base
            tr.target    = market_pair.target
            tr.market    = Whitebit::Market::NAME
            tr.type      = trade['type']
            tr.price     = trade['price']
            tr.amount    = trade['amount']
            tr.timestamp = trade['time'].to_i
            tr.payload   = trade
            tr
          end
        end
      end
    end
  end
end
