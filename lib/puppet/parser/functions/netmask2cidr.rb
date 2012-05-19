# Convert netmask to cidr notation
Puppet::Parser::Functions::newfunction(:netmask2cidr,
    :type => :rvalue,
    :doc  => "Convert netmask to cidr notation") do |args|

    require 'ipaddr'

    raise(Puppet::ParseError, "netmask2cidr(): Expected one argument but " +
                "given #{args.size}") if args.size != 1

    return IPAddr.new(args[0]).to_i.to_s(2).count('1')

end
