task :default => ["build", 'clean']

NAME = "thesis"

def pandoc
	Dir.glob("src/*.md").map do |md|
    tex = md.sub(".md", ".tex")
    `pandoc -f markdown -t latex --smart #{md} -o #{tex}`
  end
end

def latex
	puts `latexmk src/#{NAME}.tex`
  `mv #{NAME}.pdf build/`
end

task :build do
	pandoc
  latex
end

task :pandoc do pandoc end
task :latex do latex end

task :clean do
  Dir.glob("src/*.md").map do |md|
    tex = md.sub(".md", ".tex")
		`rm #{tex}` if md != 'src/thesis.tex' and File.exist?(tex)
  end

	[NAME + ".bbl", NAME + "-blx.bib", NAME + ".run.xml"].each do |file|
		`rm #{file}` if File.exist?(file)
	end
	
	puts `latexmk -C src/thesis.tex`
end

task :open do
  `open build/thesis.pdf`
end

task :eps do
  Dir.glob('src/fig/**/*.png').each do |png|
    eps = png.sub(".png", ".eps")
    `convert #{png} eps2:#{eps}`
  end
end
