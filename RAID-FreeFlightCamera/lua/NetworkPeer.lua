local network_id = "FreeFlyCameraSync"

-- Sending
Hooks:PostHook(NetworkPeer, "send", "FFCSyncSend", function(self, func_name, ...)
    if self ~= managers.network:session():local_peer() and func_name == "lobby_info" and FreeFlightCamera.settings.allow_client_freecam then
        LuaNetworking:SendToPeer(self:id(), network_id, "1")
    end
end)

-- Receiving
Hooks:Add("NetworkReceivedData", "FFCSyncReceive", function(sender, id, data)
    if sender == 1 and id == network_id and FreeFlightCamera then
        FreeFlightCamera.host_has_mod = true
        local peer = managers.network:session():peer(sender)
        local perm = tonumber(managers.network.matchmake.lobby_handler:get_lobby_data("permission"))
        if FreeFlightCamera.settings.announce_freecam_possible and not Network:is_server() and (perm == 2 or perm == 3) then
            managers.chat:feed_system_message(
                ChatManager.GAME,
                managers.localization:text("ffc_local_announce_freecam_possible",
                    {
                        PLAYER = peer:name()
                    }
                )
            )
        end
    end
end)
