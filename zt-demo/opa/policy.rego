package httpapi.authz

default allow = false

blacklisted if {
  some i
  input.user == data.blacklist.blocked_users[i]
}

allow if {
  not blacklisted
  input.user == "alice"
  input.role == "admin"
  input.method == "GET"
  input.path == ["data"]
}
