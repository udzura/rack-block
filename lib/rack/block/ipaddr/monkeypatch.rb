require 'ipaddr'

class IPAddr
  def =~(target)
    include?(target)
  end
end
