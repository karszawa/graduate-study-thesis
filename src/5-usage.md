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

![起動画面]

シミュレータを起動する場合には[Simulator]を、デスクリプタを起動する際には[Descriptor]をクリックすればよいが、その前にConfigure Pathsで設定をする必要がある。
図\ref{fig:configure-paths}はパスの設定画面である。
ここで、tools.jar及びシミュレーションを行うdasファイルのあるディレクトリの指定をしなければならない。
なおtools.jarはデスクリプタで、dasファイルのあるディレクトリはシミュレータでしか使わないので、どちらか片方しか使用しない場合は使わない方の設定はしなくても問題ない。

![Configure Paths]

# 分散アルゴリズムの記述

## モデル情報の入力

分散アルゴリズムの記述に使用するデスクリプタの初期画面を図\ref{fig:initial-descriptor}に示す。

![デスクリプタの初期画面]

メニューから[File]→[New]を選択し、出現するダイアログでシステムディレクトリを指定する。
次に出現するダイアログでは作成するアルゴリズムのシステム名を入力する。
そうすると、図\ref{fig:descriptor-inuse}のような画面になる。
ここで、画面左のツリーからノードを選択すると、画面右にモデル情報タブが表示されるので、画面下部の[Add]、[Modify]、[Delete]ボタンからモデル情報を編集する。

モデルはアルゴリズムごとにVariableモデル、Stateモデル、Eventモデル、Parameterモデル、及びMessageモデルがある。
Eventモデルの入力時に受信イベントで受信するメッセージの種別は、Messageモデルとして入力したものから選択することになる。

デフォルトのパラメータとして、Variableモデルには「Health」、Stateモデルには「tranquil」、[critical」「failed」、
Parameterモデルには「processID」、「numberOfProcess」、「FailureProbability」、「coterie」がある。
特に、Stateモデルの「failed」とParameterモデルのすべてパラメータはシステムに必須であるため変更・削除してはならない。

Parameterモデルのパラメータの変数の型として選択できるのはラッパークラスのInteger型とDouble型のみであるので注意が必要である。
また、Messageモデルのパラメータにはint型やdouble型などの基本データ型が使用できる。

モデル情報の入力が完了したら、メニューから[Function]→[Output a skeleton code]を選択し出現するダイアログでスケルトンコードを生成したいアルゴリズムを選択する。
これによりシステムディレクトリ及び、その内部にスケルトンコードが生成される。
ユーザはプロセス処理の記述に移行する前に、入力したモデル情報に誤りがないかを確認するため、図\ref{fig:build-button}をクリックしビルドを実行することが推奨される。

![ビルドボタン]

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
  \begin{tabular}{|l|l|l|}
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
ビルド時はダイアログが出現し、プロセス処理の記述に含まれるエラーやシステムファイルのバージョンエラーが表示される。
エラーが生じた場合、システムは直前のビルド成功後の状態から更新されない。
ビルド成功時のダイアログを図\ref{fig:build-completd}に示す。

![ビルド成功時の様子]

# シミュレーション

## シミュレーションの開始

シミュレーションの開始は以下の手順で行う。

1. 

## イベントの実行

# シミュレータの機能

## 実行されたイベントの取り消し機能

## イベント生起の自動化機能

## 実行したシミュレーションの保存・再生

## 実行中のシミュレーションと同じ設定での再シミュレーション

## デッドロックの検出機能

## ヘルプマニュアル

# サンプルアルゴリズム

## Lamportのアルゴリズム

## 前川のアルゴリズム

