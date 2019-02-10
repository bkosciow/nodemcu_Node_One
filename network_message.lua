local network_message = {}
network_message.validateMessage = function(json)                
    if json == nil or json['protocol'] ~= PROTOCOL or type(json['targets']) ~= 'table' then
        return false
     end    

     isTarget = false
     for k,v in pairs(json['targets']) do
        if v == NODE_ID or v == 'ALL' then isTarget = true end
     end

    return isTarget
end
    
network_message.decodeMessage = function(message)        
    ok, json = pcall(sjson.decode, message)
    if not ok or not network_message.validateMessage(json) then
        json = nil
    end
    
    return json
end

network_message.prepareMessage = function()
    data = {}
    data.protocol = PROTOCOL
    data.node = NODE_ID
    data.chip_id = node.chipid()
    data.event = ''
    data.response = ''
    data.targets = {'ALL'}

    return data
end

network_message.sendMessage = function(socket, message, port, ip)
    ok, json = pcall(sjson.encode, message)    
    if ok then
        print(json)        
        if port == nil then port = PORT end
        if ip == nil then ip =  wifi.sta.getbroadcast() end        
        socket:send(port, ip, json)  
        return true 
    end   
    
    return false
end    

return network_message    
