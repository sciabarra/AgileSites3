package agilesitesng.deploy.model

import agilesitesng.deploy.model.SpoonModel.DeployObjects

/**
 * A spooler class to collect object and serialize them in priority order
 *
 * @param map
 */
case class Spooler(val map: Map[String, Map[String,SpoonModel]] = Map.empty) {

  def push(i: Int, key:String, obj: SpoonModel) = {
    val pri = i.toString
    val ls = if (map.contains(pri)) map(pri) + (key -> obj) else Map(key -> obj)
    new Spooler(map + (pri -> ls))
  }

  def pop(): (SpoonModel, Spooler) = {
    val top = map.keys.map(_.toInt).max.toString
    val ls = map(top)

    val nmap = if (ls.size == 1)
      map - top
    else
      map + (top -> ls.tail)

    ls.head._2 -> new Spooler(nmap)
  }

  def get(i:Int, key:String) = {
    val pri = i.toString
    val mp =  if (map.contains(pri)) map(pri) else Map.empty[String, SpoonModel]
    mp.get(key)
  }

  def size = map.size

  override def toString = map.toString
}

object Spooler {

  var spool = new Spooler

  def insert(pri: Int, key:String, obj: SpoonModel) {
    val prev = spool.get(pri, key)
    prev match {
      case x:Some[SpoonModel] =>
        if (x.get != obj) {
           throw new Exception(s"object \n $obj \n already defined with different values: \n ${x.get}")
        }
      case None =>
        val t = spool.push(pri, key, obj)
        spool = t
    }
  }

  def extract(): Option[SpoonModel] = {
    if (spool.size == 0)
      None
    else {
      val (h, q) = spool.pop
      spool = q
      Some(h)
    }
  }

  import net.liftweb.json.Serialization.{read, write}
  import net.liftweb.json._

  implicit val formats = Serialization.formats(ShortTypeHints(SpoonModel.classTypes))

  def save = {
    var res = List.empty[SpoonModel]
    var o = extract()
    while (o.isDefined) {
      res = o.get :: res
      o = extract()

    }
    val out = DeployObjects(res.reverse)
    //println(out)
    write(out)
  }

  def load(ser: String): DeployObjects = read[DeployObjects](ser)
}
