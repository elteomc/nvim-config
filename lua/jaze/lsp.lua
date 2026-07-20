local M = {}

local function map(bufnr, modes, lhs, rhs, desc)
  vim.keymap.set(modes, lhs, rhs, {
    buffer = bufnr,
    silent = true,
    desc = desc,
  })
end

local function get_capabilities()
  local capabilities =
    vim.lsp.protocol.make_client_capabilities()

  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")

  if ok then
    capabilities =
      cmp_lsp.default_capabilities(capabilities)
  end

  return capabilities
end

local function switch_source_header(bufnr)
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    name = "clangd",
  })

  local client = clients[1]

  if not client then
    vim.notify(
      "clangd is not attached to this buffer",
      vim.log.levels.WARN
    )
    return
  end

  client:request(
    "textDocument/switchSourceHeader",
    {
      uri = vim.uri_from_bufnr(bufnr),
    },
    function(err, result)
      if err then
        vim.notify(
          "clangd source/header switch failed: "
            .. (err.message or tostring(err)),
          vim.log.levels.ERROR
        )
        return
      end

      if not result or result == "" then
        vim.notify(
          "No corresponding source/header file found",
          vim.log.levels.INFO
        )
        return
      end

      vim.schedule(function()
        vim.cmd.edit(vim.uri_to_fname(result))
      end)
    end,
    bufnr
  )
end

local function setup_lsp_keymaps()
  local group = vim.api.nvim_create_augroup(
    "JazeLspAttach",
    { clear = true }
  )

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
      local bufnr = event.buf
      local client =
        vim.lsp.get_client_by_id(event.data.client_id)

      map(
        bufnr,
        "n",
        "gd",
        vim.lsp.buf.definition,
        "Go to definition"
      )

      map(
        bufnr,
        "n",
        "gy",
        vim.lsp.buf.type_definition,
        "Go to type definition"
      )

      map(
        bufnr,
        "n",
        "gi",
        vim.lsp.buf.implementation,
        "Go to implementation"
      )

      map(
        bufnr,
        "n",
        "gr",
        vim.lsp.buf.references,
        "List references"
      )

      map(
        bufnr,
        "n",
        "K",
        vim.lsp.buf.hover,
        "Show hover documentation"
      )

      map(
        bufnr,
        "n",
        "<leader>rn",
        vim.lsp.buf.rename,
        "Rename symbol"
      )

      map(
        bufnr,
        { "n", "v" },
        "<leader>ac",
        vim.lsp.buf.code_action,
        "LSP code action"
      )

      if client and client.name == "clangd" then
        map(
          bufnr,
          "n",
          "<leader>sh",
          function()
            switch_source_header(bufnr)
          end,
          "Switch source/header"
        )
      end
    end,
  })
end

local function setup_diagnostic_keymaps()
  vim.keymap.set("n", "[g", function()
    vim.diagnostic.jump({
      count = -1,
      float = true,
    })
  end, {
    desc = "Previous diagnostic",
  })

  vim.keymap.set("n", "]g", function()
    vim.diagnostic.jump({
      count = 1,
      float = true,
    })
  end, {
    desc = "Next diagnostic",
  })
end

local function configure_servers()
  local capabilities = get_capabilities()

  vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      ".luarc.json",
      ".git",
    },
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        workspace = {
          library =
            vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        diagnostics = {
          globals = { "vim" },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  vim.lsp.config("julials", {
    cmd = {
      "julia",
      "--startup-file=no",
      "--history-file=no",
      "-e",
      "using LanguageServer; runserver()",
    },
    filetypes = { "julia" },
    root_markers = {
      "Project.toml",
      ".git",
    },
    single_file_support = true,
    capabilities = capabilities,
  })

  vim.lsp.config("texlab", {
    cmd = { "texlab" },
    filetypes = {
      "tex",
      "plaintex",
      "bib",
    },
    root_markers = {
      ".git",
      ".latexmkrc",
      "main.tex",
    },
    capabilities = capabilities,
  })

  vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = {
      "c",
      "cpp",
      "objc",
      "objcpp",
    },
    root_markers = {
      "compile_commands.json",
      "compile_flags.txt",
      ".git",
    },
    capabilities = capabilities,
  })

  vim.lsp.config("marksman", {
    filetypes = {
      "markdown",
      "mdx",
      "quarto",
    },
    capabilities = capabilities,
  })

  vim.lsp.enable({
    "lua_ls",
    "texlab",
    "clangd",
    "julials",
    "marksman",
  })
end

function M.setup()
  setup_lsp_keymaps()
  setup_diagnostic_keymaps()
  configure_servers()
end

return M
