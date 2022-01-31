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
* Integrate recordings of the [UNH Thompson Hall Clock](https://www.youtube.com/watch?v=pmfMDvX646g) chimes
    * bang.wav replaced (original is bang-bak.wav)
* Plays chimes based on [Westminster Chimes cadence](https://en.wikipedia.org/wiki/Westminster_Quarters)

**Installation/Use**
```
#Linux:
# Pull down the code to your local system:
sudo git clone https://github.com/yllekz/talking-clock /usr/share/talking-clock

# Make script executable + run it:

# Linux - If you like bash:
`sudo chmod +x /usr/share/talking-clock/source/talking-clock`
cd /usr/share/talking-clock/source && ./talking-clock

# Linux - If you like PowerShell:
sudo chmod +x /usr/share/talking-clock/source/talking-clock-ps.ps1
cd /usr/share/talking-clock/source && pwsh -file ./talking-clock-ps.ps1

######

# macOS - <Coming someday>

######

# Windows:
# simply clone this repo to ANY file location you wish, and run talking-clock-ps.ps1
```

**Compatibility**
* Tested and working on Linux Mint Cinnamon 20.2
    * Requires [PowerShell](https://github.com/powershell/powershell/) if using the PowerShell script
* Tested with inconclusive results on Windows 10 via Ubuntu on Windows Subsystem for Linux (need to run this as a prereq: `sudo apt install alsa-utils`)
    * While the script itself will execute just fine, I ran into issues with `aplay` not finding the sound card. [This article](https://research.wmz.ninja/articles/2017/11/setting-up-wsl-with-graphics-and-audio.html) might help but it's quite a setup that isn't really worth it.
    * As a workaround, I ported of the Bash script to PowerShell, using .NET invocations to play the chimes. Check out the "talking-clock-ps.ps1" file if you want to use this on Windows, as this will work. It's not a one-to-one port, but the fundamentals are there.
* PowerShell script now supports Linux as well if you'd rather use that. macOS compatibility will arrive some time in the future.
* Not yet tested on macOS

**Notes**
* By default, the Bash script will run in the background and write the time (every 60 seconds) to console you invoked it on (if you left it open).
* By default, the Bash script looks for wav files in `/usr/share/talking-clock/source/sound/_.wav`
* At the top of the hour, a full chime will play
* If using the Bash script, to see if it's running: `ps -aux | grep talking`
    * Or open `htop` and search for `talking-clock` if `ps` does not show it.
* If using the Bash script, to end it: ``killall talking-clock``

**TODO:**
* [from original repo] consider replacing *aplay* with *play* from *sox* package for volume control option.
* [from original repo] fix config file issue
* [from original repo] update grep usage with if
