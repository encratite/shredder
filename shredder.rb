require 'nil/file'

def generateRandomName
  length = 16
  symbols = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
  string = ''
  length.times do
    string += symbols[rand(symbols.size)]
  end
  return string
end

def generateUniqueRandomName(excludedNames)
  while true
    output = generateRandomName
    if excludedNames.include?(output)
      next
    end
    return output
  end
end

def overwriteFiles(path)
  directories, files = Nil.readDirectory(path, true)
  directories.each do |directory|
    overwriteFiles(directory.path)
  end
  fileNames = []
  files.each do |file|
    fileNames << file.name
  end
  files.each do |file|
    newFileName = generateUniqueRandomName(fileNames)
    newFilePath = Nil.joinPaths(File.dirname(file.path), newFileName)
    File.rename(file.path, newFilePath)
    commandline = "shred -n 0 -z -u \"#{newFilePath}\""
    puts "Executing: #{commandline}"
    `#{commandline}`
  end
  directoryNames = []
  directories.each do |directory|
    directoryNames << directory.name
  end
  directories.each do |directory|
    newDirectoryName = generateUniqueRandomName(directoryNames)
    newDirectoryPath = Nil.joinPaths(File.dirname(directory.path), newDirectoryName)
    File.rename(directory.path, newDirectoryPath)
  end
end

if ARGV.size != 1
  puts 'Usage:'
  puts "ruby #{File.basename(__FILE__)} <directory>"
  exit
end

overwriteFiles(ARGV.first)
