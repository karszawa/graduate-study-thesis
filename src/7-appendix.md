付録CDにH-DASのクラスファイル、ソースファイル、及びサンプルアルゴリズムのソースファイルを収録した。
CD内のディレクトリ構造は図\ref{fig:directory}に示すとおりである。

\begin{figure}[htbp]
	\centering
	\includegraphics[width=0.5\linewidth]{./src/fig/directory.eps}
	\caption{ディレクトリ構造 \label{fig:directory}}
\end{figure}

binディレクトリにはクラスファイルが、srcディレクトリにはソースファイルが格納されている。
クラスファイルとソースファイルはパッケージ構造に対応したディレクトリ構造で格納されているが、図では省略している。
algorithmsディレクトリには5つのサンプルアルゴリズムのソースファイルが格納されている。

各サンプルアルゴリズムがどういうアルゴリズムであるかを簡単に説明する。
centralizedアルゴリズムは、1つのプロセスをcoordinatorとし、coordinatorが各プロセスに共有資源を割り当てていくアルゴリズムである。
deadlockアルゴリズムはデッドロックを引き起こすアルゴリズムである。
lamportアルゴリズムは資源を占有的に使用するプロセスをメッセージの時刻印に基づいて決定するアルゴリズムである。
leader_electionアルゴリズムはリーダー選出問題を解決するChang-Robertsのアルゴリズムを実現しており、
最もプロセス番号が大きいものをリーダーとして決定するアルゴリズムである。
maekawaアルゴリズムは、コータリーを用いて相互排除を実現するアルゴリズムである。
