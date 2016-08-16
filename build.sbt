name := "agilesites3"

organization := "com.sciabarra"

version := "3.11-SNAPSHOT"

scalaVersion := "2.10.5"
   
val core = project in file("core")

val api = project in file("api")

val demo = project in file("demo")

val plg = project in file("plugin")
