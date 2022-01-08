# talking-clock, slightly improved version

```bash
talking-clock:
-f [n]
    n: 5, 15, 30 ( min frequency )
    by default it plays chimes on Westminster cadence (short chime on 15/30/45 minutes past the hour) and will play a clock bell striking sound x times based on the hour.
-s
    stops clock
```

**Changes/Improvements from the original/other forks**
* Make the script's default actions nonverbal chimes.
* Easy-to-read instructions on how to install/use
* Bugfix: Script didn't correctly point to the wav files
* Integrate the UNH Clock's Westminster chime to mimic an IRL clock sound
    * bang.wav replaced with UNH's version (original is bang-bak.wav)
* Plays chimes based on [Westminster Chimes cadence](https://en.wikipedia.org/wiki/Westminster_Quarters)

**Installation/Use**
```
# Pull down the code to your local system:
sudo git clone https://github.com/yllekz/talking-clock /usr/share/talking-clock

# Make script executable + run it:
sudo chmod +x /usr/share/talking-clock/source/talking-clock
cd /usr/share/talking-clock/source && ./talking-clock
```

**Compatibility**
* Tested and working on Linux Mint Cinnamon 20.2
* Tested with inconclusive results on Windows 10 via Ubuntu on Windows Subsystem for Linux (need to run this as a prereq: `sudo apt install alsa-utils`)
    * While the script itself will execute jus fine, I ran into issues with `aplay` not finding the sound card. [This article](https://research.wmz.ninja/articles/2017/11/setting-up-wsl-with-graphics-and-audio.html) might help but I'm not sure yet.
* Not yet tested on macOS

**Notes**
* By default, the script will run in the background and write the time (every 60 seconds) to console you invoked it on (if you left it open).
* By default, it looks for wav files in `/usr/share/talking-clock/source/sound/_.wav`
* At the top of the hour, a full chime will play
* To see if it's running: `ps | grep talking` or open `htop` and search for `talking-clock` if `ps` does not show it.
* To end it: ``killall talking-clock``

**TODO:**
* [from original repo] consider replacing *aplay* with *play* from *sox* package for volume control option.
* [from original repo] fix config file issue
* [from original repo] update grep usage with if
