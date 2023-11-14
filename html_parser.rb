require 'nokogiri'
require 'open-uri'

class LibraryParser
    def initialize(url)
        @page = Nokogiri::HTML(URI.open(url))
    end


    def parse_library_names
        collected_data = []
        collect_all_parts_of_li = []
            (1..26).each do |number|
                xpath_query = "//h2[span[@class='mw-headline' and text()='Alphabetical']]/following-sibling::ul[#{number}]"
                alphabetical_h2 = @page.at_xpath(xpath_query)

                if alphabetical_h2
                    list_items = alphabetical_h2.xpath('.//li')

                    list_items.each_with_index do |li, index|
                        li.children.each do |child|
                            collect_all_parts_of_li.push(child.text)
                        end

                        string_from_collected_data = collect_all_parts_of_li.join
                        part_before_comma = string_from_collected_data.split(',').first
                        collected_data.push(remove_opening_parenthesis(part_before_comma))
                        collect_all_parts_of_li.clear

                    end
                else
                    puts "\nul not found"
                end
            end
        collected_data
    end


    private
    def remove_opening_parenthesis(text) # this method is not required, it does not affect parsing, it is only responsible for the “style” of libs names
        if text.include?('(') && !text.include?(')')
            text = text.gsub('(', '')
        end
        text
    end
end