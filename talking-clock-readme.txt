#Random incoherent notes on getting this working:

#sudo git clone https://github.com/yllekz/talking-clock /usr/share/talking-clock
#[DONE] Replace default chime with the UNH one:
#sudo mv /usr/share/talking-clock/source/sound/bang.wav /usr/share/talking-clock/source/sound/bang-bak.wav
#sudo cp ~/Desktop/unhhourly.wav /usr/share/talking-clock/source/sound/bang.wav
#sudo cp ~/Desktop/unhhourlychime.wav unhhourlychime.wav
#[FIXED] Now fix the issue where the wav files are in the wrong place (script wants them in the script root dir):
#cd /usr/share/talking-clock/source/sound/ && sudo mv *.wav /usr/share/talking-clock/

#Set as executable + run the script:
#sudo chmod +x /usr/share/talking-clock/source/talking-clock
#cd /usr/share/talking-clock/source && ./talking-clock

#By default, this will run in the background and write the time (every 60 minutes) to console
#By default, it looks for wav files in /usr/share/talking-clock/_.wav
#Example, at 3pm it looks to play:
#/usr/share/talking-clock/bang.wav
#/usr/share/talking-clock/3.wav
#/usr/share/talking-clock/0.wav
#/usr/share/talking-clock/0.wav

#wait till the top of the hour to hear the chime

#see if it's running:
#ps | grep talking

#to end it:
#killall talking-clock

#TODO: Things to work thru:
#bang.wav is played for more than just hourly, it's played for quarter past and half past