print ("core ready")

network_message = require "network_message"
server_listener = require "server_listener"

send_socket = net.createUDPSocket()

dht11 = require "dht11"
dht11_handler = require "dht11_handler"
mydht = dht11(5, send_socket, nil, 5000)
dht_handler = dht11_handler(mydht)

pir = require "pir_hcs_sr501"
pir_handler = require "pir_hcs_sr501_handler"
motion = pir(send_socket, 2)
motion_handler = pir_handler(motion)

light_sensor = require "light_detector"
light_sensor_handler = require "light_detector_handle"
light = light_sensor(send_socket, 6, nil, 2000)
light_handler = light_sensor_handler(light)

function send_response(action, channel)
    message = network_message.prepareMessage()
    states = {}
    for k,v in pairs(CHANNELS) do
        states[k] = gpio.read(v) == 0 and 1 or 0
    end    
    message.response = states
    message.event = "channels.response"
    network_message.sendMessage(send_socket, message)
end
relay_handler = require "relay_handler"
switch_handler = relay_handler(CHANNELS, send_response)


server_listener.add("dht", dht_handler)
server_listener.add("motion", motion_handler)
server_listener.add("light", light_handler)
server_listener.add("relay", switch_handler)

server_listener.start(PORT)
