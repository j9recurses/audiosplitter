require 'rubygems'
#require 'streamio-ffmpeg'
require 'fileutils'

#rip out the audio
def getAudio(fn, outdir)
  puts fn
  #return movie object; can get lots of meta data properties from the object
  #movie = FFMPEG::Movie.new(fn)
  fn = fn.gsub(" ", "\\ ")
  puts fn
  mvcmd = "mv "+ fn  + " " + fn.downcase.gsub(" ", "_").gsub('"', "")
  puts mvcmd
  mvfn = system(mvcmd)
  fn = fn.downcase.gsub(" ", "_").gsub('"', "")
  fnsplt = fn.split(".mp4")
  fnsplt = fnsplt.join("")
  fnsplt = outdir + fnsplt + "_splt.mp3"
  puts fnsplt
  #ffmpeg -i video.mp4 -f mp3 -ab 192000 -vn music.mp3
  #The -i option in the above command is simple: it is the path to the input file.
  #The second option -f mp3 tells ffmpeg that the ouput is in mp3 format.
  #The third option i.e -ab 192000 tells ffmpeg that we want the output to
  #be encoded at 192Kbps and -vn tells ffmpeg that we dont want video.
  #The last param is the name of the output file.
  cmd = "ffmpeg -i "+ fn +" -f mp3 -ab 192000 -vn "+ fnsplt
  puts cmd
  system(cmd)
end

def download_vids(vidlnk)
  vidcmd = "youtube-dl -o \"%(title)s.%(ext)s\" " + vidlnk+  '  --write-thumbnail'
  system(vidcmd)
end



dir = Dir.pwd
dirfiles = Dir["*.mp4"]

audioOut = "audio/"
#vidOut = "vids/"
vidlist = "vidlist.txt"

unless File.directory?(audioOut)
  FileUtils.mkdir_p(audioOut)
end
# unless File.directory?(vidOut)
# #   FileUtils.mkdir_p(vidOut)
# # end

File.open(vidlist).each do |vidlnk|
  puts "*******"
  puts vidlnk
  vidlnk = vidlnk.strip().chomp()
  download_vids(vidlnk)
end

puts dirfiles
dirfiles.each do | vidfile|
  puts vidfile
  getAudio(vidfile, audioOut)
end

