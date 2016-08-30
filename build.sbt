name := "agilesites311"

val core = project in file("core")

val api = project in file("api")

val plg = project in file("plugin")

val starter = project in file("starter")

import S3._

s3Settings

mappings in upload := Seq(
  (file("agilesites.ver"), "releases/11g/agilesites.ver"),
  (file("starter")/"agilesites.zip", "releases/11g/agilesites.zip")
)

host in upload := "agilesites3-repo.s3.amazonaws.com"

credentials += Credentials(Path.userHome/".s3credentials")
