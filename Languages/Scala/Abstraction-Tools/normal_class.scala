class A(a: Integer, var b: String)

class B(val imut: Integer, var mut: Double):
  // def changeImut(new_val: Integer) = imut = new_val
  def changeMut(new_val: Double) = mut = new_val

class C(val a: Integer, val b: Integer):
  println("constructor begin")
  val c = a + b
  println(s"property c is $c")

  def printCCC = println(s"ccc: $c $c $c")
  printCCC
  println("constructor end")

class D(var haha: Integer):
  private var _hehe = "wqe"
  private var hihi = "qwe"

  def this(haha: Integer, hehe: String) = {
      this(haha)
      _hehe = hehe
  }

object A:
  private val oa = 1
  def printOA = println(oa)

class E:
  var e1: Int = -1
  var e2: String = ""

object E:
  def apply(e1: Int): E = {
    var inst = new E
    inst.e1 = e1
    inst
  }

trait F(f1: String):
  def F1(): String
  def F2() = println("default implementation")

  def not_only_method: Double
  def but_some_property: Int
  def support_params: Int = f1.length

class FF(a: Double, b: Int) extends F("skyleaworlder"):
  var not_only_method = a
  var but_some_property = b
  override def F1(): String = {
    print(s"FF: $not_only_method, $but_some_property: ")
    F2()
    "wqeeqwe"
  }

enum H:
  case H1, H2, H3

enum I(val i: Double):
  case I1 extends I(1.2)
  case I2 extends I(1.2)
  case I3 extends I(3.6)

@main def main = {
  var obj_a = A(123, "qweqwe")

  var obj_b = B(123, 123.8)
  // obj_b.changeImut(23)
  obj_b.changeMut(13.534)

  var obj_c = C(23, 12)
  obj_c.printCCC

  var obj_d1 = D(1)
  var obj_d2 = D(1, "12")

  A.printOA

  var obj_e1 = E(1)
  var obj_e2 = new E

  var obj_f1 = new FF(123.21, 12)
  obj_f1.F1()

  var h = H.H1
  h match
    case H.H1 => println("h1")
    case H.H2 => println("h2")
    case _ => {}

  var i1 = I.I2
  println(i1.i)
}
