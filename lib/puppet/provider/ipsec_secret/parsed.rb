require 'puppet/provider/parsedfile'

secrets = '/etc/ipsec.secrets'

Puppet::Type.type(:ipsec_secret).provide(
  :parsed,
  :parent         => Puppet::Provider::ParsedFile,
  :default_target => secrets,
  :filetype       => :flat
) do

  text_line :comment, :match => /^#/
  text_line :blank,   :match => /^\s*$/
  text_line :include, :match => /^include\s+/

  ipsec_secret = record_line :parsed,
    :fields   => %w{sel_left sel_right type name pass},
    :optional => %w{sel_left sel_right pass},
    :match    => /^(\S+)?\s*(\S+)?\s?:\s(\w+)\s+(\S+)\s*(\S+)?$/

  class << ipsec_secret
    def to_line(hash)
      [:type, :name].each do |n|
        raise ArgumentError, "#{n} is a required attribute for ipsec_secret" unless hash[n] and hash[n] != :absent
      end
      str = ": #{hash[:type]} #{hash[:name]}"

      str
    end
  end

end

