local pir_hcs_sr501_handler = {}
pir_hcs_sr501_handler.__index = pir_hcs_sr501_handler

setmetatable(pir_hcs_sr501_handler, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function pir_hcs_sr501_handler.new(node, callback)
    local self = setmetatable({}, pir_hcs_sr501_handler)
    self.node = node
    self.callback = callback
    return self
end   

function pir_hcs_sr501_handler:handle(socket, message, port, ip)
    response = false
    if message ~= nil and message.event ~= nil then
        if message.event == 'pir.move' then
            message = network_message.prepareMessage()
            message.response = self.node:get_state()
            network_message.sendMessage(socket, message, port, ip)
            if self.callback ~= nil then
                self.callback(self.node:get_state())
            end
            response = true
        end
    end

    return response
end

return pir_hcs_sr501_handler
