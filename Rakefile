task :default => ["build", 'clean']

name = "thesis"

task :build do
  Dir.glob("src/*.md").map do |md|
    tex = md.sub(".md", ".tex")
    `pandoc -f markdown -t latex --smart #{md} -o #{tex}`
  end
	
  puts `latexmk src/#{name}.tex`
  `mv #{name}.pdf build/`
end

task :clean do
  Dir.glob("src/*.md").map do |md|
    tex = md.sub(".md", ".tex")
		`rm #{tex}` if md != 'src/thesis.tex' and File.exist?(tex)
  end

	[name + ".bbl", name + "-blx.bib", name + ".run.xml"].each do |file|
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
