require 'rubygems'
require 'date'
require 'nokogiri'
require 'open-uri'

# Database
# 
# auctions
#  id
#  end date
#  desc
#  title
#
# products
#  id
#  name
#  desc
#  image_url
#  image
#
# product_auctions
#  id
#  auction_id
#  product_id
#  lot
#  auction_url
#  reserve_met
#  final_bid
#  
#


# Month/Weekday strings used to filter out date of auction
$date_strings = [Date::DAYNAMES, Date::MONTHNAMES].flatten
$date_strings.delete(nil)

# Search for weekdays then months to parse date
def parse_auction_date(auction_title)
  auction_title.downcase!
  $date_strings.each do |date_str|
    found_index = auction_title.index(date_str.downcase)
    if !found_index.nil?
      return auction_title.slice(found_index, auction_title.length)
    end
  end
  nil
end

page = Nokogiri::HTML(open('index.html'))

auction_title = ""
product_array = []
final_array = []

product_array = page.css('a[href].prodbox')
auction_title = page.css('div.menu > h1').text
puts auction_title
puts parse_auction_date(auction_title)
auction = auction_title.split('Until')[0]
auction_end = auction_title.split('Until')[1]
exit
product_array.each_with_index do |e, i|
  puts "Auction: #{auction}"
  puts "End Date: #{auction_end}"
  p_url = e['href']
  puts "Product URL: " + p_url.to_s
  img = e.css('img')[0]
  puts "Product IMG: " + img['src'].to_s
  p_title = e.css('span.prodtitle').text
  p_lot = p_title.slice(/Lot [0-9]{6,} /).strip
  puts "Lot: " + p_lot
  p_name = p_title.slice(p_lot.length + 1, p_title.length).strip
  puts "Product: " + p_name
  p_desc = e.css('span.prodlongdesc').text.strip
  p_sold = e.css('span.priceline').text
  p_met_reserve = !p_sold.downcase.include?('reserve')
  puts "Reserve met: " + p_met_reserve.to_s
  final_bid = p_sold.gsub(/[^0-9.]/, '')
  puts "Final Bid: " + final_bid.to_s unless !p_met_reserve
  #puts e 
  #exit unless i < 10
end


