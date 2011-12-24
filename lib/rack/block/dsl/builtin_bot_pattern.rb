# patterns barrowed from CodeIgniter's helper
# thanks:
# https://github.com/EllisLab/CodeIgniter/blob/develop/application/config/user_agents.php#L200
# http://www.useragentstring.com/pages/useragentstring.php
# TODO more more bot sample
module Rack::Block::DSL
  module Matchers
    BUILTIN_BOT_PATTERN = /#{
      ["Googlebot",
       "MSNBot",
       "Bing",
       "Inktomi Slurp",
       "Yahoo",
       "AskJeeves",
       "FastCrawler",
       "InfoSeek Robot 1.0",
       "Baiduspider",
       "Lycos"].join("|")
    }/i
  end
end
