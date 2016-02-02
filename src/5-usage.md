# 動作環境

H-DASはJavaの実行環境JRE(Java Runtime Environment)\cite{jre}で動作するプログラムである。
また、ユーザが記述したアルゴリズムをコンパイルするためにはJDK(Java Development Kit)8\cite{jdk}が必要となる。
JREもJDKもOracle社のWebサイトからダウンロードすることができる。

# インストール

H-DASのインストールは、付録のCDよりH-DASを適当なディレクトリにコピーすれば完了する。

# アンイストール

H-DASのアンインストールは、H-DASのディレクトリを削除すれば完了する。

# シミュレータの起動

H-DASは、アルゴリズムを記述するためのデスクリプタとシミュレーションを行うためのシミュレータからなる。
共に共通の画面から起動でき、起動画面を呼び出すにはH-DASディレクトリ内のbinディレクトリからコマンドラインに`java startup.Controller`と入力する。
すると図\ref{fig:startup}の起動画面が呼び出される。

![H-DASの起動画面](./src/fig/startup.eps){width=0.5\linewidth}

シミュレータを起動する場合には[Simulator]を、デスクリプタを起動する際には[Descriptor]をクリックすればよいが、その前にConfigure Pathsで設定をする必要がある。
図\ref{fig:configure-paths}はパスの設定画面である。
ここで、tools.jar及びシミュレーションを行うdasファイルのあるディレクトリの指定をしなければならない。
なおtools.jarはデスクリプタで、dasファイルのあるディレクトリはシミュレータでしか使わないので、どちらか片方しか使用しない場合は使わない方の設定はしなくても問題ない。

![Configure Paths](./src/fig/configure-paths.eps){width=0.8\linewidth}

# 分散アルゴリズムの記述

## モデル情報の入力

分散アルゴリズムの記述に使用するデスクリプタの初期画面を図\ref{fig:descriptor-startup}に示す。

![デスクリプタの初期画面](./src/fig/descriptor-startup.eps){width=0.8\linewidth}

メニューから[File]→[New]を選択し、出現するダイアログでシステムディレクトリを指定する。
次に出現するダイアログでは作成するアルゴリズムのシステム名を入力する。
そうすると、図\ref{fig:descriptor-inuse}のような画面になる。
ここで、画面左のツリーからノードを選択すると、画面右にモデル情報タブが表示されるので、画面下部の[Add]、[Modify]、[Delete]ボタンからモデル情報を編集する。

![デスクリプタの使用画面](./src/fig/descriptor-inuse.eps){width=0.8\linewidth}

モデルはアルゴリズムごとにVariableモデル、Stateモデル、Eventモデル、Parameterモデル、及びMessageモデルがある。
Eventモデルの入力時に受信イベントで受信するメッセージの種別は、Messageモデルとして入力したものから選択することになる。

デフォルトのパラメータとして、Variableモデルには`Health`、Stateモデルには`tranquil`、`critical`、`failed`、
Parameterモデルには`processID`、`numberOfProcess`、`FailureProbability`、`coterie`がある。
特に、Stateモデルの`failed`とParameterモデルのすべてパラメータはシステムに必須であるため変更・削除してはならない。

Parameterモデルのパラメータの変数の型として選択できるのはラッパークラスのInteger型とDouble型のみであるので注意が必要である。
また、Messageモデルのパラメータにはint型やdouble型などの基本データ型が使用できる。

モデル情報の入力が完了したら、メニューから[Function]→[Output a skeleton code]を選択し、つづいて出現するダイアログでスケルトンコードを生成したいアルゴリズムを選択する。
これによりシステムディレクトリ及び、その内部にスケルトンコードが生成される。
ユーザはプロセス処理の記述に移行する前に、入力したモデル情報に誤りがないかを確認するため、図\ref{fig:build-button}のビルドボタンをクリックしビルドを実行することが推奨される。

![ビルドボタン](./src/fig/build-button.eps){width=0.1\linewidth}

## プロセス処理の記述

プロセス処理の記述は、スケルトンコードの作成によってシステムディレクトリ内に生成されたxxxProcess.java(xxxはアルゴリズム名)ファイルの内容を編集することによって行う。
記述する内容は、デスクリプタで入力したイベントごとにその動作と、イベントの前提条件が整っているかどうかを表すpreconditionメソッド、
受信イベントにおける対応メッセージが受信バッファに存在するか否かという条件である。

また、デッドロックを自動的に検出できるようにするには、各メッセージが送信されるときに返信を要求するかどうかを明確にする必要がある。
メッセージが返信を要求するならば、スケルトンコードのxxxMessage.java(xxxはメッセージ名)の内容のうち、

```
public class xxxMessage extends Message implements Serializable
```

という行を

```
public class xxxMessage extends WantResponse implements Serializable
```

と書き換えなければならない。
返信を要求しないメッセージについてはそのままでよい。

ユーザがプロセス処理を記述するにあたって使用することのできるメソッドのうち主要なものを表\ref{tbl:usable-method}に示す。

\begin{table}[htbp]
	\centering
	\caption{ユーザが使用可能な主なメソッド \label{tbl:usable-method}}
  \begin{tabular}{|l|l|p{6cm}|} \hline
		メソッド名 & 所有クラス & 処理内容 \\ \hline
		getProcessID() & MutualExclusionAlgorithm & プロセス番号の取得 \\ \hline
		getNumberOfProcess() & MutualExclusionAlgorithm & プロセスの総数の取得 \\ \hline
		sendEvent() & DirectDependencyClock & ベクトル時計の自身の時刻成分を1増分 \\ \hline
		dispatchMessage() & MessagePost & 第1引数で指定したプロセス番号に、第2引数で指定したメッセージを送信 \\ \hline
		dispathToOthers() & MutualExclusionAlgorithm & メソッドを呼び出したプロセス以外の全プロセスに、dispathMessageを呼び出して第2引数で指定したメッセージを送信 \\ \hline
		getXXX() & メッセージモデルのクラス & メッセージモデルの保持変数を取得 \\ \hline
		receiveEvent() & DirectDependencyClock & 受信したメッセージについて、ベクトル時計の送信者の時刻成分と自身の時刻成分を比較して更新 \\ \hline
		getAlgorithmName() & MutualExclusionAlgorithm & プロセスのアルゴリズム名を取得 \\ \hline	
  \end{tabular}
\end{table}

## ビルド

プロセス処理の記述が完了したら、デスクリプタの[Build]ボタンによりビルドを実行する。
一度ビルドしたアルゴリズムについても編集の都度ビルドボタンをクリックすることでアルゴリズムを更新できる。
ビルドをするとダイアログが出現し、プロセス処理の記述に含まれるエラーやシステムファイルのバージョンエラーが表示される。
エラーが生じた場合、システムは直前のビルド成功後の状態から更新されない。
ビルド成功時のダイアログを図\ref{fig:build-completed}に示す。

![ビルド成功時の様子](./src/fig/build-completed.eps){width=0.6\linewidth}

# シミュレーション

## シミュレーションの開始

シミュレーションの開始は以下の手順で行う。

1. 図\ref{fig:new-button}の[New]ボタンをクリックする。または、メニューから[Simulation]→[Start]→[New simulation]を選択する。
2. 図\ref{fig:select-das-dialog}のダイアログで、シミュレーションを行いたいアルゴリズムのdasファイルを選択する。
3. 図\ref{fig:parameter-dialog}のダイアログで、プロセス数を設定する。
4. つづいて同じダイアログで、プロセスの故障率を設定する。入力したpの1/1000がプロセスの故障率として設定される。各プロセスが持つ変数healthがプロセスの故障率を下回ったとき、プロセスは故障状態になる。
5. 更に同じダイアログで通信遅延の上限を設定する。
6. 次にコータリーを使用するか否かと、使用するコータリーの選択を行う。
7. 次に通信路のFIFO性の選択を行う。
8. 図\ref{fig:use-same-configuration-dialog}のダイアログでプロセスのパラメータを設定する。[Use the same configuration as that of the previous one]を選択すると、設定したパラメータ以外にベクトル時計も直前のプロセスと同じ初期値で生成される。[Use similar configuration for other processes]にチェックを入れた場合は、入力されたパラメータはすべてのプロセスに反映され、ベクトル時計はプロセス毎に正しく生成される。

以上の手順を完了すると、シミュレーションを開始できる状態となる。
その状態の画面を図\ref{fig:simulator-in-simulation}に示す。

![新規シミュレーションボタン](./src/fig/new-button.eps){width=0.1\linewidth}

![dasファイル選択ダイアログ](./src/fig/select-das-dialog.eps){width=0.6\linewidth}

![パラメータ入力ダイアログ](./src/fig/parameter-dialog.eps){width=0.8\linewidth}

![プロセスのパラメータ設定ダイアログ](./src/fig/use-same-configuration-dialog.eps){width=0.6\linewidth}

![シミュレーション開始時のシミュレータの様子](./src/fig/simulator-in-simulation.eps){width=0.8\linewidth}

## イベントの実行

送信または受信イベントの実行は以下の手順で行う。

1. イベントを生起させるためにプロセスの[Event]セルをクリックする。[Event]セルには、現在そのプロセスが実行可能なイベントの件数が示されている。
2. 図\ref{fig:select-event-dialog}のダイアログで、プロセスが実行可能なイベントを選択できるので、実行したいイベントを選択し、それが受信イベントの場合はメッセージの送信元のプロセスを選択する。
3. ダイアログ下部の[Execute]をクリックして実行する。[Cancel]をクリックすると何もせずダイアログを閉じる。

![実行するイベントを選択するダイアログ](./src/fig/select-event-dialog.eps){width=0.4\linewidth}

プロセスはイベントを実行すると、アルゴリズムにしたがって自身の論理ベクトル時計の自身の成分を1進める。
それと同時に仮想大域時計も1進む。本シミュレータにおいてメッセージ配送は通常、システムの仮想大域時計が進むことによって自動で行われる。
送受信イベントが生起出来ない場合や、新たに送受信イベントを行わずにメッセージ配送を行いたい場合には、
論理時計は進めずに仮想大域時計のみを1ずつ進めることで送信バッファにあるメッセージの配送が行える。
この機能は\ref{fig:null-event-button}に示す[Execute a null event]ボタンをクリックするか、メニューで[Auto]→[Execute a null event]を選択することで利用できる。

![Execute a null eventボタン](./src/fig/null-event-button.eps){width=0.1\linewidth}

# シミュレータの機能

## 実行されたイベントの取り消し機能

図\ref{fig:undo-event}の[Undo a previous event]ボタン、[Undo several previous events]ボタン、[Undo all of previous events]ボタンにより、
それぞれ1つ、任意回数、すべての直前イベントを取り消すことができる。
任意回数戻る場合には図\ref{fig:count-undo-event}のダイアログで取り消すイベント数を指定する。
イベントを取り消すと、すべてのプロセスのパラメータも当該イベント実行前の状態に戻る。
このとき、新規に実行されたシミュレーションでは、進む機能を使用してイベントの取り消しを取り消すことはできない。
履歴からシミュレーションを行っているときは、進む機能を使用することができる。

![イベントを取り消すボタン群](./src/fig/undo-event.eps){width=0.3\linewidth}

![取り消すイベント数を指定するダイアログ](./src/fig/count-undo-event.eps){width=0.4\linewidth}

## イベント生起の自動化機能

イベント生起の自動化機能は、以下の手順で行う。

1. 図\ref{fig:auto-button}の[Auto]ボタンをクリックする。または、メニューから[Auto]→[Execute events automatically]を選択する。
2. 図\ref{fig:auto-dialog}のダイアログでイベントの生起回数と実行速度を設定する。
3. ダイアログ下部の[Start]をクリックして自動化を開始する。

![Autoボタン](./src/fig/auto-button.eps){width=0.1\linewidth}

![イベント生起の自動化設定ダイアログ](./src/fig/auto-dialog.eps){width=0.5\linewidth}

また、イベント生起の自動化を実行中に、意図的にイベント生起を止めたい場合には、図\ref{fig:stop-button}に示す[Stop]ボタンをクリックする。
または、メニューから[Auto]→[Stop the execution]を選択する。

![Stopボタン](./src/fig/stop-button.eps){width=0.1\linewidth}

## 実行したシミュレーションの保存・再生

本シミュレータの履歴機能にはコマンド履歴とテキスト履歴がある。
コマンド履歴はシミュレーションを再現するため、テキスト履歴はシミュレーションの様子をテキストから読み取るためのものである。

コマンド履歴の保存は以下の手順で行う。
コマンド履歴ファイルは.cmdという拡張子で保存される。

1. メニューから[Simulation]→[Export]→[Event history]を選択する。
2. つづいて現れるダイアログで保存するディレクトリを指定し、[Save]をクリックする。

テキスト履歴の保存は以下の手順で行う。
テキスト履歴ファイルは.txtという拡張子で保存される。

1. メニューから[Simulation]→[Export]→[Event history in text format]を選択する。
2. つづいて現れるダイアログで保存するディレクトリを指定し、[Save]をクリックする。

コマンド履歴からシミュレーションを再現は以下の手順を行う。

1. 図\ref{fig:history-button}の[History]ボタンをクリックする。または、メニューから[Simulation]→[Start]→[Simulation from history]を選択する。
2. 図\ref{fig:select-das-dialog}のダイアログで、再現するシミュレーションのアルゴリズムのdasファイルを選択する。
3. 図\ref{fig:select-cmd-dialog}のダイアログで、再現するシミュレーションのcmdファイルを選択する。
4. イベントを生起させ、シミュレーションを進める。

![Historyボタン](./src/fig/history-button.eps){width=0.1\linewidth}

![cmdファイル選択ダイアログ](./src/fig/select-cmd-dialog.eps){width=0.3\linewidth}

イベントを生起させるには、図\ref{fig:execute-next-event}の[Execute a next event]ボタン、[Execute several next events]ボタン、
[Execute all of next events]ボタンにより、それぞれ1つずつ、任意回数、すべてのイベントを実行することができる。

![コマンド履歴のイベントを実行するボタン群](./src/fig/execute-next-event.eps){width=0.3\linewidth}

また、コマンド履歴からシミュレーションを再現しているときに[Event]セルからイベントを生起させると、新たな別のシミュレーションとみなされる。
そのため、戻る機能を実行してもシミュレーションの再現に戻ることはできない。

コマンド履歴からシミュレーションを再現する際には、5.4節で述べたシミュレータの起動方法に注意する。

## 実行中のシミュレーションと同じ設定での再シミュレーション

同一アルゴリズムの再シミュレーションは、以下の手順で行う。

1. 図\ref{fig:restart-button}の[Restart]ボタンをクリックする。または、メニューから[Simulation]→[Start]→[Restart simulation]を選択する。
2. 図\ref{fig:restart-confirm-dialog}のダイアログでシミュレーションを終了するか確認されるので、現在行っているシミュレーションをこのまま終了してよいならば[Yes]をクリックする。
3. シミュレーションの新規開始と同様の設定を行う。

![Restartボタン](./src/fig/restart-button.eps){width=0.1\linewidth}

![シミュレーションの終了確認ダイアログ](./src/fig/restart-confirm-dialog.eps){width=0.4\linewidth}

## デッドロックの検出機能

デッドロックの検出機能は、シミュレーションを行っているとき自動で働いているため、特別な操作を行う必要はない。
デッドロックを検出すると、図\ref{fig:deadlock-dialog}に示すダイアログが表示される。

![デッドロック検出ダイアログ](./src/fig/deadlock-dialog.eps){width=0.4\linewidth}

## ヘルプマニュアル

本シミュレータにはシミュレータ及びデスクリプタについてのヘルプマニュアルが備わっている。
それぞれメニューから[Help]→[Simulator]、[Help]→[Descriptor]を選択することで規定のブラウザ上で閲覧できる。

# サンプルアルゴリズム

ここではサンプルアルゴリズムとして実装されたLamportのアルゴリズムと前川のアルゴリズムについて説明する。

## Lamportのアルゴリズム

Lamportのアルゴリズムは、分散システムの相互排除問題を解決するためのアルゴリズムである。

このアルゴリズムにおいてすべてのプロセスはLamportの論理時計とよばれる論理ベクトル時計$v[0..N-1]$を持つ。
ここで$N$はプロセスの個数である。
この論理時計の初期値はプロセス$P_i$では$v[i]=1, v[j]=0(j \neq i)$とする。
また、プロセスは優先度付き待ち行列を持つ。
待ち行列にはプロセスに送信されたメッセージがそれに付加された時刻印の小さい順に保管される。 <!-- 同じ場合は？ -->
以下にアルゴリズムの手順を述べる。

1. 資源の使用を望むプロセス$P_i$は自分自身を含めたすべてのプロセスに自身の時刻印$v[i]$をつけた要求メッセージを送信する。
2. 要求メッセージを受け取ったプロセスは、自身の待ち行列に要求メッセージを挿入し、承認メッセージを送信元のプロセスに返す。
3. 資源を使用したいと望むプロセスは、自身の待ち行列の先頭に自身の要求メッセージがあり、かつ他のすべてのプロセスから承認メッセージを受信した場合に限り、資源の使用を許可される。
4. 資源を開放する場合は、自身の要求メッセージを自身の待ち行列から削除し、他のすべてのプロセスに資源の使用が終了したことを知らせる解放メッセージを送信する。
5. プロセスは解放メッセージを受信したとき、該当する要求メッセージを待ち行列から削除する。

Lamportのアルゴリズムは、メッセージがFIFOで届くと仮定した場合、個々の要求はその発生順で承認されるという公平性を満たす。
また、資源を使用したいと望むプロセスは、そのプロセス以外のすべてのプロセスから承認のメッセージを受け取らなければならないので、
分散システムに1つでも故障したプロセスがあると、それが回復しないかぎり資源を利用することができない。
よって、Lamportのアルゴリズムは耐故障性がないといえる。

## 前川のアルゴリズム

前川のアルゴリズムは、コータリーを用いる相互排除アルゴリズムである。

このアルゴリズムはコータリー$C$を用い、各プロセス$P_i$はコーラム$Q \in C$中のすべてのプロセスから資源の使用を許可されれば資源を使用する。
すなわち、各プロセス$P_i$はコーラム$Q$中のすべてのプロセスに要求メッセージreqを送信する。 <!-- Qの添字はいらない？ -->
このreqメッセージを受信したプロセスは、もし他のプロセスに許可を送信していない場合、即座に許可メッセージlockedを送信する。
許可を送信している場合は送信先のプロセスにロックされているという。
あるコーラム中のすべてのプロセスから許可メッセージlockedを受信すれば資源を使用できる。
資源の使用終了後は資源の使用終了メッセージreleaseをコーラム中のすべてのプロセスに送信し、ロックを解除する。

しかし、上記のアルゴリズムはデッドロックに陥る可能性がある。
そこで、前川のアルゴリズムでは、要求メッセージreqにLamportの論理時計によるタイムスタンプを付加することで、要求に優先度を付ける。
他のプロセスにロックされているプロセスが優先度の高い要求メッセージを受信した場合、
先に送信した許可メッセージを取り消し、優先度の高い要求メッセージを送信したプロセスに許可を送信する。
これによりデッドロックを解除する。

以下にアルゴリズムの詳細な手順を述べる。
また図\ref{fig:maekawa}はあるプロセス$P_j$の状態に着目して前川のアルゴリズムの動作を説明した図である。

1. 資源の使用を望むプロセス$P_i$はコーラム$Q \in C$のすべてのプロセスに要求メッセージreq($TS_i$,$P_i$)を送信する。
2. reqを受けとったプロセス$P_j$は、もし他のプロセスに許可を送信していないならば、即座に許可メッセージlockedを$P_i$に送信する。
3. 他のプロセス$P_k$が$P_j$をロックしていたときには、$P_j$はreqを待ち行列$QUEUE_j$に挿入する。$QUEUE_j$にはいくつかのreqが時刻印順に保持されている。
	a. もしも$P_k$のreqまたは$QUEUE_j$に保存されているreqのどれかが、$P_i$のreqよりも古い時刻印を持つならば$P_j$は$P_i$にメッセージfailedを返す。
	b. そうでなければ、$P_j$は$P_k$にメッセージinquireを送信し、$P_k$がfailedを受信しているかどうかを照会する。
4. $P_k$が$P_j$にreleaseを送信しておらず、かつ$P_k$がfailedを受信しているならばメッセージrelinquishを$P_j$に返す。
5. $P_j$が$P_k$のrelinquishを受信したならば
	1. req($TS_k$, $P_k$)を$QUEUE_j$に挿入する。その前から$QUEUE_j$にあったreqの中で最古の時刻印を持つreq($TS_h$, $P_h$)を取り出し、そのメッセージを送信したプロセス$P_h$に対しlockedを送る。
	2. $P_h \neq P_i$ならば$P_i$にfailedを送信する。
6. $P_i$がQに属するすべてのプロセスからlockedを受信したならば、資源を使用する。
7. 資源の使用が終了したら、$P_i$は$Q$に属するすべてのプロセスにreleaseを送信する。
8. $P_j$が$P_i$からreleaseを受信したら、$P_i$によるロックを解除する。待ち行列$QUEUE_j$が空でなければ
	1. 待ち行列$QUEUE_j$にあるreqの中で最古の時刻員を持つreq($TS_h$,$P_h$)を取り出し、プロセス$P_h$にlockedを送る。
	2. もしも受信したreleaseが、プロセス$P_l$の求めに応じて$P_j$が$P_i$に送信したinquireに対する応答の代わりであるときに、$P_h \neq P_l$ならば$P_l$にfailedを送信する。

![前川のアルゴリズムにおけるプロセス$P_j$の$P_i$に関する状態遷移](./src/fig/maekawa.eps){width=0.8\linewidth}

前川のアルゴリズムはLamportのアルゴリズムに比べて耐故障性が優れている。
Lamportのアルゴリズムではシステム上のすべてのプロセスが正常に動作している必要があったが、
前川のアルゴリズムでは少なくとも選択したコーラムに含まれるプロセスが動作していれば十分であるからである。
