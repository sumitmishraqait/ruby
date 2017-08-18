require 'rubygems'
require 'colorize'
require 'nokogiri'

# Do Not Remove This File

class ReadXMLdata
  def setup(xml_file)
    doc = Nokogiri::XML(File.open(xml_file))
  end

  # Method to read value from XML for a parameter by its xpath
  def fetch_val_by_xpath(doc, xpath)
    arr = Array.new
      @block = doc.xpath(xpath).map { |node| node.children.text }
      for i in 0..@block.size - 1
        arr[i] = @block[i]
      end
    puts "XML data read complete...".green
    return arr
  end

  def teardown(doc)
    doc = nil
  end
end