package agilesitesng.wem.actor

import agilesitesng.wem.actor.Protocol.Message
import akka.actor.{ActorLogging, Actor}

import scala.collection.mutable

/**
 * Created by msciab on 25/07/15.
 */
trait Queuer {
  this: Actor with ActorLogging =>

  override def preRestart(reason:Throwable, message:Option[Any]){
    //super.preRestart(reason) ??? why
    log.error(reason, "Unhandled exception for message: {}", message)
  }

  var queue = mutable.Queue.empty[Object]

  def flushQueue {
    while (queue.nonEmpty)
      self ! queue.dequeue
  }

  def enqueue(msg: Object) { queue.enqueue(msg)}
}
