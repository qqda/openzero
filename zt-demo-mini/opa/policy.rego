package httpapi.authz

default allow = false

allow if {
  input.user == "alice"
  input.role == "admin"
  input.method == "GET"
  input.path == ["data"]
}
