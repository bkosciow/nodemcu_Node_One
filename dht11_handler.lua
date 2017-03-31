local mydht_handler = {}
mydht_handler.__index = mydht_handler

setmetatable(mydht_handler, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function mydht_handler.new(node)
    local self = setmetatable({}, mydht_handler)
    self.node = node
   
    return self
end   

function mydht_handler:handle(socket, message, port, ip)
    response = false
    if message ~= nil and message.event ~= nil then
        if message.event == 'dht.readings' then
            message = network_message.prepareMessage()
            message.response = self.node:get_readings()
            network_message.sendMessage(socket, message, port, ip)
            response = true

        end
    end

    return response
end

return mydht_handler