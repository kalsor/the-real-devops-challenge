db.createUser(
  {
    user: "mongo-admin",
    pwd: "passw0rd",
    roles: [ { role: "userAdminAnyDatabase", db: "restaurant" } ]
  }
)
