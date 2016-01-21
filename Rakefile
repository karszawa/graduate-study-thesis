task :default => ["build", 'clean']

NAME = "thesis"

def preprocess
	Dir.glob("src/*.md").map do |md|
    preprocessed = md.sub(".md", ".preprocessed.md")
		`ruby preprocess.rb #{md} -o #{preprocessed}`
  end
end

def pandoc
	Dir.glob("src/*.preprocessed.md").map do |md|
    tex = md.sub(".preprocessed.md", ".tex")
    `pandoc -f markdown -t latex --smart #{md} -o #{tex}`
  end
end

def latex
	puts `latexmk src/#{NAME}.tex`
  `mv #{NAME}.pdf build/`
end

task :build do
	preprocess
	pandoc
  latex
end

task :preprocess do preprocess end
task :pandoc do pandoc end
task :latex do latex end

task :clean do
	Dir.glob("src/*.preprocessed.md").map do |md|
		`rm #{md}` if File.exist?(md)
	end
	
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
