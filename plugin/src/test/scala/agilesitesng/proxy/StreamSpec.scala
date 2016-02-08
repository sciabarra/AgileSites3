package agilesitesng.proxy

import akka.http.scaladsl.Http
import akka.http.scaladsl.model.HttpRequest
import akka.http.scaladsl.unmarshalling.Unmarshal
import akka.stream.ActorMaterializer
import akka.stream.scaladsl.{Sink, Source}
import org.scalatest.concurrent.ScalaFutures
import org.scalatest.{BeforeAndAfterAll, Matchers, FlatSpec}
import akka.http.scaladsl.client.RequestBuilding._

import scala.concurrent.Await
import scala.concurrent.duration._
import scala.util.{Success, Failure}

/**
  * Created by msciab on 05/02/16.
  */
class StreamSpec extends FlatSpec with Matchers
with ScalaFutures
with BeforeAndAfterAll {

  implicit val testSystem =
    akka.actor.ActorSystem("test-system")
  implicit val fm = ActorMaterializer()
  override def afterAll = testSystem.shutdown()
  import testSystem.dispatcher

  def sendRequest(req: HttpRequest) = {
    val flow = Http(testSystem).outgoingConnection(host="www.timeapi.org", port=80)
    Source.single(req).via(flow).runWith(Sink.head)
  }

  "Request" should "complete" in {
    val req = sendRequest(HttpRequest(uri="/utc/now"))
    println("1. "+req)
    val r = Await.result(req, 20.seconds)
    println(r)
    /*
    req.onComplete {
      case Success(s) => println("SUCCESS"+s)
      case Failure(f) => println("FAILURE"+f)
    }
    whenReady(req) { res =>
      println("2. "+res)
      val str = Unmarshal(res.entity).to[String]
      whenReady(str) { s =>
        println(s)
      }
    }*/
  }

}
