package agilesitesng.preprocess

import agilesites.api.Picker

/**
 * Created by msciab on 29/11/15.
 */

class PickerInjectorImpl(val action: Int, val where: String, val arg: String) extends agilesites.api.PickerInjector {

  def this(action: Int, where: String) {
    this(action, where, null)
  }

  def this(action: Int) {
    this(action, null, null)
  }

  def inject(picker: Picker, what: String) {
    if (action == PickerInjectorImpl.REPLACE) picker.replace(where, what)
    else if (action == PickerInjectorImpl.AFTER) picker.after(where, what)
    else if (action == PickerInjectorImpl.BEFORE) picker.before(where, what)
    else if (action == PickerInjectorImpl.APPEND) picker.append(what)
    else if (action == PickerInjectorImpl.ATTR) picker.attr(where, what, arg)
    else throw new RuntimeException("Initialized with an unknow action " + action)
  }
}
object PickerInjectorImpl {
  val REPLACE: Int = 1
  val AFTER: Int = 2
  val BEFORE: Int = 3
  val ATTR: Int = 4
  val APPEND: Int = 5
}