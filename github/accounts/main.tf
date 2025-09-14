resource "github_membership" "members" {
  for_each = var.members
  username = each.key
  role     = each.value.role
}

resource "github_team" "team" {
  for_each    = var.teams
  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

resource "github_team_membership" "this" {
  for_each = merge(
    merge([
      for team in keys(var.teams) :
      { for member in var.teams[team].members : "${team}-${member}-member" => { member : member, team : team, role : "member" } }
    ]...),
    merge([
      for team in keys(var.teams) :
      { for member in var.teams[team].maintainers : "${team}-${member}-maintainer" => { member : member, team : team, role : "maintainer" } }
    ]...)
  )
  team_id  = github_team.team[each.value.team].id
  username = each.value.member
  role     = each.value.role
}