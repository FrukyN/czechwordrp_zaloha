local ox_inventory = exports.ox_inventory

lib.callback.register('nbs_item_tags:server:addTag', function(source, slot, text)
    local item = ox_inventory:GetSlot(source, slot)
    if not item then return false end

    local metadata = item.metadata or {}
    metadata.original_label = metadata.original_label or item.label
    metadata.label = text

    ox_inventory:SetMetadata(source, slot, metadata)
    return true
end)

lib.callback.register('nbs_item_tags:server:removeTag', function(source, slot)
    local item = ox_inventory:GetSlot(source, slot)
    if not item then return false end

    local metadata = item.metadata or {}
    if metadata.original_label then
        metadata.label = metadata.original_label
        metadata.original_label = nil
    else
        metadata.label = item.name -- fallback
    end

    ox_inventory:SetMetadata(source, slot, metadata)
    return true
end)
