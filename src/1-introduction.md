
分散システムは複数のコンピュータが通信ネットワークを介して相互に情報を伝達しあうことで処理を進めるコンピュータシステムである。
昨今のコンピュータの低価格化と通信速度の向上は分散システムの応用範囲を劇的に拡大させた。
実際に分散システムはコンピュータネットワーク上のルーティング制御やWWW(World Wide Web)、航空機制御、コンピュータグラフィクスの分散描画などの様々な分野で活用されている。

このような事情で分散システムとそのシステム上で実行されるアルゴリズム、すなわち分散アルゴリズムは近年非常に活発に研究されている。
ところが分散アルゴリズムの研究には避けられない問題が付随する。
それは分散システムが生来的に持ち合わせている複雑さである。
分散システムを考える際に考慮しなければならない項目は、プロセス(コンピュータ上で実行される逐次プログラムをモデル化したもの)の故障やプロセス数、通信遅延、メッセージ配送のランダム性など多数存在する。
これらのパラメータはアルゴリズムの実行過程を複雑にし、同一のアルゴリズムが様々な実行結果を生じる原因となる。
それらをすべて手作業で検証することは非常に困難である。
そこで考え出されたのが分散アルゴリズムシミュレータという類のソフトウェアである。
分散アルゴリズムシミュレータは分散アルゴリズムを実行するための環境、つまり分散システムをユーザに提供し、アルゴリズムの検証を容易にする。
このソフトウェアにより研究者はアルゴリズムそのものの考案・実装に専念できるようになり、煩わしい分散システムの実装をせずに済むようになった。

既存の分散アルゴリズムシミュレータにはBen-AriのDAJ(Distributed Algorithms in Java)\cite{daj}などがある。
DAJは分散アルゴリズムを記述するためのJavaのクラスライブラリを提供し、そのライブラリを利用したアルゴリズムのシミュレーションと可視化を行う。
また、弘田らは$D^2AS$(Distributed Distributed Algorithms Simulator)という分散アルゴリズムシミュレータを開発した\cite{d2as}。
このシミュレータは大規模な分散システムのシミュレーションを行うためのプログラムで、イーサネットにより結合された複数のコンピュータを実際に使用してシミュレーションを行うことができる。

本研究室では平成18年度からH-DAS(Hamada group - Distributed Algorithms Simulator)という分散アルゴリズムシミュレータの開発が行われてきた。
H-DASは単一のコンピュータ上で動作するGUIプログラムで、仮想的な分散システム上で分散アルゴリズムの動作を視覚的に検証することができる。
本研究ではH-DASの機能追加と不具合修正を行っている。

本論文の構成は次のとおりである。
第2章では分散システムと分散アルゴリズムについて概説する。
第3章では分散アルゴリズムシミュレータの役割を述べ、既存の分散アルゴリズムシミュレータの機能とH-DASの機能についてまとめる。
第4章ではH-DASに行った機能追加と不具合修正を説明する。
第5章ではH-DASの使用方法と既存のアルゴリズムを解説する。
第6章では本研究のまとめとH-DASの今後の発展を述べる。
最後に付録Aでシミュレータとサンプルアルゴリズムからなる付録CDの中身を説明する。
