local net = require "net"

local commands = {}

function register_command(name, func)
  commands[name] = func
end

function execute_command(command_string)
  local args = {}
  for word in command_string:gmatch("%S+") do
    table.insert(args, word)
  end

  local command = args[1]
  local func = commands[command]

  if func then
    func(table.unpack(args, 2))
  else
    print("Unknown command: " .. command)
  end
end

function main_loop()
  while true do
    io.write("> ")
    local command = io.read()
    execute_command(command)
  end
end

-- commands

register_command("help", function()
    print("check: Check if a network connection is available.")
    print("getError: Get the last network related error message.")
    print("ip: Get current local IPv4 address.")
    print("publicip: Get the current public IPv4 address.")
    print("resolve [hostname]: Resolve hostname to IP.")
    print("reverse [ip]: Get the fully qualified domain from an IP address.")
    print("urlparse [url]: Parse an URL into components.")
    print("adapters [family]: Iterate over installed network adapters (family accepts 'ipv4' or 'ipv6', default ipv4)")
end)

register_command("check", function()
  if net.isalive then
    print("Currently connected to a network.")
  else
    print("Not currently connected to a network.")
  end
end)

register_command("getError", function()
  if not net.error then
    print("No recent network errors.")
  else
    print(net.error)
  end
end)

register_command("ip", function()
    print("Local IPv4 address:"..net.ip)
end)

register_command("publicip", function()
    print("Public IPv4 address:"..net.publicip)
end)

register_command("resolve", function(hostname)
    print("IP for "..hostname..": "..net.resolve(hostname))
end)

register_command("reverse", function(ip)
    print(net.reverse(ip))
end)

register_command("urlparse", function(url)
    local scheme, hostname, path, parameters = net.urlparse(url)
    print(scheme, hostname, path, parameters)
end)

register_command("adapters", function(family)
  print("Available Network adapters :")
  for name, ip in net.adapters(family or "ipv4") do
    print(ip[1].."\t"..name)
  end
end)

register_command("getmime", function(file)
    local mime = net.getmime(file)
    print("MIME type: "..mime)
end)

register_command("httpget", function(url, path)
    net.Http(url):get(path or "/").after = function (client, response)
      print(response)
    end
    
end)


print("NetTools by Connor Merk")
print("Enter any command or 'help' to view commands.")

main_loop()
