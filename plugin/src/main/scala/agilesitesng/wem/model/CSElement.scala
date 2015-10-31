package agilesitesng.wem.model

/**
 * Created by msciab on 16/07/15.
 */

import java.io.File
import java.util.Date

object CSElement {

  import WemModel._

  def blobFromFile(file: File): Blob = {
    val filename = file.getName
    val foldername = if (file.getParentFile != null) file.getParentFile.getName else ""
    Blob(filename, foldername, base64file(file))
  }

  def blobFromFile(filename: String): Blob = blobFromFile(new java.io.File(filename))

  def apply(_id: Long, _name: String, blob: Blob)(implicit _site: String) =
    Asset(id = s"CSElement:${_id}"
      , subtype = ""
      , name = _name
      , publist = List(_site)
      , attribute = List(
        Attribute("rootelement", Data(stringValue = Some(s"${_site}/${_name}")))
        , Attribute("elementname", Data(stringValue = Some(s"${_site}/${_name}")))
        , Attribute("resdetails1", Data(stringValue = Some(s"eid=${_id}")))
        , Attribute("url", Data(blobValue = Some(blob))
        )
      ))

}
