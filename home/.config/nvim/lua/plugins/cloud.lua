return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      local terraform_severity_to_diagnostic_severity = {
        warning = vim.diagnostic.severity.WARN,
        error = vim.diagnostic.severity.ERROR,
        notice = vim.diagnostic.severity.INFO,
      }

      require("lint").linters.terraform_validate = function()
        return {
          cmd = "terraform",
          args = { "validate", "-json", vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.:h") },
          append_fname = false,
          stdin = false,
          stream = "both",
          ignore_exitcode = true,
          parser = function(output, bufnr)
            local decoded = vim.json.decode(output) or {}
            local diagnostics = decoded["diagnostics"] or {}
            local diagnostics_to_show = {}
            local buf_path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
            for _, new_diagnostic in ipairs(diagnostics) do
              local message = new_diagnostic.summary
              if new_diagnostic.detail then
                message = string.format("%s - %s", message, new_diagnostic.detail)
              end
              local rewritten_diagnostic = {
                message = message,
                lnum = 0,
                col = 0,
                source = "terraform validate",
                severity = terraform_severity_to_diagnostic_severity[new_diagnostic.severity],
                filename = buf_path,
              }
              if new_diagnostic.range ~= nil and new_diagnostic.range.filename == buf_path then
                rewritten_diagnostic.col = tonumber(new_diagnostic.range.start.column) - 1
                rewritten_diagnostic.end_col = tonumber(new_diagnostic.range["end"].column) - 1
                rewritten_diagnostic.lnum = tonumber(new_diagnostic.range.start.line) - 1
                rewritten_diagnostic.end_lnum = tonumber(new_diagnostic.range["end"].line) - 1
                rewritten_diagnostic.filename = tonumber(new_diagnostic.range.filename)
              end
              table.insert(diagnostics_to_show, rewritten_diagnostic)
            end
            return diagnostics_to_show
          end,
        }
      end

      -- Set up the filetypes
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.terraform = { "terraform_validate" }
      opts.linters_by_ft.tf = { "terraform_validate" }

      return opts
    end,
  },
  -- Add in lua/plugins/custom.lua
  {
    "robbles/logstash.vim",
    ft = "logstash",
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      -- Ensure servers table exists
      opts.servers = opts.servers or {}

      -- Function to read VSCode YAML configuration from .vscode/settings.json
      local function read_vscode_yaml_config()
        local cwd = vim.fn.getcwd()
        local vscode_settings_path = cwd .. "/.vscode/settings.json"

        -- Check if .vscode/settings.json exists
        if vim.fn.filereadable(vscode_settings_path) == 1 then
          local ok, settings_content = pcall(function()
            local lines = vim.fn.readfile(vscode_settings_path)
            local content = table.concat(lines, "\n")
            return vim.json.decode(content)
          end)

          if ok and settings_content then
            local yaml_config = {
              schemas = {},
              completion = settings_content["yaml.completion"] ~= false,
              hover = settings_content["yaml.hover"] ~= false,
              validate = settings_content["yaml.validate"] ~= false,
            }

            -- Process yaml.schemas from VSCode settings
            if settings_content["yaml.schemas"] then
              for schema_path, patterns in pairs(settings_content["yaml.schemas"]) do
                -- Convert relative schema path to absolute file URI
                local absolute_schema_path = schema_path
                if not schema_path:match("^https?://") and not schema_path:match("^file://") then
                  absolute_schema_path = "file://" .. cwd .. "/" .. schema_path
                end

                -- Handle both single pattern strings and arrays of patterns
                if type(patterns) == "string" then
                  yaml_config.schemas[absolute_schema_path] = patterns
                elseif type(patterns) == "table" then
                  -- For arrays, use the first pattern (YAML LS typically expects single pattern per schema)
                  -- Alternative: could combine patterns with | separator if needed
                  if #patterns > 0 then
                    yaml_config.schemas[absolute_schema_path] = patterns[1]
                  end
                end
              end
            end

            return yaml_config
          end
        end

        -- Fallback config if no VSCode settings found or parsing failed
        return {
          schemas = {},
          completion = true,
          hover = true,
          validate = true,
        }
      end

      -- Add helm_ls configuration
      opts.servers.helm_ls = {
        settings = {
          ["helm-ls"] = {
            logLevel = "info",
            valuesFiles = {
              mainValuesFile = "values.yaml",
              lintOverlayValuesFile = "values.lint.yaml",
              additionalValuesFilesGlobPattern = "values*.yaml",
            },
            helmLint = {
              enabled = true,
              ignoredMessages = {},
            },
            yamlls = {
              enabled = true,
              enabledForFilesGlob = "*.{yaml,yml}",
              diagnosticsLimit = 50,
              showDiagnosticsDirectly = false,
              path = "yaml-language-server",
              initTimeoutSeconds = 3,
              config = read_vscode_yaml_config(),
            },
          },
        },
      }

      return opts
    end,
  },
}
