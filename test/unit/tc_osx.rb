require File.dirname(__FILE__) + '/../test_helper'

class TC_OsxTest < Test::Unit::TestCase
  def setup
    sample = IO.readlines("#{File.dirname(__FILE__)}"+
                          "/../../ifconfig_examples/osx.txt").join
    @cfg = IfconfigWrapper.new('BSD',sample).parse
  end

  def test_interface_list
    assert(@cfg.interfaces.sort == ["en0", "en1", "en2", "fw0", "lo0"].sort,
           "Failed to parse all interfaces")
  end

  def test_mac_parse
    assert(@cfg['en0'].mac == "00:03:93:0a:16:76",
    "Failed to parse MAC address: "+@cfg['en0'].mac)
  end

  def test_flags
    assert(@cfg['en0'].flags.include?('BROADCAST') &&
          @cfg['en0'].flags.include?('RUNNING') &&
          @cfg['en0'].flags.include?('MULTICAST') &&
          @cfg['en0'].up?,
           "FLAG Parsing failed: #{@cfg['en0'].flags}")
  end

  def test_addr_types
    assert(@cfg['en1'].addr_types.include?('inet') &&
           @cfg['en1'].addr_types.include?('inet6'),
           "Failed to parse all address types")
  end

  def test_attribs
    assert(@cfg['en0'].rx['bytes'].class == Fixnum || NilClass &&
           @cfg['en0'].tx['bytes'].class == Fixnum || NilClass, "Wrong class")

  end

end
