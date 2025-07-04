package httpapi.authz

default allow = false

allow {
  input.user == "alice"
  input.role == "admin"
  input.method == "GET"
  input.path == ["data"]
}
