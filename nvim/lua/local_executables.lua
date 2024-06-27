-- Determine the path separator (':' on Unix, ';' on Windows)
local function _get_pathsep()
    if package.config:sub(1, 1) == '\\' then
        return ';'
    else
        return ':'
    end
end

-- Function to construct and verify the absolute path
local function _get_executable_path(dir, name)
    local full_path = vim.fn.join({ dir, name }, "/")

    if vim.fn.executable(full_path) == 1 then
        return vim.fn.fnamemodify(full_path, ":p")
    end
    return nil
end

local function find_executable_prefer_non_mason(executable)
    local path_separator = _get_pathsep()
    local path_components = vim.split(vim.env.PATH, path_separator, { plain = true })
    local non_mason_paths = {}
    local mason_paths = {}

    for _, component in ipairs(path_components) do
        if component:find(".local/share/nvim/mason") then
            table.insert(mason_paths, component)
        else
            table.insert(non_mason_paths, component)
        end
    end

    -- Search non-mason paths first
    for _, path in ipairs(non_mason_paths) do
        local exec_path = _get_executable_path(path, executable)
        if exec_path then
            return exec_path
        end
    end

    -- If not found, search mason paths
    for _, path in ipairs(mason_paths) do
        local exec_path = _get_executable_path(path, executable)
        if exec_path then
            return exec_path
        end
    end

    -- If not found anywhere, return nil
    return nil
end

return {
    find_executable_prefer_non_mason = find_executable_prefer_non_mason
}
