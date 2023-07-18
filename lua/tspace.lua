-- Workspace Module
local M = {}

local config = {
  path = "~/.tuk.json",
}

M.config = config

-- Create config file if it doesn't exist
local function init_configs(config_path)
  local expanded_path = vim.fn.expand(config_path)
  if vim.fn.filereadable(expanded_path) == 0 then
    local file = io.open(expanded_path, "w")
    if file then
      file:write("{}")
      file:close()
      vim.notify("Created config file: " .. expanded_path)
    else
      vim.notify("Failed to create config file: " .. expanded_path, vim.log.levels.ERROR)
    end
  end
end

-- Add project name and path to config.path
local function add_project(name, path)
  local expanded_path = vim.fn.expand(M.config.path)
  local file = io.open(expanded_path, "r")
  if file then
    local content = file:read("*all")
    file:close()
    local projects = vim.fn.json_decode(content)
    projects[name] = path
    file = io.open(expanded_path, "w")
    if file then
      file:write(vim.fn.json_encode(projects))
      file:close()
      vim.notify("Added project: " .. name)
    else
      vim.notify("Failed to write to config file", vim.log.levels.ERROR)
    end
  else
    vim.notify("Failed to read config file", vim.log.levels.ERROR)
  end
end

-- Remove project by name from config.path
local function remove_project(name)
  local expanded_path = vim.fn.expand(M.config.path)
  local file = io.open(expanded_path, "r")
  if file then
    local content = file:read("*all")
    file:close()
    local projects = vim.fn.json_decode(content)
    if projects[name] then
      projects[name] = nil
      file = io.open(expanded_path, "w")
      if file then
        file:write(vim.fn.json_encode(projects))
        file:close()
        vim.notify("Removed project: " .. name)
      else
        vim.notify("Failed to write to config file", vim.log.levels.ERROR)
      end
    else
      vim.notify("Project not found: " .. name, vim.log.levels.WARN)
    end
  else
    vim.notify("Failed to read config file", vim.log.levels.ERROR)
  end
end

-- Get project path by name from config.path
local function get_project(name)
  local expanded_path = vim.fn.expand(M.config.path)
  local file = io.open(expanded_path, "r")
  if file then
    local content = file:read("*all")
    file:close()
    local projects = vim.fn.json_decode(content)
    return projects[name]
  else
    vim.notify("Failed to read config file", vim.log.levels.ERROR)
    return nil
  end
end

-- Execute the plugin
local function execute(config)
  init_configs(config.path)

  -- Command to add project name and path
  vim.api.nvim_create_user_command("TukAdd", function(opts)
    if #opts.fargs ~= 2 then
      vim.notify("Usage: TukAdd <name> <path>", vim.log.levels.ERROR)
      return
    end
    add_project(opts.fargs[1], opts.fargs[2])
  end, { nargs = "*" })

  -- Command to remove project by name
  vim.api.nvim_create_user_command("TukRemove", function(opts)
    if #opts.fargs ~= 1 then
      vim.notify("Usage: TukRemove <name>", vim.log.levels.ERROR)
      return
    end
    remove_project(opts.fargs[1])
  end, { nargs = "*" })

  -- Command to open a neovim tab and navigate to project path by name
  vim.api.nvim_create_user_command("TukOpen", function(opts)
    if #opts.fargs ~= 1 then
      vim.notify("Usage: TukOpen <name>", vim.log.levels.ERROR)
      return
    end
    local path = get_project(opts.fargs[1])
    if path then
      vim.cmd("tabnew")
      vim.cmd("tcd " .. path)
      vim.notify("Opened project: " .. opts.fargs[1])
    else
      vim.notify("Project not found: " .. opts.fargs[1], vim.log.levels.ERROR)
    end
  end, { nargs = "*" })

  vim.notify("Tuk plugin loaded")
end

-- Module Setup
M.setup = function(params)
  M.config = vim.tbl_extend("force", {}, M.config, params or {})
  execute(M.config)
end

return M
