variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "visibility" {
  type    = string
  default = "private"
  validation {
    condition     = contains(["public", "private", "internal"], var.visibility)
    error_message = "Visibility must be one of: public, private, internal."
  }
}

variable "has_issues" {
  type    = bool
  default = true
}

variable "has_discussions" {
  type    = bool
  default = true
}

variable "has_projects" {
  type    = bool
  default = true
}

variable "has_wiki" {
  type    = bool
  default = true
}

variable "allow_merge_commit" {
  type    = bool
  default = true
}

variable "allow_squash_merge" {
  type    = bool
  default = true
}

variable "allow_rebase_merge" {
  type    = bool
  default = true
}

variable "allow_auto_merge" {
  type    = bool
  default = true
}

variable "allow_update_branch" {
  type    = bool
  default = true
}

variable "delete_branch_on_merge" {
  type    = bool
  default = true
}

variable "auto_init" {
  type    = bool
  default = true
}

variable "archive_on_destroy" {
  type    = bool
  default = false
}

variable "is_template" {
  type    = bool
  default = false
}

variable "license_template" {
  type    = string
  default = "AGPL-3.0"
}

variable "template" {
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "team_collaborators" {
  type = object({
    pull     = optional(list(string), [])
    triage   = optional(list(string), [])
    push     = optional(list(string), [])
    maintain = optional(list(string), [])
    admin    = optional(list(string), [])
  })
  default = {}
}