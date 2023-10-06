config {
  format = "compact"
  module = false
  force  = false
}

# Enable all rules, always. The bundled plugin uses only recommended.
plugin "terraform" {
  enabled = true
  preset  = "all"
}

# Enforces module version pinning.
rule "terraform_module_pinned_source" {
  enabled = true
  style   = "semver"
}

# Enforces naming conventions.
rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}
