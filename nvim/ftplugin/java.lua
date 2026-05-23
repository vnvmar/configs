local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
    return
end

local home = vim.env.HOME
local jdtls_install = home .. "/.local/share/nvim/jdtls"

local launcher_glob = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher_glob == "" then
    vim.notify(
        "jdtls not found at " .. jdtls_install ..
        ". Download from https://download.eclipse.org/jdtls/snapshots/?d and extract there.",
        vim.log.levels.WARN
    )
    return
end

local config_dir
if vim.fn.has("mac") == 1 then
    config_dir = jdtls_install .. "/config_mac"
elseif vim.fn.has("unix") == 1 then
    config_dir = jdtls_install .. "/config_linux"
else
    config_dir = jdtls_install .. "/config_win"
end

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = vim.fs.root(0, root_markers) or vim.fn.getcwd()

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_blink, blink = pcall(require, "blink.cmp")
if ok_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
end

local config = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher_glob,
        "-configuration", config_dir,
        "-data", workspace_dir,
    },
    root_dir = root_dir,
    capabilities = capabilities,
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            configuration = {
                updateBuildConfiguration = "interactive",
            },
        },
    },
    init_options = {
        bundles = {},
    },
}

jdtls.start_or_attach(config)
