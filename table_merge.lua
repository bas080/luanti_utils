local function table_merge(t1, t2)
    local tbl = table.copy(t1)

    for k, v in pairs(t2) do
        tbl[k] = v
    end

    return tbl
end

return table_merge
