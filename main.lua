print ("core ready")

network_message = require "network_message"
server_listener = require "server_listener"
message_crypt_base64 = require "message_crypt_base64"
message_crypt_aessha1 = require "message_crypt_aessha1"

send_socket = net.createUDPSocket()

network_message.encryptor = message_crypt_aessha1
--message_crypt_base64
network_message.addDecryptor(message_crypt_base64)
network_message.addDecryptor(message_crypt_aessha1)


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

relay_handler = require "relay_handler"
switch_handler = relay_handler(CHANNELS, 1)

server_listener.add("dht", dht_handler)
server_listener.add("motion", motion_handler)
server_listener.add("light", light_handler)
server_listener.add("relay", switch_handler)

server_listener.start(PORT)
