module Puppet
  newtype(:ipsec_secret) do
    ensurable

    newproperty(:type) do
      desc "Type of secret. Supported: RSA, ECDSA."
      newvalue(:RSA)
      newvalue(:ECDSA)
      aliasvalue(:rsa, :RSA)
      aliasvalue(:ecdsa, :ECDSA)

    end

    newproperty(:target) do
      desc "The file in which to store service information. Defaults to `/etc/ipsec.secrets`."

      defaultto {
        if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
          @resource.class.defaultprovider.default_target
        else
          nil
        end
      }

    end

    autorequire(:file) do
      value(:target)
    end

    newparam(:name) do
      desc "The secret name. For RSA and ECDSA types it's private key filename."

      isnamevar

    end

    @doc = "Installs and manages IPsec secrets. Right now only RSA and ECDSA types are
      supported. There is no passphrase support."
  end
end
