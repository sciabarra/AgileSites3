name := "agilesites311"

val core = project in file("core")

val api = project in file("api")

val plg = project in file("plugin")

val starter = project in file("starter")

import S3._

s3Settings

mappings in upload := Seq(
  (file("starter")/"agilesites.ver", "agilesites3-repo/releases/11g/agilesites.ver"),
  (file("starter")/"agilesites.zip", "agilesites3-repo/releases/11g/agilesites.zip")
)

host in upload := "s3.amazonaws.com"

credentials += Credentials(Path.userHome/".s3credentials")
