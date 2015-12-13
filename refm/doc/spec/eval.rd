= Ruby プログラムの実行

=== Ruby プログラム

Ruby プログラムの実行は文の連なりの評価です。なんらかの形であたえられたプログラムテキストをコンパイルし、BEGIN 文があればそれを評価し、トップレベルの式の連なりを評価し、END ブロックがあれば最後にそれを評価して終了します (終了処理の詳細については [[d:spec/terminate]] を参照のこと)。

=== 文

==== if

if 文は、まず条件式を評価し、その値が真ならば対応する本体を評価します。
偽ならば elsif 節の条件式を順番に評価し、その値が始めて真になった節の
本体を評価します。それらがすべて偽なら else 節の本体を評価します。

文全体の値は最後に実行した((*本体*))の値です。ただし評価された本体に
式がなかった場合、あるいはすべての条件式が偽でかつ else 節もなかった
場合は nil です。

==== until
==== if 修飾子
==== unless 修飾子
==== while
==== until
==== while 修飾子
==== until 修飾子
==== for
==== begin 〜 end

==== クラス定義文

クラスを定義します。
評価は(コンパイル時ではなく)実行時に行われます。

書式

  class ClassName [< スーパークラス式]
    式
  end

クラス定義文は評価されるとまずクラスを生成しようとします。スーパークラ
ス式が指定されていたらそれを評価し、その値を上位クラスとする Class
クラスのインスタンスを生成します。式が省略されていたら [[c:Object]] を
上位クラスとします。

一方、もし同名のクラスがすでにある場合はそれを使います。そのときスーパー
クラス式が指定されており、その結果と得たクラスのスーパークラスが
(equal? において) 違う場合は例外 TypeError が発生します。

クラスを得たら次にそれを定数「ClassName」に代入します。これによってク
ラス名が決定されます。このとき同名の定数に Class のインスタンスでない
ものが代入されている場合は例外 TypeError を発生します。

最後に新しいフレームを生成し、トップレベルブロックの self および class
に定義を行おうとするクラスを設定して、そのフレーム上で定義文中の式を評
価します。クラス定義文の評価値を得ることはできません。

つまり Ruby では何度も「クラス定義の追加」をすることが可能です。

==== モジュール定義文

モジュールを定義します。
評価は(コンパイル時ではなく)実行時に行われます。

書式

  module ModuleName
    本体
  end

モジュール定義文は評価されるとまず新しい無名のモジュールを生成します。
ただしすでに ModuleName と名付けられたモジュールがある場合はそれを
かわりに使います。このような場合は「モジュール定義の追加」をすること
になります。

モジュールを得たら次にそれを定数 ModuleName に代入します。この定数が
モジュールの名前になります。このとき同名の定数にモジュール以外が代入
されていた場合は例外 TypeError が発生します。

最後に、新しいフレームを生成し、そのトップレベルブロックの self および
class にモジュール ModuleName を設定し、そのフレーム上で定義文中の式を
評価します。モジュール定義文の評価値は最後に評価した本体の式の値です。
本体に評価する式がない場合は nil になります。

==== 特異クラス定義文

オブジェクトの特異クラスを定義します。
評価は(コンパイル時ではなく)実行時に行われます。

書式

  class << EXPR
    本体
  end

まず特異クラスを定義しようとするオブジェクトの式 EXPR を評価しま
す。続いてそのオブジェクトの特異クラスを(まだ生成されていなければ)生成しま
す。最後に、新しいフレームを生成し、トップレベルブロックの self および
class に生成した特異クラスを設定し、そのフレーム上で定義文中の式を評価
します。

特異クラス定義文の評価値は、本体で最後に評価した式の値です。
評価する式がひとつもなければ nil になります。

ただし Fixnum Symbol のインスタンスおよび true false nil には特異クラスは
定義できません。

==== メソッド定義式

メソッドを定義します。
評価は(コンパイル時ではなく)実行時に行われます。

書式

  def method_name(arg, argwithdefault=expr, *restarg, &block)
    本体
  end

評価すると、実行中のブロックの class にメソッド本体を当該の名前で定義
します。もしすでにその class 自体に同名のメソッドが定義されている場合
は、古いメソッドを捨てて新しいメソッドの内容によって定義しなおします。

#@since 2.1.0
メソッド定義式は、メソッド名を [[c:Symbol]] にしたオブジェクトを返します。
#@else
メソッド定義式は、nil を返します。
#@end

==== 特異メソッド定義式

オブジェクトの特異クラスにメソッドを定義します。
評価は(コンパイル時ではなく)実行時に行われます。

書式

  def expr.method_name(arg, argwithdefault=expr, *restarg, &block)
    本体
  end

まず最初に式 expr を評価します。続いてその値のオブジェクトの
特異クラスを (まだ作成されていなければ) 作成します。最後に、その特異
クラスにメソッド method_name を定義します。

#@since 2.1.0
特異メソッド定義式は、メソッド名を [[c:Symbol]] にしたオブジェクトを返します。
#@else
特異メソッド定義式は、nil を返します。
#@end

ただし Fixnum Symbol のインスタンスおよび true false nil には特異メソッド
は定義できません。

==== BEGIN

コンパイル時に登録される (評価は実行の最初)

==== END

コンパイル時に登録される (評価は実行の最後)

=== メソッド

==== メソッドの呼び出し

まずレシーバ式を評価してレシーバとなるオブジェクトを得ます。レシーバ式
が省略された場合は呼び出しを行っているブロックのself がレシーバです。

続いて引数式を左から右の順番で評価し、レシーバに対してメソッドの検索を
行います。検索が失敗したら例外 [[c:NameError]] を発生、成功したらメソッ
ドを実行します。

またメソッドを実行する際にはブロックを与えることが可能です。メソッドに
対してブロックを与えると、そのメソッドの実行中にyield が実行され
たときにはじめてブロックが評価されます。yield されなかったときは
ブロックは単に無視され、実行されません。

メソッドにブロックを与える場合、そのブロックはメソッドを呼び出す側のブ
ロックの self と class を継承します。Module#module_eval/class_eval、
#@since 1.9.1
BasicObject#instance_eval
#@else
Object#instance_eval
#@end
の三つだけが例外で、以下のように変更されます。

: [[m:Module#module_eval]], [[m:Module#class_eval]]
    self、class ともそのレシーバ
#@since 1.9.1
: [[m:BasicObject#instance_eval]]
#@else
: [[m:Object#instance_eval]]
#@end
    self がそのレシーバ、class がそのレシーバの特異クラス

==== eval

eval の第二引数に [[c:Proc]] オブジェクトまたは [[c:Binding]] オブ
ジェクトを与えたときは、その生成時のブロックのうえで文字列を評価します。

==== メソッドの実行

メソッドの実行はフレームのうえにひとつだけブロックがある状態で開始しま
す。このブロックを以下、仮にトップレベルブロックと呼んでおきます。トッ
プレベルブロックの self はレシーバで、class は定義されていません。

まず、省略不可能な引数が存在するなら、与えられた値をトップレベルブロッ
クのローカル変数に代入します。

省略可能な引数が存在し、実際に省略されていたら、トップレベルブロック上
でデフォルト式を評価し、その値をトップレベルブロックのローカル変数に代
入します。実際には省略されなかったら、与えられた値を同じくローカル変数
に代入します。

*args の形のパラメータ指定があるなら、残りの引数すべてを配列とし
てローカル変数に代入します。

さらに、ブロック引数 blockvar が存在するならば、メソッドに与えら
れたブロックを [[c:Proc]] オブジェクト化してトップレベルブロック上のロー
カル変数 blockvar に代入します。ブロックが与えられていないなら
nil を代入します。

続いて本体が評価され、メソッドレベルの rescue 節または else
節が評価され、最後に ensure 節が評価されます。

メソッド全体の値は return に渡した値です。
return が呼び出されなかった場合は、本体/rescue/else
の中で最後に評価した式の値です。その三つともすべてがカラだった場合は
nil になります。

==== ブロック付きメソッド呼び出し

メソッドに対してブロックが与えられていたらそのメソッドをブロック付きメソッド
と呼びます。ブロック付きメソッドからは yield によって与えられたブロックに実行
を移すことができます。

ブロック引数をとることができます。

break … ブロックがスタックフレーム上にあるなら、そのフレームのブロッ
クの直後にジャンプします。ブロック付きメソッドを break して終了したらその値は
nil です。スタックフレーム上にないなら例外 [[c:LocalJumpError]]
を発生します。

next ブロックの終わりまでジャンプ

retry 複雑だ…

==== eval, instance_eval, module_eval

これなんだっけ

=== 代入

代入とは、変数・定数のいずれかにオブジェクトを記憶させることを言います。
[]= や属性代入のメソッド呼び出しも文法上は代入のように見えますが、
それはここで定義する代入ではありません。

変数には、何回でも、どんなオブジェクトでも代入することができます。定数
にも同様にあらゆるオブジェクトを代入することができますが、ただ一回しか
代入できません。つまりいったんオブジェクトを代入したらあとから記憶する
オブジェクトを変更することはできません。これは記憶したオブジェクトそれ
自身が変化することを禁止するのではないことに注意してください。

==== 多重代入

まだ

=== 変数と定数

変数および定数はオブジェクトをひとつだけ記憶しておくことができます。
この、オブジェクトを記憶させる操作を「変数(定数)への代入」と言います。

変数および定数を評価すると、それが記憶しているオブジェクトを返します。
この操作を「変数(定数)の参照」と言います。

以下、種類別に変数／定数の代入と参照の挙動を述べます。

==== ローカル変数

ローカル変数はただひとつのブロックに所属します。ブロックとはコードのあ
る範囲に対応する実行時の構造で、ネストが可能です。具体的にはブロック付き
メソッド呼び出しや eval 系メソッドの実行にともなって生成されます。
ローカル変数は、所属するブロックおよびそのブロックの上にネストされた
ブロックの中からのみ代入・参照できます。

またさらにブロックは特定の「フレーム」のうえに積まれ、そこに所属します。
別フレームのうえにあるローカル変数を参照することはできません。フレーム
とは以下の文の実行開始時に生成される実行時の構造です。

  * プログラムテキストのトップレベル(ruby に渡したファイル名、-e、ロード)
  * メソッド実行
  * クラス／モジュール定義文
  * BEGIN および END 文

フレームが生成されると自動的にブロックもひとつ積まれますので、これらの
文の本体でもすぐにローカル変数を使うことができます。

ローカル変数の定義は、コンパイル時にそのフレーム中で定義されていない
ローカル変数への代入をプログラムテキスト中に((*書くこと*))によって行
います。所属するブロックは代入が書かれている一番外側のブロックです。
このことからもわかるように、ローカル変数の定義はコンパイル時にすべて
完了します (eval 系メソッドは実行中にコンパイルをしていることに注意
してください)。定義された変数の初期値は nil です。

ローカル変数の定義および参照にあたっては、外側のブロックから順番に変数
を探します。この結果としてローカル変数のネスト (shadowing) はできません。
ただし上下関係にない複数のブロックに別々のローカル変数が存在することは
ありえます。

また未定義の(つまりコード中に書かれていない)ローカル変数を参照すると、
Ruby は次にそれを self への(引数のない)メソッド呼び出しに解釈しようと
します。メソッドの探索にも失敗したら例外 NameError を発生します。

呼び出しブロックの実行にあたっては、ブロックが引数をとることができま
すが、これは実行しようとするブロック上での多重代入とみなされます。たと
えば以下のコードのブロック実行開始時には、

    some_iterator do |a,b|
      ....
    end

次のような操作がまず実行されます。

    a, b = <some_iterator から yield された値>

==== インスタンス変数

インスタンス変数はひとつのオブジェクトに所属し、そのオブジェクトを
self とするブロックだけから代入、参照できます。定義は代入によっ
て兼ね、未定義のインスタンス変数を参照すると nil を返します。

remove_instance_variable

==== クラス変数

クラス変数はひとつのクラスとそのサブクラス、およびそのインスタンスに所
属し、それらオブジェクトを self とするブロックだけから代入、参照できま
す。定義は最初の代入によって行います。未定義のクラス変数を参照すると例
外 NameError が発生します。

クラス変数の継承と「継承止め」

==== グローバル変数

グローバル変数は全ての場所から代入、参照できます。
定義は最初の代入によって行い、未定義のグローバル変数を参照
すると nil を返します。

トレースできること(？)

==== 定数

定数はクラス／モジュールに所属します。代入はメソッド以外のすべてで可能
で、最初の代入が定義を兼ねます。定数が所属するクラスは代入が行われたブ
ロックの class です。また非常に特殊な例外としてメソッド
Module#const_set によっても定義が可能です。さらに
Module#remove_const を使うことで定義の取り消しが可能です。

すでに定義されている定数の再定義および代入はできません。実際には警告の
みで代入が可能ですが、これは一時的な避難措置であり本来の仕様ではありま
せん。従ってこれに依存したコードはできるだけ書かないようにすべきです。

参照可能な範囲は記法によって分かれます。

: 定数名のみの場合 (例： Const)
    定数が所属するクラス、そのサブクラス、ネストしたクラスの
    フレームに書かれたコードから参照可能

: フルパス指定の場合 (例： Mod::Cls::Const)
    あらゆる場所から参照可能

また ::Const のように :: を前置した記法では
Object::Const のみが参照可能です。

=== 擬似変数

以下は、ローカル変数のように見えますが実際には予約語として処理され、
決まった値を返します。代入はできません。

==== self
記述されたブロックの self を返します。

==== nil
[[c:NilClass]] の唯一のインスタンス nil を返します。

==== true
[[c:TrueClass]] の唯一のインスタンス true を返します。

==== false
[[c:FalseClass]] の唯一のインスタンス false を返します。
