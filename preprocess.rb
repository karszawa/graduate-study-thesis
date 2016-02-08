source = ARGV[0]
dest = "" 

(ARGV.length - 1).times do |i|
	dest = ARGV[i+1] if ARGV[i] == "-o" 
end

File.open(dest, "w") do |file|
	File.foreach(source) do |line|
		# @key => ~\cite{key}
		line.gsub!(/@(\w+)/, '~\cite{\1}')
		
		# @{key} => ~\ref{key}
		line.gsub!(/@{(\w+)}/, '~\ref{\1}')
		
		# #{key} => ~\label{key}
		line.gsub!(/\#{(\w+)}/, '\label{\1}')
		
		# ![caption][option](path) =>
		# \begin{figure}[htbp]
		# 	\centering
		# 	\includegraphics[option]{path}
		# 	\caption{caption \label{fig:filename(exclude extension)}}
		# \end{figure}
		line.gsub!(/^!\[(.+)\]\(((?:.*\/)*(.+)\..*)\)\{(.+)\}/, "\\begin{figure}[htbp]\n\t\\centering\n\t\\includegraphics[\\4]{\\2}\n\t\\caption{\\1 \\label{fig:\\3}}\n\\end{figure}")
		
		puts line
		file.write(line)
	end
end
