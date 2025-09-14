resource "github_repository" "repository" {
  name                   = var.name
  description            = var.description
  visibility             = var.visibility
  is_template            = var.is_template
  delete_branch_on_merge = var.delete_branch_on_merge

  has_issues      = var.has_issues
  has_discussions = var.has_discussions
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki

  allow_auto_merge    = var.allow_auto_merge
  allow_merge_commit  = var.allow_merge_commit
  allow_rebase_merge  = var.allow_rebase_merge
  allow_squash_merge  = var.allow_squash_merge
  allow_update_branch = var.allow_update_branch

  auto_init          = var.auto_init
  license_template   = var.license_template
  archive_on_destroy = var.archive_on_destroy

  dynamic "template" {
    for_each = var.template == null ? [] : [var.template]
    content {
      owner      = var.template.owner
      repository = var.template.repository
    }
  }

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  vulnerability_alerts = true
}

resource "github_repository_ruleset" "main" {
  name        = "main"
  enforcement = "active"
  target      = "branch"
  repository  = github_repository.repository.name

  conditions {
    ref_name {
      exclude = []
      include = ["refs/heads/main"]
    }
  }

  rules {
    non_fast_forward    = true
    required_signatures = true

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = true
      require_last_push_approval        = true
      required_review_thread_resolution = true
      required_approving_review_count   = 2
    }

    required_code_scanning {
      required_code_scanning_tool {
        alerts_threshold          = "all"
        security_alerts_threshold = "all"
        tool                      = "CodeQL"
      }
    }
  }

  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }
}

resource "github_repository_ruleset" "non_main" {
  name        = "non-main"
  enforcement = "active"
  target      = "branch"
  repository  = github_repository.repository.name

  conditions {
    ref_name {
      exclude = ["refs/heads/main"]
      include = []
    }
  }

  rules {
    non_fast_forward    = true
    required_signatures = true
  }
}

resource "github_repository_collaborators" "this" {
  repository = github_repository.repository.name

  dynamic "team" {
    for_each = merge([
      for permission in keys(var.team_collaborators) :
      { for team in var.team_collaborators[permission] : "${team}-${permission}" => { id : team, permission : permission } }
    ]...)
    content {
      team_id    = team.value.id
      permission = team.value.permission
    }
  }
}

resource "github_repository_dependabot_security_updates" "this" {
  enabled    = true
  repository = github_repository.repository.name
}
