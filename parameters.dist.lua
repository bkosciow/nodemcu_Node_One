_WIFI_APS = {
    {["ssid"]="", ["pwd"]=""},
    {["ssid"]="", ["pwd"]=""}
}
PROTOCOL = "iot:1"
PORT = 5053
CHANNELS = {1}
if file.exists('parameters-device.lc') then  
    dofile("parameters-device.lc")        
else
    dofile("parameters-device.lua")        
end
